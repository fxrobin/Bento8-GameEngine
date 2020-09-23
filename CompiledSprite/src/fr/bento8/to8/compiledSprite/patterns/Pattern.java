package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.InstructionSet.Register;
import fr.bento8.to8.compiledSprite.Snippet;

public abstract class Pattern {

	protected int nbPixels;
	protected int nbBytes;

	protected boolean useIndexedAddressing;
	protected boolean isBackgroundBackupAndDrawDissociable;
	protected List<boolean[]> resetRegisters = new ArrayList<boolean[]>();
	protected List<boolean[]> registerCombi = new ArrayList<boolean[]>();

	public abstract boolean matchesForward (byte[] data, int offset);
	public abstract boolean matchesRearward (byte[] data, int offset);

	public abstract List<String> getDrawCode (byte[] data, int position, List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception;
	public abstract int getDrawCodeCycles (List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception;	
	public abstract int getDrawCodeSize (List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception;

	public List<String> getBackgroundBackupCode (List<Integer> registerIndexes, int offset) throws Exception {
		List<String> asmCode = new ArrayList<String>();
		String puls = "\tPULS ";
		String pshu = "\tPSHU ";
		boolean firstPass;
		int nbBytesPuls = 0;

		for (Integer reg : registerIndexes) {
			if (reg != Register.S) {
				nbBytesPuls += Register.size[reg];
			}
		}

		if (nbBytesPuls <= 2) {
			asmCode.add("\tLD"+Register.name[registerIndexes.get(0)]+" "+(offset!= 0?offset:"")+",S");
		} else {
			firstPass = true;
			for (int i=0; i<registerIndexes.size(); i++) {
				if (registerIndexes.get(i) != Register.S) { 
					// Création du PULS
					if (firstPass) {
						puls += Register.name[registerIndexes.get(i)];
						firstPass = false;
					} else {
						puls += ","+Register.name[registerIndexes.get(i)];
					}
				}
			}
			asmCode.add(puls);
		}

		firstPass = true;
		for (int i=0; i<registerIndexes.size(); i++) {
			// Création du PSHU
			if (firstPass) {
				pshu += Register.name[registerIndexes.get(i)];
				firstPass = false;
			} else {
				pshu += ","+Register.name[registerIndexes.get(i)];
			}
		}
		asmCode.add(pshu);

		return asmCode;
	}

	public int getBackgroundBackupCodeCycles (List<Integer> registerIndexes, int offset) throws Exception {
		int cycles = 0;
		int nbBytesPuls = 0;
		int nbBytesPshu = 0;

		for (Integer reg : registerIndexes) {
			if (reg != Register.S) {
				nbBytesPuls += Register.size[reg];
			}
			nbBytesPshu += Register.size[reg];
		}

		if (nbBytesPuls <= 2) {
			cycles += Register.costIndexedLD[registerIndexes.get(0)] + Register.getIndexedOffsetCost(offset);
		} else {
			cycles += Register.getCostImmediatePULPSH(nbBytesPuls);
		}
		cycles += Register.getCostImmediatePULPSH(nbBytesPshu);

		return cycles;
	}

	public int getBackgroundBackupCodeSize (List<Integer> registerIndexes, int offset) throws Exception {
		int size = 0;
		int nbBytesPuls = 0;

		for (Integer reg : registerIndexes) {
			if (reg != Register.S) {
				nbBytesPuls += Register.size[reg];
			}
		}

		if (nbBytesPuls <= 2) {
			size += Register.sizeIndexedLD[registerIndexes.get(0)] + Register.getIndexedOffsetSize(offset);
		} else {
			size += Register.sizeImmediatePULPSH;
		}
		size += Register.sizeImmediatePULPSH;
		return size;
	}

	private static void addToEraseBuf (List<Snippet> solution, List<Integer> snippetBBIdx, List<Integer> nbBytesE, List<Integer> offsetE) throws Exception {

		snippetBBIdx.clear();
		nbBytesE.clear();
		offsetE.clear();

		// Pour chaque pattern de sauvegarde des données du fond
		// On enregistre l'index de la méthode dans la solution
		// Le nombre d'octets de données du PSHU
		// L'offset associé au registre, s'il n'y a qu'un seul registre (cette valeur est 0 dans le cas de plusieurs registres)

		Snippet s;
		for (int i = 0; i < solution.size(); i++) {
			s = solution.get(i);
			if (s.getMethod() == Snippet.BACKGROUND_BACKUP) {
				snippetBBIdx.add(i);

				int size = 0, count = 0;
				for (int j = 0; j < s.getRegisterIndexes().size(); j++) {
					if (s.getRegisterIndexes().get(j) != Register.S) {
						size += Register.size[s.getRegisterIndexes().get(j)];
						count += 1;
					}
				}
				nbBytesE.add(size);

				if (count == 1) {
					offsetE.add(s.getOffset());
				} else {
					offsetE.add(0);
				}
			}
		}
	}

	public static List<String> getEraseCodeBuf (boolean saveS, List<Snippet> solution) throws Exception {
		boolean[] regECache = new boolean[]{false, false, false, false, false, false, false};
		Integer[] offsetECache = new Integer[]{null, null, null, null, null, null, null};
		List<String> asmECode = new ArrayList<String>();
		String read = "", writeSB = "";
		String readInit = "\tPULU ";
		String writeSBInit = "\tPSHS ";
		String writeSTInit = "\tST";
		List<String> writeST = new ArrayList<String>();
		List<Integer> currentRegisters = new ArrayList<Integer>();
		int offsetSB = 0;
		boolean forceFlush = false;

		// Variables pour le code de retablissement du fond
		List<Integer> snippetBBIdx = new ArrayList<Integer>();
		List<Integer> nbBytesE = new ArrayList<Integer>();
		List<Integer> offsetE = new ArrayList<Integer>();

		// Construction des données de travail concernant le code de sauvegarde des données de fond
		addToEraseBuf(solution, snippetBBIdx, nbBytesE, offsetE);

		// S est a charger sur le premier PULU pour le positionnement de la destination
		if (saveS) {
			regECache[Register.S] = true;
		}

		int posR = nbBytesE.size() - 1;
		// Parcours de toutes les données sauvegardées et construction du code de retablissement du fond
		while (posR >= 0) {
			currentRegisters.clear();

			if (nbBytesE.get(posR) == 1) {
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.A);
					offsetECache[Register.A] = offsetE.get(posR);
				} else if (!regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.B);
					offsetECache[Register.B] = offsetE.get(posR);
				}
			} else if (nbBytesE.get(posR) == 2) {
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.D);
					offsetECache[Register.D] = offsetE.get(posR);
				} else if (!regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = offsetE.get(posR);
				} else if (!regECache[Register.Y]) {
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = offsetE.get(posR);
				}
			} else if (nbBytesE.get(posR) == 3) {
				forceFlush = true;
				if (!regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.B);
					offsetECache[Register.B] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
				}
			} else if (nbBytesE.get(posR) == 4) {
				forceFlush = true;
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.D);
					offsetECache[Register.D] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
				} else if (!regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = null;
				}
			} else if (nbBytesE.get(posR) == 5) {
				forceFlush = true;
				if (!regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.B);
					offsetECache[Register.B] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = null;
				}
			} else if (nbBytesE.get(posR) == 6) {
				forceFlush = true;
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.D);
					offsetECache[Register.D] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = null;
				}
			}

			if (currentRegisters.size() > 0) {
				for (int i = 0; i < currentRegisters.size(); i++ ) {
					regECache[currentRegisters.get(i)] = true;
				}
				posR--;
			}

			if (currentRegisters.size() == 0 || posR < 0 || forceFlush) {

				forceFlush = false;

				// on ecrit les instructions du cache, on purge le cache et on reboucle sans décrémenter posR
				offsetSB = 0;
				for (int i = 0; i < regECache.length; i++ ) {
					if (regECache[i]) {

						// Construction du pulu (lecture des données sauvegardées)
						if (read.equals("")) {
							read = readInit + Register.name[i];
						} else {
							read += "," + Register.name[i];
						}

						// Construction du pshs (ecriture des données sauvegardées)
						// Le pshs est utilisé uniquement si le S a été sauvegardé avec le pulu correspondant, sinon on utilise les ST
						if (offsetECache[i] == null && i != Register.S && (regECache[Register.S] && posR+1 == nbBytesE.size()-1)) { // On ne traite pas S
							if (writeSB.equals("")) {
								writeSB = writeSBInit + Register.name[i];
							} else {
								writeSB += "," + Register.name[i];
							}
						}

						// Construction des st (ecriture des données sauvegardées)
						if (offsetECache[i] == null && (regECache[Register.S] && posR+1 != nbBytesE.size()-1) && i != Register.S) {
							offsetSB += Register.size[i];
							writeST.add(writeSTInit + Register.name[i] + " "+offsetSB+",S");
						} else if (offsetECache[i] != null) {
							writeST.add(writeSTInit + Register.name[i] + " "+(offsetECache[i]!= 0?offsetECache[i]:"")+",S");
						}
					}
					regECache[i] = false;
					offsetECache[i] = null;
				}

				asmECode.add(read);
				if (!writeSB.equals("")) {
					asmECode.add(writeSB);
				}
				if (writeST.size() > 0) {
					asmECode.addAll(writeST);
				}
				asmECode.add("");

				read = "";
				writeSB = "";
				writeST.clear();
			}
		}

		return asmECode;
	}

	public static void optimEraseCodeBuf (boolean saveS, List<Snippet> solution) throws Exception {

		if (!saveS) {
			return;
		}

		// S est a charger sur le premier PULU pour le positionnement de la destination
		boolean[] regECache = new boolean[]{false, false, false, false, false, false, true};
		Integer[] offsetECache = new Integer[]{null, null, null, null, null, null, null};
		List<Integer> currentRegisters = new ArrayList<Integer>();
		boolean forceFlush = false;

		// Variables pour le code de retablissement du fond
		List<Integer> snippetBBIdx = new ArrayList<Integer>();
		List<Integer> nbBytesE = new ArrayList<Integer>();
		List<Integer> offsetE = new ArrayList<Integer>();

		// Construction des données de travail concernant le code de sauvegarde des données de fond
		addToEraseBuf(solution, snippetBBIdx, nbBytesE, offsetE);

		int posR = nbBytesE.size() - 1;
		// Parcours de toutes les données sauvegardées et construction du code de retablissement du fond
		while (posR >= 0) {
			currentRegisters.clear();

			if (nbBytesE.get(posR) == 1) {
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.A);
					offsetECache[Register.A] = offsetE.get(posR);
				} else if (!regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.B);
					offsetECache[Register.B] = offsetE.get(posR);
				}
			} else if (nbBytesE.get(posR) == 2) {
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.D);
					offsetECache[Register.D] = offsetE.get(posR);
				} else if (!regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = offsetE.get(posR);
				} else if (!regECache[Register.Y]) {
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = offsetE.get(posR);
				}
			} else if (nbBytesE.get(posR) == 3) {
				forceFlush = true;
				if (!regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.B);
					offsetECache[Register.B] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
				}
			} else if (nbBytesE.get(posR) == 4) {
				forceFlush = true;
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.D);
					offsetECache[Register.D] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
				} else if (!regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = null;
				}
			} else if (nbBytesE.get(posR) == 5) {
				forceFlush = true;
				if (!regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.B);
					offsetECache[Register.B] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = null;
				}
			} else if (nbBytesE.get(posR) == 6) {
				forceFlush = true;
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.D);
					offsetECache[Register.D] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = null;
				}
			}

			if (currentRegisters.size() > 0) {
				for (int i = 0; i < currentRegisters.size(); i++ ) {
					regECache[currentRegisters.get(i)] = true;
				}
				posR--;
			}

			if (currentRegisters.size() == 0 || posR < 0 || forceFlush) {
				solution.get(snippetBBIdx.get(posR+1)).addRegister(Register.S);
				break;
			}
		}
	}

	public static int getEraseCodeBufCycles (boolean saveS, List<Snippet> solution) throws Exception {
		int cycles = 0;
		boolean[] regECache = new boolean[]{false, false, false, false, false, false, false};
		Integer[] offsetECache = new Integer[]{null, null, null, null, null, null, null};

		List<Integer> currentRegisters = new ArrayList<Integer>();
		int offsetSB = 0;
		boolean forceFlush = false;

		// Variables pour le code de retablissement du fond
		List<Integer> snippetBBIdx = new ArrayList<Integer>();
		List<Integer> nbBytesE = new ArrayList<Integer>();
		List<Integer> offsetE = new ArrayList<Integer>();

		// Construction des données de travail concernant le code de sauvegarde des données de fond
		addToEraseBuf(solution, snippetBBIdx, nbBytesE, offsetE);

		// S est a charger sur le premier PULU pour le positionnement de la destination
		if (saveS) {
			regECache[Register.S] = true;
		}

		int posR = nbBytesE.size() - 1;
		// Parcours de toutes les données sauvegardées et construction du code de retablissement du fond
		while (posR >= 0) {
			currentRegisters.clear();

			if (nbBytesE.get(posR) == 1) {
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.A);
					offsetECache[Register.A] = offsetE.get(posR);
				} else if (!regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.B);
					offsetECache[Register.B] = offsetE.get(posR);
				}
			} else if (nbBytesE.get(posR) == 2) {
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.D);
					offsetECache[Register.D] = offsetE.get(posR);
				} else if (!regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = offsetE.get(posR);
				} else if (!regECache[Register.Y]) {
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = offsetE.get(posR);
				}
			} else if (nbBytesE.get(posR) == 3) {
				forceFlush = true;
				if (!regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.B);
					offsetECache[Register.B] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
				}
			} else if (nbBytesE.get(posR) == 4) {
				forceFlush = true;
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.D);
					offsetECache[Register.D] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
				} else if (!regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = null;
				}
			} else if (nbBytesE.get(posR) == 5) {
				forceFlush = true;
				if (!regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.B);
					offsetECache[Register.B] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = null;
				}
			} else if (nbBytesE.get(posR) == 6) {
				forceFlush = true;
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.D);
					offsetECache[Register.D] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = null;
				}
			}

			if (currentRegisters.size() > 0) {
				for (int i = 0; i < currentRegisters.size(); i++ ) {
					regECache[currentRegisters.get(i)] = true;
				}
				posR--;
			}

			if (currentRegisters.size() == 0 || posR < 0 || forceFlush) {

				forceFlush = false;

				// on ecrit les instructions du cache, on purge le cache et on reboucle sans décrémenter posR
				offsetSB = 0;
				int nbBytesPulu = 0, nbBytesPshs = 0;
				for (int i = 0; i < regECache.length; i++ ) {
					if (regECache[i]) {

						// Construction du pulu (lecture des données sauvegardées)
						nbBytesPulu += Register.size[i];

						// Construction du pshs (ecriture des données sauvegardées)
						// Le pshs est utilisé uniquement si le S a été sauvegardé avec le pulu correspondant, sinon on utilise les ST
						if (offsetECache[i] == null && i != Register.S && (regECache[Register.S] && posR+1 == nbBytesE.size()-1)) { // On ne traite pas S
							nbBytesPshs += Register.size[i];
						}

						// Construction des st (ecriture des données sauvegardées)
						if (offsetECache[i] == null && (regECache[Register.S] && posR+1 != nbBytesE.size()-1) && i != Register.S) {
							offsetSB += Register.size[i];
							cycles += Register.costIndexedST[i] + Register.getIndexedOffsetCost(offsetSB);
						} else if (offsetECache[i] != null) {
							cycles += Register.costIndexedST[i] + Register.getIndexedOffsetCost(offsetECache[i]);
						}
					}
					regECache[i] = false;
					offsetECache[i] = null;
				}

				if (nbBytesPshs > 0) {
					cycles += Register.getCostImmediatePULPSH(nbBytesPshs);
				}
				cycles += Register.getCostImmediatePULPSH(nbBytesPulu);
			}
		}

		return cycles;
	}

	public static int getEraseCodeBufSize (boolean saveS, List<Snippet> solution) throws Exception {
		int size = 0;
		boolean[] regECache = new boolean[]{false, false, false, false, false, false, false};
		Integer[] offsetECache = new Integer[]{null, null, null, null, null, null, null};

		List<Integer> currentRegisters = new ArrayList<Integer>();
		int offsetSB = 0;
		boolean forceFlush = false;

		// Variables pour le code de retablissement du fond
		List<Integer> snippetBBIdx = new ArrayList<Integer>();
		List<Integer> nbBytesE = new ArrayList<Integer>();
		List<Integer> offsetE = new ArrayList<Integer>();

		// Construction des données de travail concernant le code de sauvegarde des données de fond
		addToEraseBuf(solution, snippetBBIdx, nbBytesE, offsetE);

		// S est a charger sur le premier PULU pour le positionnement de la destination
		if (saveS) {
			regECache[Register.S] = true;
		}

		int posR = nbBytesE.size() - 1;
		// Parcours de toutes les données sauvegardées et construction du code de retablissement du fond
		while (posR >= 0) {
			currentRegisters.clear();

			if (nbBytesE.get(posR) == 1) {
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.A);
					offsetECache[Register.A] = offsetE.get(posR);
				} else if (!regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.B);
					offsetECache[Register.B] = offsetE.get(posR);
				}
			} else if (nbBytesE.get(posR) == 2) {
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.D);
					offsetECache[Register.D] = offsetE.get(posR);
				} else if (!regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = offsetE.get(posR);
				} else if (!regECache[Register.Y]) {
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = offsetE.get(posR);
				}
			} else if (nbBytesE.get(posR) == 3) {
				forceFlush = true;
				if (!regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.B);
					offsetECache[Register.B] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
				}
			} else if (nbBytesE.get(posR) == 4) {
				forceFlush = true;
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.D);
					offsetECache[Register.D] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
				} else if (!regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = null;
				}
			} else if (nbBytesE.get(posR) == 5) {
				forceFlush = true;
				if (!regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.B);
					offsetECache[Register.B] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = null;
				}
			} else if (nbBytesE.get(posR) == 6) {
				forceFlush = true;
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.D);
					offsetECache[Register.D] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = null;
				}
			}

			if (currentRegisters.size() > 0) {
				for (int i = 0; i < currentRegisters.size(); i++ ) {
					regECache[currentRegisters.get(i)] = true;
				}
				posR--;
			}

			if (currentRegisters.size() == 0 || posR < 0 || forceFlush) {

				forceFlush = false;

				// on ecrit les instructions du cache, on purge le cache et on reboucle sans décrémenter posR
				offsetSB = 0;
				int nbBytesPshs = 0;
				for (int i = 0; i < regECache.length; i++ ) {
					if (regECache[i]) {

						// Construction du pshs (ecriture des données sauvegardées)
						// Le pshs est utilisé uniquement si le S a été sauvegardé avec le pulu correspondant, sinon on utilise les ST
						if (offsetECache[i] == null && i != Register.S && (regECache[Register.S] && posR+1 == nbBytesE.size()-1)) { // On ne traite pas S
							nbBytesPshs += Register.size[i];
						}

						// Construction des st (ecriture des données sauvegardées)
						if (offsetECache[i] == null && (regECache[Register.S] && posR+1 != nbBytesE.size()-1) && i != Register.S) {
							offsetSB += Register.size[i];
							size += Register.sizeIndexedST[i] + Register.getIndexedOffsetSize(offsetSB);
						} else if (offsetECache[i] != null) {
							size += Register.sizeIndexedST[i] + Register.getIndexedOffsetSize(offsetECache[i]);
						}
					}
					regECache[i] = false;
					offsetECache[i] = null;
				}

				if (nbBytesPshs>0) {
					size += Register.sizeImmediatePULPSH;
				}
				size += Register.sizeImmediatePULPSH;
			}
		}

		return size;
	}

	public int getNbPixels() {
		return nbPixels;
	}

	public int getNbBytes() {
		return nbBytes;
	}

	public boolean useIndexedAddressing() {
		return useIndexedAddressing;
	}

	public boolean isBackgroundBackupAndDrawDissociable() {
		return isBackgroundBackupAndDrawDissociable;
	}

	public List<boolean[]> getResetRegisters() {
		return resetRegisters;
	}

	public List<boolean[]> getRegisterCombi() {
		return registerCombi;
	}
}
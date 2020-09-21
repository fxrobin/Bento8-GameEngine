package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import fr.bento8.to8.InstructionSet.Register;

public abstract class Pattern {

	protected int nbPixels;
	protected int nbBytes;

	protected boolean useIndexedAddressing;
	protected boolean isBackgroundBackupAndDrawDissociable;
	protected List<boolean[]> resetRegisters = new ArrayList<boolean[]>();
	protected List<boolean[]> registerCombi = new ArrayList<boolean[]>();

	public abstract boolean matchesForward (byte[] data, int offset);
	public abstract boolean matchesRearward (byte[] data, int offset);

	public abstract List<String> getBackgroundBackupCode (List<Integer> registerIndexes, int offset, AtomicInteger lineNumS) throws Exception;
	public abstract int getBackgroundBackupCodeCycles (List<Integer> registerIndexes, int offset) throws Exception;
	public abstract int getBackgroundBackupCodeSize (List<Integer> registerIndexes, int offset) throws Exception;

	public abstract List<String> getDrawCode (byte[] data, int position, List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception;
	public abstract int getDrawCodeCycles (List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception;	
	public abstract int getDrawCodeSize (List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception;

	public void addToEraseBuf (List<Integer> registerIndexes, int backOffset, List<Integer> nbByteE, List<Integer> offsetE) throws Exception {
		int count = 0;

		for (int i = 0; i < registerIndexes.size(); i++) {
			count += Register.size[registerIndexes.get(i)];
		}

		nbByteE.add(count);

		if (registerIndexes.size() == 1) {
			offsetE.add(backOffset);
		} else {
			offsetE.add(0);
		}
	}

	public static List<String> getEraseCodeBuf (List<Integer> nbByteE, List<Integer> offsetE, List<String> asmCode, List<Integer> asmCodeSIdx) throws Exception {
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
		
		// Si on a besoin de charger S
		if (asmCodeSIdx.size() > 0) {
			// S est a charger sur le premier PULU pour le positionnement de la destination
			regECache[Register.S] = true;
		}

		int posR = nbByteE.size() - 1;
		// Parcours de toutes les données sauvegardées et construction du code de retablissement du fond
		while (posR >= 0) {
			currentRegisters.clear();

			if (nbByteE.get(posR) == 1) {
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.A);
					offsetECache[Register.A] = offsetE.get(posR);
				} else if (!regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.B);
					offsetECache[Register.B] = offsetE.get(posR);
				}
			} else if (nbByteE.get(posR) == 2) {
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
			} else if (nbByteE.get(posR) == 3) {
				forceFlush = true;
				if (!regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.B);
					offsetECache[Register.B] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
				}
			} else if (nbByteE.get(posR) == 4) {
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
			} else if (nbByteE.get(posR) == 5) {
				forceFlush = true;
				if (!regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.B);
					offsetECache[Register.B] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = null;
				}
			} else if (nbByteE.get(posR) == 6) {
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
				
				// Au premier passage on positionne l'écriture de S (asmCode) au bon endroit en fonction
				// de l'optimisation trouvée dans le code de rétablissenment du fond
				if (regECache[Register.S]) {
					asmCode.set(asmCodeSIdx.get(posR+1), asmCode.get(asmCodeSIdx.get(posR+1))+",S");
				}
				
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
						if (offsetECache[i] == null && i != Register.S && (regECache[Register.S] && posR+1 == nbByteE.size()-1)) { // On ne traite pas S
							if (writeSB.equals("")) {
								writeSB = writeSBInit + Register.name[i];
							} else {
								writeSB += "," + Register.name[i];
							}
						}

						// Construction des st (ecriture des données sauvegardées)
						if (offsetECache[i] == null && (regECache[Register.S] && posR+1 != nbByteE.size()-1) && i != Register.S) {
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

	public static int getEraseCodeBufCycles (List<Integer> nbByteE, List<Integer> offsetE) throws Exception {
		int cycles = 0;

		return cycles;
	}

	public static int getEraseCodeBufSize (List<Integer> nbByteE, List<Integer> offsetE) throws Exception {
		int size = 0;

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
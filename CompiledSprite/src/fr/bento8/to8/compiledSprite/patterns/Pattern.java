package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

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

	public abstract List<String> getBackgroundBackupCode (List<Integer> registerIndexes, int offset, boolean saveS) throws Exception;
	public abstract int getBackgroundBackupCodeCycles (List<Integer> registerIndexes, int offset, boolean saveS) throws Exception;
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

	public static List<String> getEraseCodeBuf (List<Integer> nbByteE, List<Integer> offsetE) throws Exception {

		boolean[] regECache = new boolean[]{false, false, false, false, false, false, true}; // S est a charger sur le premier PULU pour le positionnement de la destination
		Integer[] offsetECache = new Integer[]{null, null, null, null, null, null, null};
		List<String> asmCode = new ArrayList<String>();
		String read = "", writeSB = "";
		String readInit = "\tPULU ";
		String writeSBInit = "\tPSHS ";
		String writeSTInit = "\tST";
		List<String> writeST = new ArrayList<String>();
		List<Integer> currentRegisters = new ArrayList<Integer>();

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
				offsetE.set(posR, -1);
				if (!regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.B);
					offsetECache[Register.B] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
				}
			} else if (nbByteE.get(posR) == 4) {
				offsetE.set(posR, -1);
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
				offsetE.set(posR, -1);
				if (!regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.B);
					offsetECache[Register.B] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = null;
				}
			} else if (nbByteE.get(posR) == 6) {
				offsetE.set(posR, -1);
				if (!regECache[Register.A] && !regECache[Register.B] && !regECache[Register.D] && !regECache[Register.X] && !regECache[Register.Y]) {
					currentRegisters.add(Register.D);
					offsetECache[Register.D] = null;
					currentRegisters.add(Register.X);
					offsetECache[Register.X] = null;
					currentRegisters.add(Register.Y);
					offsetECache[Register.Y] = null;
				}
			}
			
			if (currentRegisters.size() > 0 || regECache[Register.S] == true) { // On force la purge en cas de S
				for (int i = 0; i < currentRegisters.size(); i++ ) {
					regECache[currentRegisters.get(i)] = true;
				}
				posR--;
			}
			
			if (currentRegisters.size() == 0 || regECache[Register.S] == true) {
				// on ecrit les instructions du cache, on purge le cache et on reboucle sans décrémenter posR
				for (int i = 0; i < regECache.length; i++ ) {
					if (regECache[i]) {

						// Construction du pulu (lecture des données sauvegardées)
						if (read.equals("")) {
							read = readInit + Register.name[i];
						} else {
							read += "," + Register.name[i];
						}

						// Construction du pshs (ecriture des données sauvegardées)
						if (offsetECache[i] == null && i != Register.S) { // On ne traite pas S
							if (writeSB.equals("")) {
								writeSB = writeSBInit + Register.name[i];
							} else {
								writeSB += "," + Register.name[i];
							}
						}

						// Construction des st (ecriture des données sauvegardées)
						if (offsetECache[i] != null) {
							writeST.add(writeSTInit + Register.name[i] + " "+(offsetECache[i]!= 0?offsetECache[i]:"")+",S");
						}
					}
					regECache[i] = false;
					offsetECache[i] = null;
				}

				asmCode.add(read);
				if (!writeSB.equals("")) {
					asmCode.add(writeSB);
				}
				if (writeST.size() > 0) {
					asmCode.addAll(writeST);
				}
				asmCode.add("");
				
				read = "";
				writeSB = "";
				writeST.clear();
			}
		}
		
		// fin du noeud, on ecrit les instructions du cache
		for (int i = 0; i < regECache.length; i++ ) {
			if (regECache[i]) {

				// Construction du pulu (lecture des données sauvegardées)
				if (read.equals("")) {
					read = readInit + Register.name[i];
				} else {
					read += "," + Register.name[i];
				}

				// Construction du pshs (ecriture des données sauvegardées)
				if (offsetECache[i] == null && i != Register.S) { // On ne traite pas S
					if (writeSB.equals("")) {
						writeSB = writeSBInit + Register.name[i];
					} else {
						writeSB += "," + Register.name[i];
					}
				}

				// Construction des st (ecriture des données sauvegardées)
				if (offsetECache[i] != null) {
					writeST.add(writeSTInit + Register.name[i] + " "+(offsetECache[i]!= 0?offsetECache[i]:"")+",S");
				}
			}
		}

		asmCode.add(read);
		if (!writeSB.equals("")) {
			asmCode.add(writeSB);
		}
		if (writeST.size() > 0) {
			asmCode.addAll(writeST);
		}
		asmCode.add("");
		
		return asmCode;
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
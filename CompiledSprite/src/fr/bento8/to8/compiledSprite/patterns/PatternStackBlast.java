package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.InstructionSet.Register;

public abstract class PatternStackBlast extends Pattern{

	public List<String> getBackgroundBackupCode (List<Integer> registerIndexes, int offset) throws Exception {
		List<String> asmCode = new ArrayList<String>();
		String puls = "\tPULS ";
		String pshu = "\tPSHU ";
		boolean firstPass;

		if (this.nbBytes <= 2) {
			asmCode.add("\tLD"+Register.name[registerIndexes.get(0)]+" "+offset+",S");
			asmCode.add("\tPSHU "+Register.name[registerIndexes.get(0)]);
		} else {
			firstPass = true;
			for (int i=0; i<registerIndexes.size(); i++) {
				// Création du PULS
				if (firstPass) {
					puls += Register.name[registerIndexes.get(i)];
					firstPass = false;
				} else {
					puls += ","+Register.name[registerIndexes.get(i)];
				}
			}
			asmCode.add(puls);

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
		}
		return asmCode;
	}

	public int getBackgroundBackupCodeCycles (List<Integer> registerIndexes, int offset) throws Exception {
		int cycles = 0;
		if (this.nbBytes <= 2) {
			cycles += Register.costIndexedLD[registerIndexes.get(0)];
		} else {
			cycles += Register.getCostImmediatePULPSH(nbBytes);
		}
		cycles += Register.getCostImmediatePULPSH(nbBytes);
		return cycles;
	}

	public int getBackgroundBackupCodeSize (List<Integer> registerIndexes, int offset) throws Exception {
		int size = 0;
		if (this.nbBytes <= 2) {
			size += Register.sizeIndexedLD[registerIndexes.get(0)];
		} else {
			size += Register.sizeImmediatePULPSH;
		}
		size += Register.sizeImmediatePULPSH;
		return size;
	}

	public List<String> getDrawCode (byte[] data, int position, List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception {
		List<String> asmCode = new ArrayList<String>();
		String pixelValues;
		String pshs = "\tPSHS ";
		boolean firstPass;

		// Création du LD
		for (int i=0; i<registerIndexes.size(); i++) {
			if (loadMask.get(i)) {
				if (Register.size[registerIndexes.get(i)] == 1) {
					pixelValues = String.format("%02x", data[position]&0xff);
					position++;
				} else {
					pixelValues = String.format("%02x%02x", data[position]&0xff, data[position+1]&0xff);
					position += 2;
				}
				asmCode.add("\tLD"+Register.name[registerIndexes.get(i)]+" #$"+pixelValues);
			} else {
				if (Register.size[registerIndexes.get(i)] == 1) {
					position++;
				} else {
					position += 2;
				}
			}
		}

		if (this.nbBytes <= 2) {
			asmCode.add("\tST"+Register.name[registerIndexes.get(0)]+" "+offset+",S");
		} else {
			// Création du PSHS
			firstPass = true;
			for (int i=0; i<registerIndexes.size(); i++) {
				if (firstPass) {
					pshs += Register.name[registerIndexes.get(i)];
					firstPass = false;
				} else {
					pshs += ","+Register.name[registerIndexes.get(i)];
				}
			}
			asmCode.add(pshs);
		}

		return asmCode;
	}

	public int getDrawCodeCycles (List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception {
		int cycles = 0;

		for (int i=0; i<registerIndexes.size(); i++) {
			if (loadMask.get(i)) {
				cycles += Register.costImmediateLD[registerIndexes.get(i)];
			}
		}

		cycles += Register.getCostImmediatePULPSH(nbBytes);
		return cycles;
	}

	public int getDrawCodeSize (List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception {
		int size = 0;

		for (int i=0; i<registerIndexes.size(); i++ ) {
			if (loadMask.get(i)) {
				size += Register.sizeImmediateLD[registerIndexes.get(i)];
			}
		}

		size += Register.sizeImmediatePULPSH;
		return size;
	}
}
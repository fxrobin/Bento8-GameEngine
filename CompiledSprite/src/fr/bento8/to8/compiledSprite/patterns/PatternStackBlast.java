package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.compiledSprite.Register;

public abstract class PatternStackBlast extends Pattern{

	protected boolean useIndexedAddressing = false;

	public int getBackgroundBackupCodeCycles (int[] registerIndexes, int offset) throws Exception {
		int cycles = 0;
		cycles += Register.getCostImmediatePULPSH(nbBytes);
		cycles += Register.getCostImmediatePULPSH(nbBytes);
		return cycles;
	}

	public int getBackgroundBackupCodeSize (int[] registerIndexes, int offset) throws Exception {
		int size = 0;
		size += Register.sizeImmediatePULPSH;
		size += Register.sizeImmediatePULPSH;
		return size;
	}

	public List<String> getDrawCode (byte[] data, int position, int[] registerIndexes, boolean[] loadMask, int offset) throws Exception {
		List<String> asmCode = new ArrayList<String>();
		String pixelValues;
		String pshs = "\tPSHS ";
		boolean firstPass = true;

		// Création du LD
		for (int i=0; i<registerIndexes.length; i++ ) {
			if (loadMask[i]) {
				if (Register.size[registerIndexes[i]] == 1) {
					pixelValues = String.format("%02x", data[position]&0xff);
					position++;
				} else {
					pixelValues = String.format("%02x%02x", data[position]&0xff, data[position+1]&0xff);
					position += 2;
				}
				asmCode.add("\tLD"+Register.name[registerIndexes[i]]+" #$"+pixelValues);
			} else {
				if (Register.size[registerIndexes[i]] == 1) {
					position++;
				} else {
					position += 2;
				}
			}

			// Création du PSHS
			if (firstPass) {
				pshs += Register.name[registerIndexes[i]];
				firstPass = false;
			} else {
				pshs += ","+Register.name[registerIndexes[i]];
			}
		}

		asmCode.add(pshs);
		return asmCode;
	}

	public int getDrawCodeCycles (int[] registerIndexes, boolean[] loadMask, int offset) throws Exception {
		int cycles = 0;

		for (int i=0; i<registerIndexes.length; i++) {
			if (loadMask[i]) {
				cycles += Register.costImmediateLD[registerIndexes[i]];
			}
		}

		cycles += Register.getCostImmediatePULPSH(nbBytes);
		return cycles;
	}

	public int getDrawCodeSize (int[] registerIndexes, boolean[] loadMask, int offset) throws Exception {
		int size = 0;

		for (int i=0; i<registerIndexes.length; i++ ) {
			if (loadMask[i]) {
				size += Register.sizeImmediateLD[registerIndexes[i]];
			}
		}

		size += Register.sizeImmediatePULPSH;
		return size;
	}
}
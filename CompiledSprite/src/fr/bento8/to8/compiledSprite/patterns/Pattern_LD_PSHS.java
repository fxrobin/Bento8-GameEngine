package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.compiledSprite.Register;

public abstract class Pattern_LD_PSHS extends Pattern{

	protected boolean useIndexedAddressing = false;
	
	public List<String> getDrawCode (byte[] data, int position, byte[] registers, int offset) throws Exception {
		List<String> asmCode = new ArrayList<String>();
		String pixelValues;
		String pshs;

		// Création du LD
		for (int i=0; i<registers.length; i++ ) {
			// Cas nominal (>=0:A charger, -1: En cache, 2:Non sélectionné)
			if (registers[i]>=0) {
				if (Register.size[registers[i]] == 1) {
					pixelValues = String.format("%02x", data[position++]&0xff);
					position++;
				} else {
					pixelValues = String.format("%02x%02x", data[position]&0xff, data[position+1]&0xff);
					position += 2;
				}
				asmCode.add("\tLD"+Register.name[registers[i]]+" #$"+pixelValues);
			}

			// Cas d'un registre déjà chargé avec la valeur attendue
			if (registers[i]==-1) {
				if (Register.size[registers[i]] == 1) {
					position++;
				} else {
					position += 2;
				}
			}
		}

		// Création du PSHS
		pshs = "\tPSHS ";
		boolean firstPass = true;
		for (int i=0; i<registers.length; i++ ) {
			// On sélectionne tous les registres applicables
			if (registers[i]>=-1) {
				if (firstPass) {
					pshs += Register.name[registers[i]];
				} else {
					pshs += ","+Register.name[registers[i]];
				}
			}
		}
		asmCode.add(pshs);
		return asmCode;
	}
	
	public int getBackgroundBackupCodeCycles (int offset) throws Exception {
		int cycles = 0;
		cycles += Register.getCostImmediatePULPSH(nbBytes);
		cycles += Register.getCostImmediatePULPSH(nbBytes);
		return cycles;
	}

	public int getDrawCodeCycles (byte[] registers, int offset) throws Exception {
		int cycles = 0;

		for (int i=0; i<registers.length; i++ ) {
			if (registers[i]>=0) {
				cycles += Register.costImmediateLD[registers[i]];
			}
		}

		cycles += Register.getCostImmediatePULPSH(nbBytes);
		return cycles;
	}
	
	public int getBackgroundBackupCodeSize (int offset) throws Exception {
		int size = 0;
		size += Register.sizeImmediatePULPSH;
		size += Register.sizeImmediatePULPSH;
		return size;
	}

	public int getDrawCodeSize (byte[] registers, int offset) throws Exception {
		int size = 0;

		for (int i=0; i<registers.length; i++ ) {
			if (registers[i]>=0) {
				size += Register.sizeImmediateLD[registers[i]];
			}
		}

		size += Register.sizeImmediatePULPSH;
		return size;
	}
}
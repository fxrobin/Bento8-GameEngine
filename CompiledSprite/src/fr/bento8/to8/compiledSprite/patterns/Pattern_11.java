package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.compiledSprite.Register;

public class Pattern_11 extends Pattern {

	public Pattern_11() {
		nbPixels = 2;
		nbBytes = nbPixels/2;
	}

	public boolean matchesForward (byte[] data, int offset) {
		if (offset+1 >= data.length) {
			return false;
		}
		return (data[offset] != 0x00 && data[offset+1] != 0x00);
	}
	
	public boolean matchesRearward (byte[] data, int offset) {
		if (offset < 0) {
			return false;
		}
		return (data[offset] != 0x00 && data[offset+1] != 0x00);
	}

	public List<String> getBackgroundBackupCode (int[] registerIndexes, int offset, String tag) throws Exception {
		List<String> asmCode = new ArrayList<String>();
		asmCode.add("\tLDA "+offset+",S");
		asmCode.add("\tSTA "+tag);
		return asmCode;
	}

	public int getBackgroundBackupCodeCycles (int[] registerIndexes, int offset) throws Exception {
		int cycles = 0;
		cycles += Register.costIndexedLD[Register.A] + Register.getIndexedOffsetCost(offset);
		cycles += Register.costExtendedST[Register.A];
		return cycles;
	}

	public int getBackgroundBackupCodeSize (int[] registerIndexes, int offset) throws Exception {
		int size = 0;
		size += Register.sizeIndexedLD[Register.A] + Register.getIndexedOffsetSize(offset);
		size += Register.sizeExtendedST[Register.A];
		return size;
	}

	public List<String> getDrawCode (byte[] data, int position, int[] registerIndexes, boolean[] loadMask, int offset) throws Exception {
		List<String> asmCode = new ArrayList<String>();		
		asmCode.add("\tLDA "+"#$"+String.format("%02x", data[position]&0xff));
		asmCode.add("\tSTA "+offset+",S");
		return asmCode;
	}
	
	public int getDrawCodeCycles (int[] registerIndexes, boolean[] loadMask, int offset) throws Exception {
		int cycles = 0;
		cycles += Register.costImmediateLD[Register.A];
		cycles += Register.costIndexedST[Register.A] + Register.getIndexedOffsetCost(offset);
		return cycles;
	}
	
	public int getDrawCodeSize (int[] registerIndexes, boolean[] loadMask, int offset) throws Exception {
		int size = 0;
		size += Register.sizeImmediateLD[Register.A];
		size += Register.sizeIndexedST[Register.A] + Register.getIndexedOffsetSize(offset);
		return size;	
	}
}

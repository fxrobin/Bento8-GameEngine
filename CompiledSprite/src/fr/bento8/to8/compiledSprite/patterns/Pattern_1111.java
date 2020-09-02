package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.compiledSprite.Register;

public class Pattern_1111 extends Pattern {

	public Pattern_1111() {
		nbPixels = 4;
		nbBytes = nbPixels/2;
		useIndexedAddressing = true;
		isBackgroundBackupAndDrawDissociable = true;
		resetRegisters = null;
	}

	public boolean matchesForward (byte[] data, int offset) {
		if (offset+3 >= data.length) {
			return false;
		}
		return (data[offset] != 0x00 && data[offset+1] != 0x00 && data[offset+2] != 0x00 && data[offset+3] != 0x00);
	}
	
	public boolean matchesRearward (byte[] data, int offset) {
		if (offset-2 < 0) {
			return false;
		}
		return (data[offset-2] != 0x00 && data[offset-1] != 0x00 && data[offset] != 0x00 && data[offset+1] != 0x00);
	}

	public List<String> getBackgroundBackupCode (int[] registerIndexes, int offset, String tag) throws Exception {
		List<String> asmCode = new ArrayList<String>();
		asmCode.add("\tLDA "+offset+",S");
		asmCode.add("\tSTA "+tag);
		return asmCode;
	}

	public int getBackgroundBackupCodeCycles (int[] registerIndexes, int offset) throws Exception {
		int cycles = 0;
		cycles += Register.costIndexedLD[Register.D] + Register.getIndexedOffsetCost(offset);
		cycles += Register.costExtendedST[Register.D];
		return cycles;
	}

	public int getBackgroundBackupCodeSize (int[] registerIndexes, int offset) throws Exception {
		int size = 0;
		size += Register.sizeIndexedLD[Register.D] + Register.getIndexedOffsetSize(offset);
		size += Register.sizeExtendedST[Register.D];
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
		cycles += Register.costImmediateLD[Register.D];
		cycles += Register.costIndexedST[Register.D] + Register.getIndexedOffsetCost(offset);
		return cycles;
	}
	
	public int getDrawCodeSize (int[] registerIndexes, boolean[] loadMask, int offset) throws Exception {
		int size = 0;
		size += Register.sizeImmediateLD[Register.D];
		size += Register.sizeIndexedST[Register.D] + Register.getIndexedOffsetSize(offset);
		return size;	
	}
}

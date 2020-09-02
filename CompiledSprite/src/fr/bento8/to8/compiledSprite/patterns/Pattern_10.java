package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.compiledSprite.Register;

public class Pattern_10 extends PatternAlpha {

	public Pattern_10() {
		nbPixels = 2;
		nbBytes = nbPixels/2;
		useIndexedAddressing = true;
		isBackgroundBackupAndDrawDissociable = false;
		resetRegisters = null;
	}
	
	public boolean matchesForward (byte[] data, int offset) {
		if (offset+1 >= data.length) {
			return false;
		}
		return (data[offset] != 0x00 && data[offset+1] == 0x00);
	}
	
	public boolean matchesRearward (byte[] data, int offset) {
		if (offset < 0) {
			return false;
		}
		return (data[offset] != 0x00 && data[offset+1] == 0x00);
	}

	public List<String> getDrawCode (byte[] data, int position, int[] registerIndexes, boolean[] loadMask, int offset) throws Exception {
		List<String> asmCode = new ArrayList<String>();
		asmCode.add("\tANDA #$0F");
		asmCode.add("\tORA "+"#$"+String.format("%02x", data[position]&0xff));
		asmCode.add("\tSTA "+offset+",S");	
		return asmCode;
	}
	
	public int getDrawCodeCycles (int[] registerIndexes, boolean[] loadMask, int offset) throws Exception {
		int cycles = 0;
		cycles += Register.costImmediateAND[Register.A];
		cycles += Register.costImmediateOR[Register.A];
		cycles += Register.costIndexedST[Register.A] + Register.getIndexedOffsetCost(offset);
		return cycles;
	}
	
	public int getDrawCodeSize (int[] registerIndexes, boolean[] loadMask, int offset) throws Exception {
		int size = 0;
		size += Register.sizeImmediateAND[Register.A]; 
		size += Register.sizeImmediateOR[Register.A];
		size += Register.sizeIndexedST[Register.A] + Register.getIndexedOffsetSize(offset);
		return size;	
	}
}


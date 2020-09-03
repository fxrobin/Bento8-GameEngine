package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.InstructionSet.Register;

public class Pattern_1011 extends PatternAlpha {

	public Pattern_1011() {
		nbPixels = 4;
		nbBytes = nbPixels/2;
		useIndexedAddressing = true;
		isBackgroundBackupAndDrawDissociable = false;
		resetRegisters = new boolean[] {true, true, true, false, false, false, false};
		registerCombi.add(new boolean[] {true, true, false, false, false, false, false});
		registerCombi.add(new boolean[] {false, false, true, false, false, false, false});
	}

	public boolean matchesForward (byte[] data, int offset) {
		if (offset+3 >= data.length) {
			return false;
		}
		return (data[offset] != 0x00 && data[offset+1] == 0x00 && data[offset+2] != 0x00 && data[offset+3] != 0x00);
	}
	
	public boolean matchesRearward (byte[] data, int offset) {
		if (offset-2 < 0) {
			return false;
		}
		return (data[offset-2] != 0x00 && data[offset-1] == 0x00 && data[offset] != 0x00 && data[offset+1] != 0x00);
	}
	
	public List<String> getDrawCode (byte[] data, int position, int[] registerIndexes, boolean[] loadMask, int offset) throws Exception {
		List<String> asmCode = new ArrayList<String>();
		asmCode.add("\tANDA #$0F");
		asmCode.add("\tORA "+"#$"+String.format("%02x", data[position]&0xff));		
		asmCode.add("\tLDB "+"#$"+String.format("%02x", data[position+1]&0xff));
		asmCode.add("\tSTD "+offset+",S");	
		return asmCode;
	}
	
	public int getDrawCodeCycles (int[] registerIndexes, boolean[] loadMask, int offset) throws Exception {
		int cycles = 0;
		cycles += Register.costImmediateAND[Register.A];
		cycles += Register.costImmediateOR[Register.A];
		cycles += Register.costImmediateOR[Register.B];
		cycles += Register.costIndexedST[Register.D] + Register.getIndexedOffsetCost(offset);
		return cycles;
	}
	
	public int getDrawCodeSize (int[] registerIndexes, boolean[] loadMask, int offset) throws Exception {
		int size = 0;
		size += Register.sizeImmediateAND[Register.A]; 
		size += Register.sizeImmediateOR[Register.A];
		size += Register.sizeImmediateOR[Register.B];
		size += Register.sizeIndexedST[Register.D] + Register.getIndexedOffsetSize(offset);
		return size;	
	}
}

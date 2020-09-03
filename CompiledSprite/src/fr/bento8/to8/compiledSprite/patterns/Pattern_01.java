package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.InstructionSet.Register;

public class Pattern_01 extends PatternAlpha {

	public Pattern_01() {
		nbPixels = 2;
		nbBytes = nbPixels/2;
		useIndexedAddressing = true;
		isBackgroundBackupAndDrawDissociable = false;
		resetRegisters = null;
		registerCombi.add(new boolean[] {true, false, false, false, false, false, false});
		registerCombi.add(new boolean[] {false, true, false, false, false, false, false});
	}

	public boolean matchesForward (byte[] data, int offset) {
		if (offset+1 >= data.length) {
			return false;
		}
		return (data[offset] == 0x00 && data[offset+1] != 0x00);
	}
	
	public boolean matchesRearward (byte[] data, int offset) {
		if (offset < 0) {
			return false;
		}
		return (data[offset] == 0x00 && data[offset+1] != 0x00);
	}

	public List<String> getDrawCode (byte[] data, int position, List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception {
		List<String> asmCode = new ArrayList<String>();		
		asmCode.add("\tAND"+Register.name[registerIndexes.get(0)]+" #$F0");
		asmCode.add("\tOR"+Register.name[registerIndexes.get(0)]+" "+"#$"+String.format("%02x", data[position]&0xff));
		asmCode.add("\tST"+Register.name[registerIndexes.get(0)]+" "+offset+",S");
		return asmCode;
	}
	
	public int getDrawCodeCycles (List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception {
		int cycles = 0;
		cycles += Register.costImmediateAND[registerIndexes.get(0)];
		cycles += Register.costImmediateOR[registerIndexes.get(0)];
		cycles += Register.costIndexedST[registerIndexes.get(0)] + Register.getIndexedOffsetCost(offset);
		return cycles;
	}
	
	public int getDrawCodeSize (List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception {
		int size = 0;
		size += Register.sizeImmediateAND[registerIndexes.get(0)]; 
		size += Register.sizeImmediateOR[registerIndexes.get(0)];
		size += Register.sizeIndexedST[registerIndexes.get(0)] + Register.getIndexedOffsetSize(offset);
		return size;
	}
}


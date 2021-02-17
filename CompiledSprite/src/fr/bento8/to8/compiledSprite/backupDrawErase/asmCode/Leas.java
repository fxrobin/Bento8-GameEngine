package fr.bento8.to8.compiledSprite.backupDrawErase.asmCode;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.InstructionSet.Register;

public class Leas extends ASMCode {

	public Leas() {
	}

	public List<String> getCode (int offset) throws Exception {
		List<String> asmCode = new ArrayList<String>();		
		asmCode.add("\tLEAS "+offset+",S");
		return asmCode;
	}
	
	public int getCycles (int offset) throws Exception {
		int cycles = 0;
		cycles += Register.costIndexedLEA + Register.getIndexedOffsetCost(offset);
		return cycles;
	}
	
	public int getSize (int offset) throws Exception {
		int size = 0;
		size += Register.sizeIndexedLEA + Register.getIndexedOffsetSize(offset);
		return size;
	}
}


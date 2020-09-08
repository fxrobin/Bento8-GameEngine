package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.InstructionSet.Register;

public abstract class PatternAlpha extends Pattern{
	
	public List<String> getBackgroundBackupCode (List<Integer> registerIndexes, int offset) throws Exception {
		List<String> asmCode = new ArrayList<String>();
		asmCode.add("\tLD"+Register.name[registerIndexes.get(0)]+" "+offset+",S");
		asmCode.add("\tPSHU "+Register.name[registerIndexes.get(0)]);
		return asmCode;
	}

	public int getBackgroundBackupCodeCycles (List<Integer> registerIndexes, int offset) throws Exception {
		int cycles = 0;
		cycles += Register.costIndexedLD[registerIndexes.get(0)] + Register.getIndexedOffsetCost(offset);
		cycles += Register.getCostImmediatePULPSH(this.nbBytes);
		return cycles;
	}

	public int getBackgroundBackupCodeSize (List<Integer> registerIndexes, int offset) throws Exception {
		int size = 0;
		size += Register.sizeIndexedLD[registerIndexes.get(0)] + Register.getIndexedOffsetSize(offset);
		size += Register.sizeImmediatePULPSH;
		return size;
	}
}
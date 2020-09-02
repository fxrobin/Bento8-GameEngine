package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.compiledSprite.Register;

public abstract class PatternAlpha extends Pattern{

	protected boolean isBackgroundBackupAndDrawDissociable = false;
	
	public List<String> getBackgroundBackupCode (int[] registerIndexes, int offset, String tag) throws Exception {
		List<String> asmCode = new ArrayList<String>();
		asmCode.add("\tLD"+Register.name[registerIndexes[0]]+" "+offset+",S");
		asmCode.add("\tST"+Register.name[registerIndexes[0]]+" "+tag);
		return asmCode;
	}

	public int getBackgroundBackupCodeCycles (int[] registerIndexes, int offset) throws Exception {
		int cycles = 0;
		cycles += Register.costIndexedLD[registerIndexes[0]] + Register.getIndexedOffsetCost(offset);
		cycles += Register.costExtendedST[registerIndexes[0]];
		return cycles;
	}

	public int getBackgroundBackupCodeSize (int[] registerIndexes, int offset) throws Exception {
		int size = 0;
		size += Register.sizeIndexedLD[registerIndexes[0]] + Register.getIndexedOffsetSize(offset);
		size += Register.sizeExtendedST[registerIndexes[0]];
		return size;
	}
}
package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

public class Pattern_01 extends Snippet {
	public String pattern = "\\x00[^\\x00]";
	public final static int nbPixels = 2;
	public final static int nbBytes = nbPixels/2;
	
	List<String> asmCode = new ArrayList<String>();
	public int drawCycles = 0;
	public int backgroundBackupCycles = 0;
	
	public Pattern_01() {
	}
	
	public boolean matches (byte[] data, int offset) {
		return Pattern.matches(getPatternByOffset(pattern, offset), new ByteCharSequence(data));
	}

	public List<String> getBackgroundBackupCode (int offset, String tag) throws Exception {
		List<String> asmCode = new ArrayList<String>();
		
		asmCode.add("\tLDA "+offset+",S");
		backgroundBackupCycles += Register.costIndexedLD[0] + Register.getIndexedOffsetCost(offset);
		
		asmCode.add("\tSTA "+tag);
		backgroundBackupCycles += Register.costExtendedST[0];
		
		return asmCode;
	}

	public List<String> getDrawCode (byte[] data, int position, int direction, byte[][] registerValues, int offset) throws Exception {
		asmCode = new ArrayList<String>();
		drawCycles = 0;
		int registerIndex = 0;
		String registerName = Register.name[registerIndex];
		
		// AND Immédiat
		asmCode.add("\tAND"+registerName+" #$F0");
		drawCycles += Register.costImmediateAND[registerIndex];
		
		// OR Immédiat
		registerIndex = 0;
		asmCode.add("\tOR"+registerName+" "+"#$"+String.format("%02x", data[position]&0xff));
		drawCycles += Register.costImmediateOR[registerIndex];

		
		// ST Indexé
		asmCode.add("\tST"+registerName+" "+offset+",S");	
		drawCycles += Register.costIndexedST[registerIndex] + Register.getIndexedOffsetCost(offset);
		
		return asmCode;
	}
	
	public String getPattern() {
		return pattern;
	}
	
}


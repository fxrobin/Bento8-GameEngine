package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

public class Pattern_11 extends Snippet {
	public String pattern = "[^\\x00]{2}";
	public final static int nbPixels = 2;
	public final static int nbBytes = nbPixels/2;
	
	List<String> asmCode = new ArrayList<String>();
	public int drawCycles = 0;
	public int backgroundBackupCycles = 0;
	
	public Pattern_11() {
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
		String registerName = "";
		int registerIndex = -1;
		
		// Recherche d'un registre réutilisable
		registerIndex = Register.getPreLoadedRegister(1, data, position, direction, registerValues);
		
		// LD Immédiat
		if (registerIndex == -1) {
			registerIndex = 0;
			asmCode.add("\tLDA "+"#$"+String.format("%02x", data[position]&0xff));
			drawCycles += Register.costImmediateLD[registerIndex];
		}
		
		// ST Indexé
		registerName = Register.name[registerIndex];
		asmCode.add("\tST"+registerName+" "+offset+",S");	
		drawCycles += Register.costIndexedST[registerIndex] + Register.getIndexedOffsetCost(offset);
		
		return asmCode;
	}
	
	public String getPattern() {
		return pattern;
	}

}

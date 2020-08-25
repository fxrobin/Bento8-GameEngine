package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

public class Pattern_1111 {
	public final static int nbPixels = 4;
	public final static int nbBytes = nbPixels/2;
	
	List<String> asmCode = new ArrayList<String>();
	public int drawCycles = 0;
	public int backgroundBackupCycles = 0;
	
	public Pattern_1111() {
	}
	
	public static boolean matches (byte[] data, int offset) {
		return Pattern.matches("^.{"+offset+"}[^\\x00]{4}", new ByteCharSequence(data));
	}

	public List<String> getBackgroundBackupCode (int offset, String tag) throws Exception {
		List<String> asmCode = new ArrayList<String>();
		
		asmCode.add("\tLDD "+offset+",S");
		backgroundBackupCycles += Register.costIndexedLD[2] + Register.getIndexedOffsetCost(offset);
		
		asmCode.add("\tSTD "+tag);
		backgroundBackupCycles += Register.costExtendedST[2];
		
		return asmCode;
	}

	public List<String> getDrawCode (byte[] data, int position, int direction, byte[][] registerValues, int offset) throws Exception {
		asmCode = new ArrayList<String>();
		drawCycles = 0;
		String registerName = "";
		int registerIndex = -1;
		
		// Recherche d'un registre réutilisable
		registerIndex = Register.getPreLoadedRegister(2, data, position, direction, registerValues);
		
		// LD Immédiat
		if (registerIndex == -1) {
			registerIndex = 2;
			asmCode.add("\tLDD "+"#$"+String.format("%02x%02x", data[position]&0xff, data[position+direction]&0xff));
			drawCycles += Register.costImmediateLD[registerIndex];
		}
		
		// ST Indexé
		registerName = Register.name[registerIndex];
		asmCode.add("\tST"+registerName+" "+offset+",S");	
		drawCycles += Register.costIndexedST[registerIndex] + Register.getIndexedOffsetCost(offset);
		
		return asmCode;
	}

}

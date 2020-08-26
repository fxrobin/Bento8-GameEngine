package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

public class Pattern_11 extends Snippet {

	public Pattern_11() {
		pattern = "[^\\x00]{2}";
		nbPixels = 2;
		nbBytes = nbPixels/2;
	}

	public boolean matches (byte[] data, int offset) {
		return Pattern.matches(getPatternByOffset(pattern, offset), new ByteCharSequence(data));
	}

	public List<String> getBackgroundBackupCode (int offset, String tag) throws Exception {
		asmBCode = new ArrayList<String>();
		backgroundBackupCycles = 0;
		backgroundBackupSize = 0;

		asmBCode.add("\tLDA "+offset+",S");
		backgroundBackupCycles += Register.costIndexedLD[0] + Register.getIndexedOffsetCost(offset);

		asmBCode.add("\tSTA "+tag);
		backgroundBackupCycles += Register.costExtendedST[0];

		return asmBCode;
	}

	public List<String> getDrawCode (byte[] data, int position, int direction, byte[][] registerValues, int offset) throws Exception {
		asmDCode = new ArrayList<String>();
		drawCycles = 0;
		drawSize = 0;

		String registerName = "";
		int registerIndex = -1;

		// Recherche d'un registre réutilisable
		registerIndex = Register.getPreLoadedRegister(1, data, position, direction, registerValues);

		// LD Immédiat
		if (registerIndex == -1) {
			registerIndex = 0;
			asmDCode.add("\tLDA "+"#$"+String.format("%02x", data[position]&0xff));
			drawCycles += Register.costImmediateLD[registerIndex];
		}

		// ST Indexé
		registerName = Register.name[registerIndex];
		asmDCode.add("\tST"+registerName+" "+offset+",S");	
		drawCycles += Register.costIndexedST[registerIndex] + Register.getIndexedOffsetCost(offset);

		return asmDCode;
	}
}

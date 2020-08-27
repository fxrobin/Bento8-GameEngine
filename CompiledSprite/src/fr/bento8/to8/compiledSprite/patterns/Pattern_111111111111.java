package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

public class Pattern_111111111111 extends Snippet {

	public Pattern_111111111111() {
		nbPixels = 12;
		nbBytes = nbPixels/2;
		useIndexedAddressing = false;
	}

	public boolean matchesForward (byte[] data, int offset) {
		if (offset+11 >= data.length) {
			return false;
		}
		return (data[offset] != 0x00 && data[offset+1] != 0x00 && data[offset+2] != 0x00 && data[offset+3] != 0x00 && data[offset+4] != 0x00 && data[offset+5] != 0x00 && data[offset+6] != 0x00 && data[offset+7] != 0x00 && data[offset+8] != 0x00 && data[offset+9] != 0x00 && data[offset+10] != 0x00 && data[offset+11] != 0x00);
	}
	
	public boolean matchesRearward (byte[] data, int offset) {
		if (offset-10 < 0) {
			return false;
		}
		return (data[offset-10] != 0x00 && data[offset-9] != 0x00 && data[offset-8] != 0x00 && data[offset-7] != 0x00 && data[offset-6] != 0x00 && data[offset-5] != 0x00 && data[offset-4] != 0x00 && data[offset-3] != 0x00 && data[offset-2] != 0x00 && data[offset-1] != 0x00 && data[offset] != 0x00 && data[offset+1] != 0x00);
	}

	public List<String> getBackgroundBackupCode (int offset, String tag) throws Exception {
		asmBCode = new ArrayList<String>();
		backgroundBackupCycles = 0;
		backgroundBackupSize = 0;

		asmBCode.add("\tLDD "+offset+",S");
		backgroundBackupCycles += Register.costIndexedLD[2] + Register.getIndexedOffsetCost(offset);

		asmBCode.add("\tSTD "+tag);
		backgroundBackupCycles += Register.costExtendedST[2];

		return asmBCode;
	}

	public List<String> getDrawCode (byte[] data, int position, byte[][] registerValues, int offset) throws Exception {
		asmDCode = new ArrayList<String>();
		drawCycles = 0;
		drawSize = 0;

		String registerName = "";
		int registerIndex = -1;

		// Recherche d'un registre réutilisable
		registerIndex = Register.getPreLoadedRegister(2, data, position, registerValues);

		// LD Immédiat
		if (registerIndex == -1) {
			registerIndex = 2;
			asmDCode.add("\tLDD "+"#$"+String.format("%02x%02x", data[position]&0xff, data[position+1]&0xff));
			drawCycles += Register.costImmediateLD[registerIndex];
		}

		// ST Indexé
		registerName = Register.name[registerIndex];
		asmDCode.add("\tST"+registerName+" "+offset+",S");	
		drawCycles += Register.costIndexedST[registerIndex] + Register.getIndexedOffsetCost(offset);

		return asmDCode;
	}
}

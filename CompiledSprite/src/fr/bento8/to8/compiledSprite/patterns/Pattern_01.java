package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.compiledSprite.Register;

public class Pattern_01 extends Pattern {

	public Pattern_01() {
		nbPixels = 2;
		nbBytes = nbPixels/2;
		isBackgroundBackupAndDrawDissociable = false;
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

	public List<String> getBackgroundBackupCode (int offset, String tag) throws Exception {
		asmBCode = new ArrayList<String>();
		backgroundBackupCycles = 0;
		backgroundBackupSize = 0;

		asmBCode.add("\tLDA "+offset+",S");
		backgroundBackupCycles += Register.costIndexedLD[Register.A] + Register.getIndexedOffsetCost(offset);
		backgroundBackupSize += Register.sizeIndexedLD[Register.A] + Register.getIndexedOffsetSize(offset);

		asmBCode.add("\tSTA "+tag);
		backgroundBackupCycles += Register.costExtendedST[Register.A];
		backgroundBackupSize += Register.sizeExtendedST[Register.A];

		return asmBCode;
	}

	public List<String> getDrawCode (byte[] data, int position, byte[][] registerValues, int offset) throws Exception {
		asmDCode = new ArrayList<String>();
		drawCycles = 0;
		drawSize = 0;

		asmDCode.add("\tANDA #$F0");
		drawCycles += Register.costImmediateAND[Register.A];
		drawSize += Register.sizeImmediateAND[Register.A]; 

		asmDCode.add("\tORA "+"#$"+String.format("%02x", data[position]&0xff));
		drawCycles += Register.costImmediateOR[Register.A];
		drawSize += Register.sizeImmediateOR[Register.A];

		asmDCode.add("\tSTA "+offset+",S");	
		drawCycles += Register.costIndexedST[Register.A] + Register.getIndexedOffsetCost(offset);
		drawSize += Register.sizeIndexedST[Register.A] + Register.getIndexedOffsetSize(offset);
		
		return asmDCode;
	}
}


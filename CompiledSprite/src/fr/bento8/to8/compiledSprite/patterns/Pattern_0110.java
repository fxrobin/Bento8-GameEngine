package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.compiledSprite.Register;

public class Pattern_0110 extends Pattern {

	public Pattern_0110() {
		nbPixels = 4;
		nbBytes = nbPixels/2;
		isBackgroundBackupAndDrawDissociable = false;
	}

	public boolean matchesForward (byte[] data, int offset) {
		if (offset+3 >= data.length) {
			return false;
		}
		return (data[offset] == 0x00 && data[offset+1] != 0x00 && data[offset+2] != 0x00 && data[offset+3] == 0x00);
	}
	
	public boolean matchesRearward (byte[] data, int offset) {
		if (offset-2 < 0) {
			return false;
		}
		return (data[offset-2] == 0x00 && data[offset-1] != 0x00 && data[offset] != 0x00 && data[offset+1] == 0x00);
	}

	public List<String> getBackgroundBackupCode (int offset, String tag) throws Exception {
		asmBCode = new ArrayList<String>();
		backgroundBackupCycles = 0;
		backgroundBackupSize = 0;

		asmBCode.add("\tLDD "+offset+",S");
		backgroundBackupCycles += Register.costIndexedLD[Register.D] + Register.getIndexedOffsetCost(offset);
		backgroundBackupSize += Register.sizeIndexedLD[Register.D] + Register.getIndexedOffsetSize(offset);

		asmBCode.add("\tSTD "+tag);
		backgroundBackupCycles += Register.costExtendedST[Register.D];
		backgroundBackupSize += Register.sizeExtendedST[Register.D];
				
		return asmBCode;
	}

	public List<String> getDrawCode (byte[] data, int position, byte[][] registerValues, int offset) throws Exception {
		asmDCode = new ArrayList<String>();
		drawCycles = 0;
		drawSize = 0;

		asmDCode.add("\tANDA #$F0");
		drawCycles += Register.costImmediateAND[Register.A];
		drawSize += Register.sizeImmediateAND[Register.A]; 
		
		asmDCode.add("\tANDB #$0F");
		drawCycles += Register.costImmediateAND[Register.B];
		drawSize += Register.sizeImmediateAND[Register.B]; 
		
		asmDCode.add("\tADD "+"#$"+String.format("%02x%02x", data[position]&0xff, data[position+1]&0xff));
		drawCycles += Register.costImmediateADD[Register.D];
		drawSize += Register.sizeImmediateADD[Register.D]; 

		asmDCode.add("\tSTD "+offset+",S");	
		drawCycles += Register.costIndexedST[Register.D] + Register.getIndexedOffsetCost(offset);
		drawSize += Register.sizeIndexedST[Register.D] + Register.getIndexedOffsetSize(offset);

		return asmDCode;
	}
}

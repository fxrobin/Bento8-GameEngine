package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

public class Pattern_111111 extends PatternStackBlast {

	public Pattern_111111() {
		nbPixels = 6;
		nbBytes = nbPixels/2;
		useIndexedAddressing = false;
	}

	public boolean matchesForward (byte[] data, int offset) {
		if (offset+5 >= data.length) {
			return false;
		}
		return (data[offset] != 0x00 && data[offset+1] != 0x00 && data[offset+2] != 0x00 && data[offset+3] != 0x00 && data[offset+4] != 0x00 && data[offset+5] != 0x00);
	}
	
	public boolean matchesRearward (byte[] data, int offset) {
		if (offset-4 < 0) {
			return false;
		}
		return (data[offset-4] != 0x00 && data[offset-3] != 0x00 && data[offset-2] != 0x00 && data[offset-1] != 0x00 && data[offset] != 0x00 && data[offset+1] != 0x00);
	}

	public List<String> getBackgroundBackupCode (int[] registerIndexes, int offset, String tag) throws Exception {
		List<String> asmCode = new ArrayList<String>();
		asmCode.add("\tPULS A,X");
		asmCode.add("\tPSHU X,A");
		return asmCode;
	}
}

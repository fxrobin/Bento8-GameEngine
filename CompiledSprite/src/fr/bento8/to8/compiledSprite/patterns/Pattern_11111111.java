package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

public class Pattern_11111111 extends Pattern_LD_PSHS {

	public Pattern_11111111() {
		nbPixels = 8;
		nbBytes = nbPixels/2;
	}

	public boolean matchesForward (byte[] data, int offset) {
		if (offset+7 >= data.length) {
			return false;
		}
		return (data[offset] != 0x00 && data[offset+1] != 0x00 && data[offset+2] != 0x00 && data[offset+3] != 0x00 && data[offset+4] != 0x00 && data[offset+5] != 0x00 && data[offset+6] != 0x00 && data[offset+7] != 0x00);
	}
	
	public boolean matchesRearward (byte[] data, int offset) {
		if (offset-6 < 0) {
			return false;
		}
		return (data[offset-6] != 0x00 && data[offset-5] != 0x00 && data[offset-4] != 0x00 && data[offset-3] != 0x00 && data[offset-2] != 0x00 && data[offset-1] != 0x00 && data[offset] != 0x00 && data[offset+1] != 0x00);
	}

	public List<String> getBackgroundBackupCode (int offset, String tag) throws Exception {
		List<String> asmCode = new ArrayList<String>();
		asmCode.add("\tPULS D,X");
		asmCode.add("\tPSHU X,D");
		return asmCode;
	}
}

package fr.bento8.to8.compiledSprite.draw.patterns;

public class Pattern_1111111111111111 extends PatternStackBlast {

	public Pattern_1111111111111111() {
		nbPixels = 16;
		nbBytes = nbPixels/2;
		useIndexedAddressing = false;
		isBackgroundBackupAndDrawDissociable = false;
		registerCombi.add(new boolean[] {false, false, true, true, true, true, false});
	}

	public boolean matchesForward (byte[] data, Integer offset) {
		if (offset+15 >= data.length) {
			return false;
		}
		return (data[offset] != 0x00 && data[offset+1] != 0x00 && data[offset+2] != 0x00 && data[offset+3] != 0x00 && data[offset+4] != 0x00 && data[offset+5] != 0x00 && data[offset+6] != 0x00 && data[offset+7] != 0x00 && data[offset+8] != 0x00 && data[offset+9] != 0x00 && data[offset+10] != 0x00 && data[offset+11] != 0x00 && data[offset+12] != 0x00 && data[offset+13] != 0x00 && data[offset+14] != 0x00 && data[offset+15] != 0x00);
	}

	public boolean matchesRearward (byte[] data, Integer offset) {
		if (offset-14 < 0) {
			return false;
		}
		return (data[offset-14] != 0x00 && data[offset-13] != 0x00 && data[offset-12] != 0x00 && data[offset-11] != 0x00 && data[offset-10] != 0x00 && data[offset-9] != 0x00 && data[offset-8] != 0x00 && data[offset-7] != 0x00 && data[offset-6] != 0x00 && data[offset-5] != 0x00 && data[offset-4] != 0x00 && data[offset-3] != 0x00 && data[offset-2] != 0x00 && data[offset-1] != 0x00 && data[offset] != 0x00 && data[offset+1] != 0x00);
	}
}

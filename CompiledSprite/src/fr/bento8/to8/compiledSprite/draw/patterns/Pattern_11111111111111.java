package fr.bento8.to8.compiledSprite.draw.patterns;

public class Pattern_11111111111111 extends PatternStackBlast {

	public Pattern_11111111111111() {
		nbPixels = 14;
		nbBytes = nbPixels/2;
		useIndexedAddressing = false;
		isBackgroundBackupAndDrawDissociable = true;
		registerCombi.add(new boolean[] {true, false, false, true, true, true, false});
		registerCombi.add(new boolean[] {false, true, false, true, true, true, false});
	}

	public boolean matchesForward (byte[] data, Integer offset) {
		if (offset+13 >= data.length) {
			return false;
		}
		return (data[offset] != 0x00 && data[offset+1] != 0x00 && data[offset+2] != 0x00 && data[offset+3] != 0x00 && data[offset+4] != 0x00 && data[offset+5] != 0x00 && data[offset+6] != 0x00 && data[offset+7] != 0x00 && data[offset+8] != 0x00 && data[offset+9] != 0x00 && data[offset+10] != 0x00 && data[offset+11] != 0x00 && data[offset+12] != 0x00 && data[offset+13] != 0x00);
	}
	
	public boolean matchesRearward (byte[] data, Integer offset) {
		if (offset-12 < 0) {
			return false;
		}
		return (data[offset-12] != 0x00 && data[offset-11] != 0x00 && data[offset-10] != 0x00 && data[offset-9] != 0x00 && data[offset-8] != 0x00 && data[offset-7] != 0x00 && data[offset-6] != 0x00 && data[offset-5] != 0x00 && data[offset-4] != 0x00 && data[offset-3] != 0x00 && data[offset-2] != 0x00 && data[offset-1] != 0x00 && data[offset] != 0x00 && data[offset+1] != 0x00);
	}
}

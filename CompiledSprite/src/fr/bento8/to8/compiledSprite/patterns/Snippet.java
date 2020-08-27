package fr.bento8.to8.compiledSprite.patterns;

import java.util.List;

public abstract class Snippet {

	protected int nbPixels;
	protected int nbBytes;
	protected List<String> asmBCode;
	protected List<String> asmDCode;
	protected int drawCycles = 0;
	protected int backgroundBackupCycles = 0;
	protected int drawSize = 0;
	protected int backgroundBackupSize = 0;
	protected boolean useIndexedAddressing = true;

	public abstract boolean matchesForward (byte[] data, int offset);
	public abstract boolean matchesRearward (byte[] data, int offset);
	public abstract List<String> getBackgroundBackupCode (int offset, String tag) throws Exception;
	public abstract List<String> getDrawCode (byte[] data, int position, byte[][] registerValues, int offset) throws Exception;

	public int getNbPixels() {
		return nbPixels;
	}
	
	public int getNbBytes() {
		return nbBytes;
	}

	public int getCycles() {
		return this.backgroundBackupCycles + this.drawCycles;
	}

	public int getSize() {
		return this.backgroundBackupSize + this.drawSize;
	}
	
	public boolean useIndexedAddressing() {
		return this.useIndexedAddressing;
	}
	
	public List<String> getBackgroundBackupAsmCode() {
		return asmBCode;
	}

	public List<String> getDrawAsmCode() {
		return asmDCode;
	}
}
package fr.bento8.to8.compiledSprite.patterns;

import java.util.List;

import fr.bento8.to8.compiledSprite.Register;

public abstract class Pattern {

	protected int nbPixels;
	protected int nbBytes;
	
	protected boolean useIndexedAddressing = true;
	protected boolean isBackgroundBackupAndDrawDissociable = true;

	public abstract boolean matchesForward (byte[] data, int offset);
	public abstract boolean matchesRearward (byte[] data, int offset);
	public abstract List<String> getBackgroundBackupCode (int offset, String tag) throws Exception;
	public abstract List<String> getDrawCode (byte[] data, int position, byte[] registers, int offset) throws Exception;
	public abstract int getBackgroundBackupCodeCycles (int offset) throws Exception;
	public abstract int getDrawCodeCycles (byte[] registers, int offset) throws Exception;	
	public abstract int getBackgroundBackupCodeSize (int offset) throws Exception;
	public abstract int getDrawCodeSize (byte[] registers, int offset) throws Exception;
	
	public int getNbPixels() {
		return nbPixels;
	}
	
	public int getNbBytes() {
		return nbBytes;
	}

	
	public boolean useIndexedAddressing() {
		return this.useIndexedAddressing;
	}
}
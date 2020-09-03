package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

public abstract class Pattern {

	protected int nbPixels;
	protected int nbBytes;
	
	protected boolean useIndexedAddressing;
	protected boolean isBackgroundBackupAndDrawDissociable;
	protected boolean[] resetRegisters;
	protected List<boolean[]> registerCombi = new ArrayList<boolean[]>();;

	public abstract boolean matchesForward (byte[] data, int offset);
	public abstract boolean matchesRearward (byte[] data, int offset);
	
	public abstract List<String> getBackgroundBackupCode (int[] registerIndexes, int offset, String tag) throws Exception;
	public abstract int getBackgroundBackupCodeCycles (int[] registerIndexes, int offset) throws Exception;
	public abstract int getBackgroundBackupCodeSize (int[] registerIndexes, int offset) throws Exception;
	
	public abstract List<String> getDrawCode (byte[] data, int position, int[] registerIndexes, boolean[] loadMask, int offset) throws Exception;
	public abstract int getDrawCodeCycles (int[] registerIndexes, boolean[] loadMask, int offset) throws Exception;	
	public abstract int getDrawCodeSize (int[] registerIndexes, boolean[] loadMask, int offset) throws Exception;
	
	public int getNbPixels() {
		return nbPixels;
	}
	
	public int getNbBytes() {
		return nbBytes;
	}
	
	public boolean useIndexedAddressing() {
		return useIndexedAddressing;
	}
	
	public boolean isBackgroundBackupAndDrawDissociable() {
		return isBackgroundBackupAndDrawDissociable;
	}
	
	public boolean useVariableRegisters() {
		return (resetRegisters == null ? true:false);
	}
	
	public boolean[] getResetRegisters() {
		return resetRegisters;
	}
	
	public List<boolean[]> getRegisterCombi() {
		return registerCombi;
	}
}
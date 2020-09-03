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
	
	public abstract List<String> getBackgroundBackupCode (List<Integer> registerIndexes, int offset) throws Exception;
	public abstract int getBackgroundBackupCodeCycles (List<Integer> registerIndexes, int offset) throws Exception;
	public abstract int getBackgroundBackupCodeSize (List<Integer> registerIndexes, int offset) throws Exception;
	
	public abstract List<String> getDrawCode (byte[] data, int position, List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception;
	public abstract int getDrawCodeCycles (List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception;	
	public abstract int getDrawCodeSize (List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception;
	
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
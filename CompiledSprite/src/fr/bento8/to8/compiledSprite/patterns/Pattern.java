package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.InstructionSet.Register;

public abstract class Pattern {

	protected int nbPixels;
	protected int nbBytes;

	protected boolean useIndexedAddressing;
	protected boolean isBackgroundBackupAndDrawDissociable;
	protected List<boolean[]> resetRegisters = new ArrayList<boolean[]>();
	protected List<boolean[]> registerCombi = new ArrayList<boolean[]>();

	public abstract boolean matchesForward (byte[] data, int offset);
	public abstract boolean matchesRearward (byte[] data, int offset);

	public abstract List<String> getBackgroundBackupCode (List<Integer> registerIndexes, int offset, boolean saveS) throws Exception;
	public abstract int getBackgroundBackupCodeCycles (List<Integer> registerIndexes, int offset, boolean saveS) throws Exception;
	public abstract int getBackgroundBackupCodeSize (List<Integer> registerIndexes, int offset) throws Exception;

	public abstract List<String> getDrawCode (byte[] data, int position, List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception;
	public abstract int getDrawCodeCycles (List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception;	
	public abstract int getDrawCodeSize (List<Integer> registerIndexes, List<Boolean> loadMask, int offset) throws Exception;

	public List<String> getEraseCode (boolean LoadS, int offset) throws Exception {
		List<String> asmCode = new ArrayList<String>();
		String read = "\tPULU ";
		String write = "\t";

		switch (nbBytes) {
		case 1: 
			read += "A";
			write += "STA "+offset+",S"; // ajout gestion 0,S en ,S
			break;
		case 2:
			read += "D";
			write += "STD "+offset+",S";
			break;
		case 3:
			read += "A,X";
			write += "PSHS A,X";
			break;
		case 4:
			read += "D,X";
			write += "PSHS D,X";
			break;
		case 5:
			read += "A,X,Y";
			write += "PSHS A,X,Y";
			break;
		case 6:
			read += "D,X,Y";
			write += "PSHS D,X,Y";
			break;
		default:
		}

		if (LoadS) {
			read += ",S";
		}

		asmCode.add(read);
		asmCode.add(write);

		return asmCode;
	}

	public int getEraseCodeCycles (boolean loadS, int offset) throws Exception {
		int cycles = 0;

		if (nbBytes == 1) {
			cycles += Register.costIndexedST[Register.A] + Register.getIndexedOffsetCost(offset);
		} else if (nbBytes == 2) {
			cycles += Register.costIndexedST[Register.D] + Register.getIndexedOffsetCost(offset);
		} else {
			if (loadS) {
				cycles += Register.getCostImmediatePULPSH(nbBytes+2);
			} else {
				cycles += Register.getCostImmediatePULPSH(nbBytes);
			}
			cycles += Register.getCostImmediatePULPSH(nbBytes);
		}
		return cycles;
	}

	public int getEraseCodeSize (boolean loadS, int offset) throws Exception {
		int size = 0;		
		
		if (nbBytes == 1) {
			size += Register.sizeIndexedST[Register.A] + Register.getIndexedOffsetSize(offset);
		} else if (nbBytes == 2) {
			size += Register.sizeIndexedST[Register.D] + Register.getIndexedOffsetSize(offset);
		} else {
			size += Register.sizeImmediatePULPSH;
			size += Register.sizeImmediatePULPSH;
		}
		return size;
	}

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

	public List<boolean[]> getResetRegisters() {
		return resetRegisters;
	}

	public List<boolean[]> getRegisterCombi() {
		return registerCombi;
	}
}
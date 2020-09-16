package fr.bento8.to8.compiledSprite;

import java.util.List;

import fr.bento8.to8.compiledSprite.asmCode.ASMCode;
import fr.bento8.to8.compiledSprite.patterns.Pattern;

public class Snippet {
	private Pattern pattern;
	private ASMCode asmCode;
	private int method;

	private List<Integer> registerIndexes;
	private int offset;
	private boolean saveS;
	private byte[] data;
	private int position;
	private List<Boolean> loadMask;

	static final int BACKGROUND_BACKUP = 0;
	static final int DRAW = 1;
	static final int LEAS = 2;

	public Snippet(Pattern pattern, List<Integer> registerIndexes, int offset, boolean saveS) {
		method = BACKGROUND_BACKUP;
		this.pattern = pattern;
		this.registerIndexes = registerIndexes;
		this.offset = offset;
		this.saveS = saveS;
	}

	public Snippet(Pattern pattern, byte[] data, int position, List<Integer> registerIndexes, List<Boolean> loadMask, int offset) {
		method = DRAW;
		this.pattern = pattern;
		this.data = data;
		this.position = position;
		this.registerIndexes = registerIndexes;
		this.loadMask = loadMask;
		this.offset = offset;
	}

	public Snippet(ASMCode asmCode, int offset) {
		method = LEAS;
		this.asmCode = asmCode;
		this.offset = offset;
	}

	public List<String> call() throws Exception {
		List<String> code = null;
		switch (method) {
		case BACKGROUND_BACKUP: code=pattern.getBackgroundBackupCode(registerIndexes, offset, saveS); break;
		case DRAW: code=pattern.getDrawCode(data, position, registerIndexes, loadMask, offset); break;
		case LEAS: code=asmCode.getCode(offset); break;
		}
		return code;
	}

	public int getCycles() throws Exception {
		int cycles = 0;
		switch (method) {
		case BACKGROUND_BACKUP: cycles=pattern.getBackgroundBackupCodeCycles(registerIndexes, offset, saveS); break;
		case DRAW: cycles=pattern.getDrawCodeCycles(registerIndexes, loadMask, offset); break;
		case LEAS: cycles=asmCode.getCycles(offset); break;
		}
		return cycles;
	}

	public int getSize() throws Exception {
		int size = 0;
		switch (method) {
		case BACKGROUND_BACKUP: size=pattern.getBackgroundBackupCodeSize(registerIndexes, offset); break;
		case DRAW: size=pattern.getDrawCodeSize(registerIndexes, loadMask, offset); break;
		case LEAS: size=asmCode.getSize(offset); break;
		}
		return size;
	}

	public int getMethod() {
		return method;
	}
}
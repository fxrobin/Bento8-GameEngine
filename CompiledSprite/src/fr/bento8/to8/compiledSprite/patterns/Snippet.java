package fr.bento8.to8.compiledSprite.patterns;

import java.util.List;

public abstract class Snippet {

	public abstract boolean matches (byte[] data, int offset);
	public abstract List<String> getBackgroundBackupCode (int offset, String tag) throws Exception;
	public abstract List<String> getDrawCode (byte[] data, int position, int direction, byte[][] registerValues, int offset) throws Exception;
	public abstract String getPattern();
	
	public String getPatternByOffset (String pattern, int offset) {
		if (offset > 0) {
			pattern = ".{"+offset+"}" + pattern;
		}
		pattern = "^" + pattern + ".*";
		return pattern;
	}

}
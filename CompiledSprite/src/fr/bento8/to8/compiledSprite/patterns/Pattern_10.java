package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

public class Pattern_10 {
	public final static Pattern p = Pattern.compile("^[^\\\\x00]\\x00");
	public final static int nbPixels = 2;
	public final static int nbBytes = nbPixels/2;
	public final static List<String> asmCode = new ArrayList<String>();

	public Pattern_10 (int offset) {
		asmCode.add("\tLDA "+offset+",S");
		asmCode.add("\tSTA ");	
		asmCode.add("\tANDA #0F");	
		asmCode.add("\tORA ");	
		asmCode.add("\tSTA ");	
	}
	
	}

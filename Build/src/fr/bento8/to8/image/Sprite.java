package fr.bento8.to8.image;

import java.util.HashMap;

public class Sprite {

	public String name = "";
	public String spriteFile;
	public boolean inRAM = false;	
	public String associatedIdx;
	
	public HashMap<String, SubSprite> subSprites = new HashMap<String, SubSprite>(); 

	public Sprite (String name) {
		this.name = name;
	}
}
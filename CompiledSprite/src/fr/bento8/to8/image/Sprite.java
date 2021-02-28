package fr.bento8.to8.image;

import java.util.HashMap;
import java.util.Map.Entry;

import fr.bento8.to8.disk.FdUtil;

public class Sprite {

	public String name = "";
	public String spriteFile;
	
	public HashMap<String, SubSprite> subSprites = new HashMap<String, SubSprite>(); 

	public Sprite (String name) {
		this.name = name;
	}
	
	public void setAllFileIndex(FdUtil fd) {
		for (Entry<String, SubSprite> subSprite : subSprites.entrySet()) {
			subSprite.getValue().setAllFileIndex(fd);
		}		
	}	
}
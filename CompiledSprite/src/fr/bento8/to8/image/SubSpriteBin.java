package fr.bento8.to8.image;

import fr.bento8.to8.disk.FileIndex;

public class SubSpriteBin {

	public SubSprite parent;
	public String name = "";
	
	public byte[] bin;
	public FileIndex fileIndex;

	public SubSpriteBin(SubSprite p) {
		parent = p;
	}
	
	public void setName(String name) {
		this.name = name;
	}	
}
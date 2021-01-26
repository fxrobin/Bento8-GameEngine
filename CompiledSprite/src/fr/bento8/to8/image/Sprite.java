package fr.bento8.to8.image;

import fr.bento8.to8.disk.FdUtil;

public class Sprite {

	public String name = "";
	
	public SubSprite subSprite;
	public SubSprite subSpriteX;
	public SubSprite subSpriteY;
	public SubSprite subSpriteXY;	

	public Sprite() {	
	}
	
	public void setSubSprite(String flip, SubSprite ss) {
		switch (flip) {
		case "N":
			 subSprite = ss;				
			break;
		case "X":
			subSpriteX = ss;						
			break;
		case "Y":
			subSpriteY = ss;
			break;
		case "XY":
			subSpriteXY = ss;
			break;
		}
	}
	
	public void setAllFileIndex(FdUtil fd) {	
		if (subSprite != null) {
			subSprite.setAllFileIndex(fd);
		}
		if (subSpriteX != null) {
			subSpriteX.setAllFileIndex(fd);
		}
		if (subSpriteY != null) {
			subSpriteY.setAllFileIndex(fd);
		}
		if (subSpriteXY != null) {
			subSpriteXY.setAllFileIndex(fd);
		}		
	}	
}
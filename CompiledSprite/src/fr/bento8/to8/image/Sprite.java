package fr.bento8.to8.image;

public class Sprite {

	String SpriteTag;
	
	public SubSprite subSprite;
	public SubSprite subSpriteX;
	public SubSprite subSpriteY;
	public SubSprite subSpriteXY;	

	public Sprite() {
		subSprite = new SubSprite();
		subSpriteX = new SubSprite();
		subSpriteY = new SubSprite();
		subSpriteXY = new SubSprite();		
	}
}
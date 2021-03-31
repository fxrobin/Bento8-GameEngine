package fr.bento8.to8.image;

import fr.bento8.to8.util.knapsack.ItemBin;

public class SubSpriteBin extends ItemBin{

	public SubSprite parent;
	public String name = "";
	public boolean inRAM = false;	

	public SubSpriteBin(SubSprite p) {
		parent = p;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getFullName() {
		return "SpriteBin "+this.parent.parent.name + " " + this.parent.name + " " + this.name;
	}	
	
}
package fr.bento8.to8.audio;

import fr.bento8.to8.util.knapsack.ItemBin;

public class SoundBin extends ItemBin{

	public String name = "";
	public boolean inRAM = false;
	
	public SoundBin() {	
	}
	
	public void setName(String name) {
		this.name = name;
	}	
	
	public String getFullName() {
		return "ObjectBin "+this.name;
	}

	public Object getObject() {
		return null;
	}		
}
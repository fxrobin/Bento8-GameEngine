package fr.bento8.to8.util.knapsack;

import fr.bento8.to8.image.SubSpriteBin;

public class Item {
	
	public String name;
	public String fullName;
	public SubSpriteBin ssbin;
	public int value;
	public int weight;
	
	public Item(SubSpriteBin ssbin, int value) {
		this.name = ssbin.parent.parent.name + ssbin.parent.name + ssbin.name;
		this.ssbin = ssbin;
		this.value = value;
		this.weight = ssbin.bin.length;
	}
	
	public String str() {
		return name + " [value = " + value + ", weight = " + weight + "]";
	}

}
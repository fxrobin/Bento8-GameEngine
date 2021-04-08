package fr.bento8.to8.util.knapsack;

import fr.bento8.to8.build.GameMode;

public class Item {
	
	public String name;
	public ItemBin bin;
	public int value;
	public int weight;
	public boolean absolute = false;
	public GameMode gameMode;
	
	public Item(ItemBin bin, int value) {
		this.name = bin.getFullName();
		this.bin = bin;
		this.value = value;
		this.weight = bin.uncompressedSize;
	}
	
	public String str() {
		return name + " [value = " + value + ", weight = " + weight + "]";
	}

}
package fr.bento8.to8.util.knapsack;

public class Item {
	
	public String name;
	public ItemBin bin;
	public int value;
	public int weight;
	
	public Item(ItemBin bin, int value) {
		this.name = bin.getFullName();
		this.bin = bin;
		this.value = value;
		this.weight = bin.bin.length;
	}
	
	public String str() {
		return name + " [value = " + value + ", weight = " + weight + "]";
	}

}
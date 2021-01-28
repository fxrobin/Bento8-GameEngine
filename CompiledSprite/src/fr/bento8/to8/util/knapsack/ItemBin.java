package fr.bento8.to8.util.knapsack;

import fr.bento8.to8.disk.ImgIndex;

public abstract class ItemBin {
	
	public byte[] bin;
	public ImgIndex fileIndex;

	abstract public String getFullName();
}
package fr.bento8.to8.util.knapsack;

import fr.bento8.to8.disk.FileIndex;

public abstract class ItemBin {
	
	public byte[] bin;
	public FileIndex fileIndex;

	abstract public String getFullName();
}
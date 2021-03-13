package fr.bento8.to8.util.knapsack;

import fr.bento8.to8.disk.DataIndex;

public abstract class ItemBin {
	
	public byte[] bin;
	public DataIndex fileIndex;
	public int uncompressedSize = 0;

	abstract public String getFullName();
}
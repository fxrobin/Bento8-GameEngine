package fr.bento8.to8.util.knapsack;

import fr.bento8.to8.storage.DataIndex;

public abstract class ItemBin {
	
	public byte[] bin;
	public DataIndex dataIndex;
	public int uncompressedSize = 0;

	abstract public String getFullName();
	abstract public Object getObject();
}
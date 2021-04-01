package fr.bento8.to8.ram;

/**
 * @author Benoît Rousseau
 * @version 1.0
 *
 */
public class DataPage
{
	
	public int page;
    public byte[] data;
    public int pageSize = 0x4000;
	
	public DataPage(int page) {
		this.page = page;
		data = new byte[pageSize];
	}
}
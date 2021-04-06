package fr.bento8.to8.ram;

/**
 * @author Benoît Rousseau
 * @version 1.0
 *
 */
public class RamImage
{
    public static int PAGE_SIZE = 0x4000;	
	
    public byte[][] data;
    public int[] startAddress;
    public int[] endAddress;
    
	public int page;
	public int lastPage;
	
	public RamImage (int lastPage) {
		this.data = new byte[lastPage][PAGE_SIZE];
		this.startAddress = new int[lastPage];
		this.endAddress = new int[lastPage];
		this.lastPage = lastPage;
		this.page = 0;		
	}
	
	public void setData (int page, int startPos, byte[] newData) {
		int endPos = newData.length+startPos;		
		
		if (startPos < this.startAddress[page]) {
			this.startAddress[page] = startPos;
		}
		
		if (endPos > this.endAddress[page]) {
			this.endAddress[page] = endPos;
		}
		
		for (int i = startPos, j = 0; i < endPos; i++) {
			this.data[page][i] = newData[j++];
		}
	}
	
	public void setDataAtCurPos (byte[] newData) {
		int startPos = this.endAddress[page];
		int endPos = newData.length+startPos;		
		this.endAddress[page] = endPos;
		
		for (int i = startPos, j = 0; i < endPos; i++) {
			this.data[page][i] = newData[j++];
		}
	}	
	
	public boolean isOutOfMemory() {
		return (page>lastPage);
	}	
}
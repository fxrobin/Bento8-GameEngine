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
    
	public int startPage;    
	public int curPage;
	public int curAddress;	
	public int lastPage;
	
	public int mode;
	
	public RamImage (int lastPage) {
		this.data = new byte[lastPage][PAGE_SIZE];
		this.startAddress = new int[lastPage];
		this.endAddress = new int[lastPage];
		this.lastPage = lastPage;
		this.startPage = lastPage+1;
		this.curPage = 0;		
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
		
		if (page < this.startPage) {
			this.startPage = page;
		}
	}
	
	public void setDataAtCurPos (byte[] newData) {
		int startPos = this.endAddress[curPage];	
		this.endAddress[curPage] = newData.length+startPos;
		
		for (int i = startPos, j = 0; i < this.endAddress[curPage]; i++) {
			this.data[curPage][i] = newData[j++];
		}
		
		this.curAddress = this.endAddress[curPage];
	}	
	
	public boolean isOutOfMemory() {
		return (curPage>=lastPage);
	}	
}
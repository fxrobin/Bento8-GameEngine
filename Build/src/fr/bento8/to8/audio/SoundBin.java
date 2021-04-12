package fr.bento8.to8.audio;

import fr.bento8.to8.storage.FdUtil;
import fr.bento8.to8.util.knapsack.ItemBin;

public class SoundBin extends ItemBin{

	public String name = "";
	public boolean inRAM = false;
	
	public SoundBin() {	
	}
	
	public void setName(String name) {
		this.name = name;
	}	
	
//	public void setFileIndex(FdUtil fd) {
//		int index;
//		if (dataIndex != null) {
//			dataIndex.fd_drive = fd.getUnit();
//			dataIndex.fd_track = fd.getTrack();
//			dataIndex.fd_sector = fd.getSector();
//			index = (fd.getIndex() / 256) * 256; // round to start sector
//			fd.write(this.bin);		
//			dataIndex.fd_nbSector = (int) Math.ceil((fd.getIndex() - index) / 256.0); // round to end sector
//			dataIndex.fd_endOffset = ((int) Math.ceil(fd.getIndex() / 256.0) * 256) - fd.getIndex();
//		}
//	}	
	
	public String getFullName() {
		return "ObjectBin "+this.name;
	}

	public Object getObject() {
		return null;
	}		
}
package fr.bento8.to8.build;

import fr.bento8.to8.disk.FdUtil;
import fr.bento8.to8.util.knapsack.ItemBin;
import fr.bento8.to8.build.Object;

public class ObjectBin extends ItemBin{

	public String name = "";
	public Object parent;
	
	public ObjectBin() {
	}
	
	public ObjectBin(Object obj) {
		this.parent = obj;
	}	
	
	public void setName(String name) {
		this.name = name;
	}	
	
	public void setFileIndex(FdUtil fd) {
		int index;
		if (dataIndex != null) {
			dataIndex.drive = fd.getUnit();
			dataIndex.track = fd.getTrack();
			dataIndex.sector = fd.getSector();
			index = (fd.getIndex() / 256) * 256; // round to start sector
			fd.write(this.bin);		
			dataIndex.nbSector = (int) Math.ceil((fd.getIndex() - index) / 256.0); // round to end sector
			dataIndex.endOffset = ((int) Math.ceil(fd.getIndex() / 256.0) * 256) - fd.getIndex();
		}
	}	
	
	public String getFullName() {
		return "ObjectBin "+this.name;
	}

	public Object getObject() {
		return parent;
	}
			
}
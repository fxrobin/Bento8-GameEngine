package fr.bento8.to8.image;

import fr.bento8.to8.build.FileNames;
import fr.bento8.to8.disk.FdUtil;
import fr.bento8.to8.util.knapsack.ItemBin;

public class AnimationBin extends ItemBin{

	public String name = "";
	public String fileName;

	public AnimationBin(String objName) {
		this.fileName = objName + FileNames.ANIMATION;
	}
	
	public void setName(String name) {
		this.name = name;
	}	
	
	public void setFileIndex(FdUtil fd) {
		int index;
		if (fileIndex != null) {
			fileIndex.drive = fd.getUnit();
			fileIndex.track = fd.getTrack();
			fileIndex.sector = fd.getSector();
			index = (fd.getIndex() / 256) * 256; // round to start sector
			fd.write(this.bin);		
			fileIndex.nbSector = (int) Math.ceil((fd.getIndex() - index) / 256.0); // round to end sector
			fileIndex.endOffset = ((int) Math.ceil(fd.getIndex() / 256.0) * 256) - fd.getIndex();
		}
	}	
	
	public String getFullName() {
		return "AnimationBin "+this.name;
	}

	public Object getObject() {
		return null;
	}	
	
}
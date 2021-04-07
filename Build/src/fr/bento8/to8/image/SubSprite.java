package fr.bento8.to8.image;

import fr.bento8.to8.storage.DataIndex;
import fr.bento8.to8.storage.FdUtil;

public class SubSprite {

	public Sprite parent;
	public String name = "";

	public SubSpriteBin draw;
	public SubSpriteBin erase;

	public int x_size;
	public int y_size;	
	public int x1_offset;	
	public int y1_offset;
	public int nb_cell;
	public int center_offset;
	
	public SubSprite(Sprite p) {
		parent = p;
	}

	public void setFileIndex(SubSpriteBin ss, FdUtil fd) {
		int index;
		if (ss.dataIndex != null) {
			ss.dataIndex.drive = fd.getUnit();
			ss.dataIndex.track = fd.getTrack();
			ss.dataIndex.sector = fd.getSector();
			index = (fd.getIndex() / 256) * 256; // round to start sector
			fd.write(ss.bin);
			ss.dataIndex.nbSector = (int) Math.ceil((fd.getIndex() - index) / 256.0); // round to end sector
			ss.dataIndex.endOffset = ((int) Math.ceil(fd.getIndex() / 256.0) * 256) - fd.getIndex();
		}
	}
	
	public void setAllFileIndex(FdUtil fd) {
		if (draw != null && draw.dataIndex != null) {
			setFileIndex(draw, fd);
		}
		if (erase != null && erase.dataIndex != null) {
			setFileIndex(erase, fd);
		}
	}

	public void setName(String name) {
		this.name = name;
	}
}
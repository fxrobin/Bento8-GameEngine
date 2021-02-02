package fr.bento8.to8.image;

import fr.bento8.to8.disk.FdUtil;
import fr.bento8.to8.disk.DataIndex;

public class SubSprite {

	public Sprite parent;
	public String name = "";

	public SubSpriteBin bckDraw;
	public SubSpriteBin erase;
	public SubSpriteBin draw;

	public int nb_cell;
	public int x_offset;
	public int y_offset;
	public int x_size;
	public int y_size;

	public SubSprite(Sprite p) {
		parent = p;
	}

	public void setFileIndex(SubSpriteBin ss, FdUtil fd) {
		int index;
		if (ss.fileIndex != null) {
			ss.fileIndex.drive = fd.getUnit();
			ss.fileIndex.track = fd.getTrack();
			ss.fileIndex.sector = fd.getSector();
			index = (fd.getIndex() / 256) * 256; // round to start sector
			fd.write(ss.bin);
			ss.fileIndex.nbSector = (int) Math.ceil((fd.getIndex() - index) / 256.0); // round to end sector
			ss.fileIndex.endOffset = ((int) Math.ceil(fd.getIndex() / 256.0) * 256) - fd.getIndex();
		}
	}
	
	public void setAllFileIndex(FdUtil fd) {
		if (bckDraw != null && bckDraw.fileIndex != null) {
			setFileIndex(bckDraw, fd);			
		}
		if (erase != null && erase.fileIndex != null) {
			setFileIndex(erase, fd);
		}
		if (draw != null && draw.fileIndex != null) {
			setFileIndex(draw, fd);
		}
	}

	public void setName(String name) {
		this.name = name;
	}
}
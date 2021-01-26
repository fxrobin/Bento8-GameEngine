package fr.bento8.to8.image;

import fr.bento8.to8.disk.FdUtil;
import fr.bento8.to8.disk.FileIndex;

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

	public void setFileIndex(FileIndex fi, FdUtil fd) {
		int index;
		if (fi != null) {
			fi.drive = fd.getUnit();
			fi.track = fd.getTrack();
			fi.sector = fd.getSector();
			index = (fd.getIndex() / 256) * 256; // round to start sector
			fd.write(bckDraw.bin);
			fi.nbSector = (int) Math.ceil((fd.getIndex() - index) / 256.0); // round to end sector
			fi.endOffset = ((int) Math.ceil(fd.getIndex() / 256.0) * 256) - fd.getIndex();
		}
	}
	
	public void setAllFileIndex(FdUtil fd) {
		if (bckDraw != null && bckDraw.fileIndex != null) {
			setFileIndex(bckDraw.fileIndex, fd);			
		}
		if (erase != null && erase.fileIndex != null) {
			setFileIndex(erase.fileIndex, fd);
		}
		if (draw != null && draw.fileIndex != null) {
			setFileIndex(draw.fileIndex, fd);
		}
	}

	public void setName(String name) {
		this.name = name;
	}
}
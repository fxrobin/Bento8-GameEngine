package fr.bento8.to8.image;

import fr.bento8.to8.disk.FdUtil;
import fr.bento8.to8.disk.FileIndex;

public class SubSprite {

	String SpriteTag;

	public byte[] binBckDraw;
	public byte[] binErase;
	public byte[] binDraw;

	public int page_bckdraw_routine;
	public int bckdraw_routine;
	public int page_draw_routine;
	public int draw_routine;
	public int page_erase_routine;
	public int erase_routine;
	public int nb_cell;
	public int x_offset;
	public int y_offset;
	public int x_size;
	public int y_size;

	public FileIndex fileIndexBckDraw;
	public FileIndex fileIndexErase;
	public FileIndex fileIndexDraw;

	public SubSprite() {
	}

	public void setFileIndex(FileIndex fi, FdUtil fd) {
		int index;
		if (fi != null) {
			fi.drive = fd.getUnit();
			fi.track = fd.getTrack();
			fi.sector = fd.getSector();
			index = (fd.getIndex() / 256) * 256; // round to start sector
			fd.write(binBckDraw);
			fi.nbSector = (int) Math.ceil((fd.getIndex() - index) / 256.0); // round to end sector
			fi.endOffset = ((int) Math.ceil(fd.getIndex() / 256.0) * 256) - fd.getIndex();
		}
	}
	
	public void setAllFileIndex(FdUtil fd) {	
		setFileIndex(fileIndexBckDraw, fd);			
		setFileIndex(fileIndexErase, fd);
		setFileIndex(fileIndexDraw, fd);
	}
}
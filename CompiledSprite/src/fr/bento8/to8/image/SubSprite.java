package fr.bento8.to8.image;

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
	public FileIndex fileIndexDraw;
	public FileIndex fileIndexErase;	

	public SubSprite() {
		fileIndexBckDraw = new FileIndex();
		fileIndexDraw = new FileIndex();
		fileIndexErase = new FileIndex();
	}
}
package fr.bento8.to8.disk;

/**
 * @author Benoît Rousseau
 * @version 1.0
 *
 */
public class FileIndex
{
	
	public int drive;
	public int track;
	public int sector;
	public int nbSector;
	public int endOffset;
	public int page;
	public int address;	
	
	public FileIndex() {
	}
}
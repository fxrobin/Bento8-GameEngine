package fr.bento8.to8.storage;

/**
 * @author Benoît Rousseau
 * @version 1.0
 *
 */
public class DataIndex
{
	public String gmNameCommon; // nom du commun utilisé par le game mode
	
	// FLOPPY DISK
	public int drive;
	public int track;
	public int sector;
	public int nbSector;
	public int endOffset;
	
	// MEGAROM T.2
	public int t2Page;	     // page de source ROM
	public int t2EndAddress; // adresse de source (ptr de fin pour exomizer) ROM
	
	// RAM
	public int page;         // page de destination RAM
	public int address;	     // adresse RAM
	public int endAddress;   // adresse de destination (ptr de fin) RAM	
	
	public DataIndex() {
	}
}
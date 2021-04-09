package fr.bento8.to8.storage;

/**
 * @author Benoît Rousseau
 * @version 1.0
 *
 */
public class DataIndex
{
	// FLOPPY DISK
	public int fd_drive;
	public int fd_track;
	public int fd_sector;
	public int fd_nbSector;
	public int fd_endOffset;
	
	// MEGAROM T.2
	public int t2_page;	          // page de source ROM
	public int t2_address;	      // adresse RAM	
	public int t2_endAddress;     // adresse de source (ptr de fin pour exomizer) ROM
	
	// RAM FD
	public int fd_ram_page;       // page de destination RAM
	public int fd_ram_address;	  // adresse RAM
	public int fd_ram_endAddress; // adresse de destination (ptr de fin) RAM	

	// RAM T.2	
	public int t2_ram_page;       // page de destination RAM
	public int t2_ram_address;	  // adresse RAM
	public int t2_ram_endAddress; // adresse de destination (ptr de fin) RAM		
	
	public DataIndex() {
	}
}
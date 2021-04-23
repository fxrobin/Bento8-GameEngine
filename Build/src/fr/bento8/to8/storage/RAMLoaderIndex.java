package fr.bento8.to8.storage;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.build.GameMode;
import fr.bento8.to8.build.GameModeCommon;

/**
 * @author Benoît Rousseau
 * @version 1.0
 *
 */
public class RAMLoaderIndex
{
	// FLOPPY DISK
	public int fd_drive;
	public int fd_track;
	public int fd_sector;
	public int fd_nbSector;
	public int fd_endOffset;		
	
	// MEGAROM T.2
	public int t2_page;	          // page de source ROM
	public int t2_address;	      // adresse ROM	
	public int t2_endAddress;     // adresse de source (ptr de fin pour exomizer) ROM

	// RAM
	public int ram_page;       // page de destination RAM
	public int ram_address;	   // adresse RAM
	public int ram_endAddress; // adresse de destination (ptr de fin) RAM	
	
	public byte[] exoBin;
	public boolean split = true;
	
	public List<GameMode> gml = new ArrayList<GameMode>();
	public GameModeCommon gmc;
	
	public RAMLoaderIndex() {
	}
}
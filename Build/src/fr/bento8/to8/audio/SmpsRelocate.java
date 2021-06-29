package fr.bento8.to8.audio;

import java.io.FileOutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class SmpsRelocate{
	
	private static int SMPS_VOICE = 0;
	private static int SMPS_NB_FM = 2;
	private static int SMPS_NB_PSG = 3;
	private static int SMPS_FM_START = 6;
	private static int SMPS_FM_SIZE = 4;
	private static int SMPS_PSG_SIZE = 6;
	

	private static byte[] fIN;
	private static FileOutputStream fOUT;
	private static int offset = 0;
	
	public static void main(String[] args) throws Throwable {

		System.out.println("*** Relocate Smps pointers ***");

		if (args.length != 2) {
			System.out.println("Arguments: inputfile address_offset");
			System.out.println(" the first parameter is the smps file.");
			System.out.println(" the second parameter is the address offset to apply to pointers in the smps file.");
			System.out.println(" ex: -10 will substract 10 to address pointers");
			return;
		}

		fIN = Files.readAllBytes(Paths.get(args[0]));
		if (fIN == null) {
			System.out.println("Fatal: can't open input file");
			return;
		}
		
		offset = Integer.parseInt(args[1]);
		
		fOUT = new FileOutputStream(args[1]);
		if (fOUT == null) {
			System.out.println("Fatal: can't write to output PSG file");
			return;
		}
		
		// Relocate Voice
		// ********************************************************************
		
		relocate(SMPS_VOICE);
		
		// Relocate Tracks
		// ********************************************************************		
		
		int nbFMTracks = fIN[SMPS_NB_FM];
		int pos = SMPS_FM_START;
		for (int i = 0; i < nbFMTracks; i++) {
			relocateTrack(pos);
			pos += SMPS_FM_SIZE;
		}
		
		int nbPSGTracks = fIN[SMPS_NB_PSG];
		for (int i = 0; i < nbPSGTracks; i++) {
			relocateTrack(pos);
			pos += SMPS_PSG_SIZE;
		}		
		
		while (pos < fIN.length) {
			
			// Notes
			// ********************************************************************
			if (fIN[pos]>(byte)0x87 && fIN[pos]<(byte)0xE0) {
				
				// perfect Map
				fIN[pos] = (byte) (fIN[pos]-7);
				
			} else if (fIN[pos]>(byte)0x80 && fIN[pos]<=(byte)0x87) {
				
				// YM2413 cannot produce deep bass so Octave up
				fIN[pos] = (byte) (fIN[pos]+5);
				
				//fIN[pos] = (byte) 0x80; Alt solution si to silence note
				//fIN[pos] = (byte) 0x81; Alt solution si to play lowest note				
			}			
			
			// Coordination flags
			// ********************************************************************
			switch (fIN[pos]) {
				case (byte)0xE6: //E6xx - volume
					fIN[pos+1] = (byte) (fIN[pos+1] / 8);
			    	pos += 2;
			    	break;				
				case (byte)0xF0: //F0wwxxyyzz - modulation TODO piste FM seulement !!!
					modulation(pos+3);
			    	pos += 5;
			    	break;				
				case (byte)0xF6: //$F6zzzz
				case (byte)0xF8: //$F8zzzz					
					relocateOffsetBack(pos+1);
				    pos += 3;
					break;
				case (byte)0xF7: //$F7xxyyzzzz
					relocateOffsetBack(pos+3);
				    pos += 5;
					break;				
				default:
					pos++;
					break;
			}			
			
		}				
		Path path = Paths.get(args[0]+".smp");
		Files.write(path, fIN);
	}
	
	private static void relocate (int pos) throws Exception {
		if (pos > fIN.length) {
			throw new Exception ("File is invalid.");
		}
		int address = ((fIN[pos+1] & 0xff) << 8) | (fIN[pos] & 0xff);
		address += offset;
		fIN[pos] = (byte) (address >> 8);
		fIN[pos+1] = (byte) (address);
	}

	private static void relocateTrack (int pos) throws Exception {
		if (pos > fIN.length) {
			throw new Exception ("File is invalid.");
		}
		int address = ((fIN[pos+1] & 0xff) << 8) | (fIN[pos] & 0xff);
		address += offset;
		fIN[pos] = (byte) (address >> 8);
		fIN[pos+1] = (byte) (address);
		fIN[pos+3] = (byte) (fIN[pos+3] / 8); // Volume
	}
	
	private static void relocateOffsetBack (int pos) throws Exception {
		if (pos > fIN.length) {
			throw new Exception ("File is invalid.");
		}
		int address = ((fIN[pos+1] & 0xff) << 8) | (fIN[pos] & 0xff);
		address += offset-pos;
		fIN[pos] = (byte) (address >> 8);
		fIN[pos+1] = (byte) (address);
	}

	private static void modulation (int pos) throws Exception {
		if (pos > fIN.length) {
			throw new Exception ("File is invalid.");
		}
		int value = (fIN[pos] & 0xff);
		value = (int) (value/3.733333333);
		if (value==0) {value=(byte)0x01;}
		fIN[pos] = (byte) (value);
	}	
}
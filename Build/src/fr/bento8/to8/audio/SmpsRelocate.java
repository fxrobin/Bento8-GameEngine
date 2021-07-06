package fr.bento8.to8.audio;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import fr.bento8.to8.audio.YmVoice.OPNVoice;
import fr.bento8.to8.audio.YmVoice.OPNVoice.OPNSlotParam;

public class SmpsRelocate{

	private static int SMPS_VOICE = 0;
	private static int SMPS_NB_FM = 2;
	private static int SMPS_NB_PSG = 3;
	private static int SMPS_FM_START = 6;
	private static int SMPS_FM_SIZE = 4;
	private static int SMPS_PSG_SIZE = 6;

	private static byte[] fIN;
	private static byte[] fOUT;
	private static int offset = 0; //-4992 pour S2, -55191 pour Staff Roll 

	public static void main(String[] args) throws Throwable {

		System.out.println("*** YM2612 to YM2413 Smps converter ***");

		if (args.length !=2 && args.length != 3) {
			System.out.println("Arguments: inputfile address_offset voicefile");
			System.out.println(" the first parameter is the smps file.");
			System.out.println(" the second parameter is the address offset to apply to pointers in the smps file.");
			System.out.println(" ex: -10 will substract 10 to address pointers");
			System.out.println(" the third parameter is the voice mapping file (optional)");
			return;
		}

		fIN = Files.readAllBytes(Paths.get(args[0]));
		if (fIN == null) {
			System.out.println("Fatal: can't open input file");
			return;
		}
		
		offset = Integer.parseInt(args[1]);

		// Relocate Voice
		// ********************************************************************

		int voicePos = relocate(SMPS_VOICE);
		int nbVoices = 0;

		// Load Voices
		if (args.length == 3) {
			
// TODO : Add Transpose/Volume override to file conf
//			Path voiceFile = Path.of(args[2]);
//			if (voiceFile == null) {
//				System.out.println("Fatal: can't input voice file");
//				return;			
//			}
//			String voice = Files.readString(voiceFile);
//			StringTokenizer voices = new StringTokenizer(voice, " .,;-/:|");
//			int vi = 0;
//			while (voices.hasMoreTokens())
//			{
//				voiceMap[vi++] = hexStringToByteArray(voices.nextToken()+"0")[0];	
//			}
		} else {
			int curVoice = voicePos, dstVoice = voicePos;
			byte[] result;
			while (curVoice<fIN.length) {
				result = estimateOPPLLVoice1234(curVoice);
				fIN[dstVoice++] = result[0];
				fIN[dstVoice++] = result[1];
				curVoice += 25;
				nbVoices++;
			}
		}		

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
			// Coordination flags
			// ********************************************************************
			switch (fIN[pos]) {
			case (byte)0xE6: //E6xx - volume
				fIN[pos+1] = (byte) (fIN[pos+1] / 8); // TODO conserver la parte de précision pour répercuter sur instr suivante
				pos += 2;
				break;
			case (byte)0xF0: //F0wwxxyyzz - modulation TODO piste FM seulement !!!
				modulation(pos+2);
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
			case (byte)0xE0: case (byte)0xE1: case (byte)0xE2: case (byte)0xE5: case (byte)0xE8: case (byte)0xE9: case (byte)0xEA: case (byte)0xEB: case (byte)0xEF:
				pos += 2;
				break;				
			default:
				pos++;
				break;
			}			
		}
		
		fOUT = new byte[voicePos+(nbVoices*2)];
		for (int i=0; i<voicePos+(nbVoices*2); i++) {
			fOUT[i] = fIN[i];
		}		
		
		Path path = Paths.get(args[0]+".smp");
		Files.write(path, fOUT);
	}

	private static int relocate (int pos) throws Exception {
		if (pos > fIN.length) {
			throw new Exception ("File is invalid.");
		}
		int address = ((fIN[pos+1] & 0xff) << 8) | (fIN[pos] & 0xff);
		address += offset;
		fIN[pos] = (byte) (address >> 8);
		fIN[pos+1] = (byte) (address);
		return address;
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
		fIN[pos] = (byte) (Math.ceil(value/3.733333333));
	}	

	public static byte[] estimateOPPLLVoice1324 (int pos) {
		OPNVoice opn = new OPNVoice(
				(byte)((fIN[pos] & 0x38) >> 3),
				(byte)(fIN[pos] & 0x07),
				(byte)0,
				(byte)0,
				new OPNSlotParam((byte)((fIN[pos+1+0] & 0x70) >> 4), (byte)(fIN[pos+1+0] & 0xF), (byte)(fIN[pos+21+0] & 0x7F), (byte)((fIN[pos+5+0] & 0x70) >> 6), (byte)(fIN[pos+5+0] & 0x1F), (byte)((fIN[pos+9+0] & 0x80) >> 7), (byte)(fIN[pos+9+0] & 0x7F), (byte)(fIN[pos+13+0] & 0x1F), (byte)((fIN[pos+17+0] & 0xF0) >> 4), (byte)(fIN[pos+17+0] & 0xF), (byte)0),
				new OPNSlotParam((byte)((fIN[pos+1+1] & 0x70) >> 4), (byte)(fIN[pos+1+1] & 0xF), (byte)(fIN[pos+21+1] & 0x7F), (byte)((fIN[pos+5+1] & 0x70) >> 6), (byte)(fIN[pos+5+1] & 0x1F), (byte)((fIN[pos+9+1] & 0x80) >> 7), (byte)(fIN[pos+9+1] & 0x7F), (byte)(fIN[pos+13+1] & 0x1F), (byte)((fIN[pos+17+1] & 0xF0) >> 4), (byte)(fIN[pos+17+1] & 0xF), (byte)0),
				new OPNSlotParam((byte)((fIN[pos+1+2] & 0x70) >> 4), (byte)(fIN[pos+1+2] & 0xF), (byte)(fIN[pos+21+2] & 0x7F), (byte)((fIN[pos+5+2] & 0x70) >> 6), (byte)(fIN[pos+5+2] & 0x1F), (byte)((fIN[pos+9+2] & 0x80) >> 7), (byte)(fIN[pos+9+2] & 0x7F), (byte)(fIN[pos+13+2] & 0x1F), (byte)((fIN[pos+17+2] & 0xF0) >> 4), (byte)(fIN[pos+17+2] & 0xF), (byte)0),
				new OPNSlotParam((byte)((fIN[pos+1+3] & 0x70) >> 4), (byte)(fIN[pos+1+3] & 0xF), (byte)(fIN[pos+21+3] & 0x7F), (byte)((fIN[pos+5+3] & 0x70) >> 6), (byte)(fIN[pos+5+3] & 0x1F), (byte)((fIN[pos+9+3] & 0x80) >> 7), (byte)(fIN[pos+9+3] & 0x7F), (byte)(fIN[pos+13+3] & 0x1F), (byte)((fIN[pos+17+3] & 0xF0) >> 4), (byte)(fIN[pos+17+3] & 0xF), (byte)0)
				);
		return opn.toOPL().toOPLLROMVoice();
	}
	
	public static byte[] estimateOPPLLVoice1234 (int pos) {
		OPNVoice opn = new OPNVoice(
				(byte)((fIN[pos] & 0x38) >> 3),
				(byte)(fIN[pos] & 0x07),
				(byte)0,
				(byte)0,
				new OPNSlotParam((byte)((fIN[pos+1+0] & 0x70) >> 4), (byte)(fIN[pos+1+0] & 0xF), (byte)(fIN[pos+21+0] & 0x7F), (byte)((fIN[pos+5+0] & 0x70) >> 6), (byte)(fIN[pos+5+0] & 0x1F), (byte)((fIN[pos+9+0] & 0x80) >> 7), (byte)(fIN[pos+9+0] & 0x7F), (byte)(fIN[pos+13+0] & 0x1F), (byte)((fIN[pos+17+0] & 0xF0) >> 4), (byte)(fIN[pos+17+0] & 0xF), (byte)0),
				new OPNSlotParam((byte)((fIN[pos+1+2] & 0x70) >> 4), (byte)(fIN[pos+1+2] & 0xF), (byte)(fIN[pos+21+2] & 0x7F), (byte)((fIN[pos+5+2] & 0x70) >> 6), (byte)(fIN[pos+5+2] & 0x1F), (byte)((fIN[pos+9+2] & 0x80) >> 7), (byte)(fIN[pos+9+2] & 0x7F), (byte)(fIN[pos+13+2] & 0x1F), (byte)((fIN[pos+17+2] & 0xF0) >> 4), (byte)(fIN[pos+17+2] & 0xF), (byte)0),
				new OPNSlotParam((byte)((fIN[pos+1+1] & 0x70) >> 4), (byte)(fIN[pos+1+1] & 0xF), (byte)(fIN[pos+21+1] & 0x7F), (byte)((fIN[pos+5+1] & 0x70) >> 6), (byte)(fIN[pos+5+1] & 0x1F), (byte)((fIN[pos+9+1] & 0x80) >> 7), (byte)(fIN[pos+9+1] & 0x7F), (byte)(fIN[pos+13+1] & 0x1F), (byte)((fIN[pos+17+1] & 0xF0) >> 4), (byte)(fIN[pos+17+1] & 0xF), (byte)0),				
				new OPNSlotParam((byte)((fIN[pos+1+3] & 0x70) >> 4), (byte)(fIN[pos+1+3] & 0xF), (byte)(fIN[pos+21+3] & 0x7F), (byte)((fIN[pos+5+3] & 0x70) >> 6), (byte)(fIN[pos+5+3] & 0x1F), (byte)((fIN[pos+9+3] & 0x80) >> 7), (byte)(fIN[pos+9+3] & 0x7F), (byte)(fIN[pos+13+3] & 0x1F), (byte)((fIN[pos+17+3] & 0xF0) >> 4), (byte)(fIN[pos+17+3] & 0xF), (byte)0)
				);
		return opn.toOPL().toOPLLROMVoice();
	}	
	
}
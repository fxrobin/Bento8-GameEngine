package moto.gfx;

import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.awt.image.ColorModel;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.imageio.ImageIO;

public class StmToAsm {
	// Genère un code asm à partir d'un fichier Simple Tile Map .stm

//	Simple tile map (*.stm)
//	This file format can be used to export tile maps into a custom structured format:
//	Position(bytes)	Type	Description
//	$00	4 ASCII-chars	"STMP" as sign for this format
//	$04	Word	Number of horizontal tiles = WIDTH
//	$06	Word	Number of vertical tiles = HEIGHT
//	$08	 	From this position there are WIDTH * HEIGHT entries made up of the following TileReference structure:
//
//	Tile Reference Structure
//	Position(bytes)	Type	Description
//	$00	Word	Tile index
//	$02	Byte	Flag if the tile is to be displayed mirrored horizontally. 0=no mirror
//	$03	Byte	Flag if the tile is to be displayed mirrored vertically. 0=no mirror

	// Image
	BufferedImage image;
	ColorModel colorModel;
	String spriteName;
	int width;
	int height;
	byte[] pixels;
	byte[] pixelsAB;

	public StmToAsm(String file) {
		try {
			// Lecture de l'image a traiter
			image = ImageIO.read(new File(file));
			width = image.getWidth();
			height = image.getHeight();
			colorModel = image.getColorModel();
			int pixelSize = colorModel.getPixelSize();
			// int numComponents = colorModel.getNumComponents();
			spriteName = removeExtension(file).toUpperCase().replaceAll("[^A-Za-z0-9]", "");

			// Contrôle du format d'image
			if (width == 160 && height == 200 && pixelSize == 8) { // && numComponents==3
				
				pixels = ((DataBufferByte) image.getRaster().getDataBuffer()).getData();
				
				// Construction de la RAM A et la RAM B
				int i,j;
				pixelsAB = new byte[16394]; //Determine la taille du fichier de sortie
				// Header pour LOADM
				pixelsAB[0] = (byte) 0x00;
				pixelsAB[1] = (byte) 0x40; // Taille sur 16bits
				pixelsAB[2] = (byte) 0x00;
				pixelsAB[3] = (byte) 0xA0; // Adresse de chargement sur 16bits
				pixelsAB[4] = (byte) 0x00;
				// Data - Ecriture en sens inverse pour PUL/PSH
				for (i = (width*height)-1, j = 5; i >= 28; i -= 28) {
					pixelsAB[j]   = (byte)(pixels[i-27] << 4 | pixels[i-26] & 0x0F );
					pixelsAB[j+1] = (byte)(pixels[i-23] << 4 | pixels[i-22] & 0x0F );
					pixelsAB[j+2] = (byte)(pixels[i-19] << 4 | pixels[i-18] & 0x0F );
					pixelsAB[j+3] = (byte)(pixels[i-15] << 4 | pixels[i-14] & 0x0F );
					pixelsAB[j+4] = (byte)(pixels[i-11] << 4 | pixels[i-10] & 0x0F );
					pixelsAB[j+5] = (byte)(pixels[i-7]  << 4 | pixels[i-6]  & 0x0F );
					pixelsAB[j+6] = (byte)(pixels[i-3]  << 4 | pixels[i-2]  & 0x0F );
					j += 8192;
					pixelsAB[j]   = (byte)(pixels[i-25] << 4 | pixels[i-24] & 0x0F );
					pixelsAB[j+1] = (byte)(pixels[i-21] << 4 | pixels[i-20] & 0x0F );
					pixelsAB[j+2] = (byte)(pixels[i-17] << 4 | pixels[i-16] & 0x0F );
					pixelsAB[j+3] = (byte)(pixels[i-13] << 4 | pixels[i-12] & 0x0F );
					pixelsAB[j+4] = (byte)(pixels[i-9]  << 4 | pixels[i-8]  & 0x0F );
					pixelsAB[j+5] = (byte)(pixels[i-5]  << 4 | pixels[i-4]  & 0x0F );
					pixelsAB[j+6] = (byte)(pixels[i-1]  << 4 | pixels[i]    & 0x0F );
					j -= 8192;
					j += 7;
				}
				pixelsAB[j]   = (byte)(pixels[i-23] << 4 | pixels[i-22] & 0x0F );
				pixelsAB[j+1] = (byte)(pixels[i-19] << 4 | pixels[i-18] & 0x0F );
				pixelsAB[j+2] = (byte)(pixels[i-15] << 4 | pixels[i-14] & 0x0F );
				pixelsAB[j+3] = (byte)(pixels[i-11] << 4 | pixels[i-10] & 0x0F );
				pixelsAB[j+4] = (byte)(pixels[i-7]  << 4 | pixels[i-6]  & 0x0F );
				pixelsAB[j+5] = (byte)(pixels[i-3]  << 4 | pixels[i-2]  & 0x0F );
				j += 8192;
				pixelsAB[j]   = (byte)(pixels[i-21] << 4 | pixels[i-20] & 0x0F );
				pixelsAB[j+1] = (byte)(pixels[i-17] << 4 | pixels[i-16] & 0x0F );
				pixelsAB[j+2] = (byte)(pixels[i-13] << 4 | pixels[i-12] & 0x0F );
				pixelsAB[j+3] = (byte)(pixels[i-9]  << 4 | pixels[i-8]  & 0x0F );
				pixelsAB[j+4] = (byte)(pixels[i-5]  << 4 | pixels[i-4]  & 0x0F );
				pixelsAB[j+5] = (byte)(pixels[i-1]  << 4 | pixels[i]    & 0x0F );
				// Trailer pour LOADM
				pixelsAB[16389] = (byte) 0xFF;
				pixelsAB[16390] = (byte) 0x00;
				pixelsAB[16391] = (byte) 0x00;
				pixelsAB[16392] = (byte) 0x00; 
				pixelsAB[16393] = (byte) 0x00;				
			} else {
				System.out.println("Le format de fichier de " + file + " n'est pas supporté.");
				System.out.println(
						"Resolution: " + width + "x" + height + "px (doit être égal à  160x200)");
				System.out.println("Taille pixel:  " + pixelSize + "Bytes (doit être 8)");
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e);
		}
	}

	public String removeExtension(String s) {

		String separator = System.getProperty("file.separator");
		String filename;

		// Remove the path up to the filename.
		int lastSeparatorIndex = s.lastIndexOf(separator);
		if (lastSeparatorIndex == -1) {
			filename = s;
		} else {
			filename = s.substring(lastSeparatorIndex + 1);
		}

		// Remove the extension.
		int extensionIndex = filename.lastIndexOf(".");
		if (extensionIndex == -1)
			return filename;

		return filename.substring(0, extensionIndex);
	}

	public String getName() {
		return spriteName;
	}
	
	public byte[] getBIN() {
		return pixelsAB;
	}

	void writeBIN(byte[] input, String outputFileName){
		Path fichier = Paths.get(outputFileName);
		try {
			Files.deleteIfExists(fichier);
			Files.createFile(fichier);
			Files.write(fichier, input);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}	
	
	void writeBIN(String outputFileName){
		writeBIN(getBIN(), outputFileName);
	}
	
	public ColorModel getColorModel() {
		return colorModel;
	}
}

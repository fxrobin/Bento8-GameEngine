package moto.gfx;

import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.awt.image.ColorModel;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.imageio.ImageIO;

public class PngToBinModeB16 {
	// Genère un fichier BIN a partir d'un PNG
	// Thomson TO8/TO9+
	// Mode 160x200 en seize couleurs sans contraintes

	// Image
	BufferedImage image;
	ColorModel colorModel;
	String spriteName;
	int width;
	int height;
	byte[] pixels;
	byte[] pixelsAB;

	public PngToBinModeB16(String file) {
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
			if (width <= 160 && height <= 200 && pixelSize == 8) { // && numComponents==3

				// Si la largeur d'image est impaire, on ajoute une colonne de pixel transparent
				// a gauche de l'image
				if (width % 2 != 0) {
					pixels = new byte[(width + 1) * height];
					for (int iSource = 0, iCol = 0, iDest = 0; iDest < (width + 1) * height; iDest++) {
						if (iCol == 0) {
							pixels[iDest] = 16;
						} else {
							pixels[iDest] = (byte) ((DataBufferByte) image.getRaster().getDataBuffer())
									.getElem(iSource);
							iSource++;
						}

						iCol++;
						if (iCol == width + 1) {
							iCol = 0;
						}
					}
					width = width + 1;
				} else { // Sinon construction du tableau de pixels Ã  partir de l'image
					pixels = ((DataBufferByte) image.getRaster().getDataBuffer()).getData();
				}

				// Construction de la RAM A et la RAM B
				int i,j;
				pixelsAB = new byte[16384]; //Determine la taille du fichier de sortie
				for (i = 0, j = 0; i < (width*height) - 8; i += 8) {
					pixelsAB[j]      = (byte)(pixels[i]   << 4 | pixels[i+1] & 0x0F );
					pixelsAB[j+1]    = (byte)(pixels[i+2] << 4 | pixels[i+3] & 0x0F );
					pixelsAB[j+8192] = (byte)(pixels[i+4] << 4 | pixels[i+5] & 0x0F );
					pixelsAB[j+8193] = (byte)(pixels[i+6] << 4 | pixels[i+7] & 0x0F );
					j += 2;
				}
				if (i < (width*height) - 4) {
					pixelsAB[j]      = (byte)(pixels[i]   << 4 | pixels[i+1] & 0x0F );
					pixelsAB[j+1]    = (byte)(pixels[i+2] << 4 | pixels[i+3] & 0x0F );
				}
			} else {
				// Présente les formats acceptés Ã  l'utilisateur en cas de fichier d'entrée
				// incompatible
				System.out.println("Le format de fichier de " + file + " n'est pas supporté.");
				System.out.println(
						"Resolution: " + width + "x" + height + "px (doit Ãªtre inférieur ou égal Ã  160x200)");
				System.out.println("Taille pixel:  " + pixelSize + "Bytes (doit Ãªtre 8)");
				// System.out.println("Nombre de composants: "+numComponents+" (doit Ãªtre 3)");
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
}

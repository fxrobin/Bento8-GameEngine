package fr.bento8.to8.image;

import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.awt.image.ColorModel;
import java.io.File;

import javax.imageio.ImageIO;

public class PngToBottomUpBinB16 {
	BufferedImage image;
	ColorModel colorModel;
	int width;
	int height;
	byte[] pixels;
	byte[] pixelsAB;

	/**
	 * Charge un PNG et génère une page mémoire prête à l'affichage pour TO8
	 * Les données sont copiées à l'envers pour utilisation PUL/PSH remontant
	 * @param nom du fichier image
	 */
	public PngToBottomUpBinB16(String file) {
		try {
			System.out.println("**************** Conversion binaire pour PUL/PSH remontant "+file+" ****************");
			
			// Lecture de l'image a traiter
			image = ImageIO.read(new File(file));
			width = image.getWidth();
			height = image.getHeight();
			colorModel = image.getColorModel();
			int pixelSize = colorModel.getPixelSize();

			// Contrôle du format d'image
			if (width == 160 && height == 200 && pixelSize == 8) {
				
				pixels = ((DataBufferByte) image.getRaster().getDataBuffer()).getData();
				
				// Construction de la RAM A et la RAM B
				int i,j;
				pixelsAB = new byte[16384];

				// RAMA
				for (i = 0, j = 8192; i < width*height; i += 4) {
					pixelsAB[j] = (byte)((pixels[i]-1) << 4 | (pixels[i+1]-1) & 0x0F );
					j++;
				}
				
				// RAMB
				for (i = 2, j = 0; i < width*height; i += 4) {
					pixelsAB[j] = (byte)((pixels[i]-1) << 4 | (pixels[i+1]-1) & 0x0F );
					j++;
				}	
			} else {
				System.out.println("Le format de fichier de " + file + " n'est pas supporté.");
				System.out.println("Resolution: " + width + "x" + height + "px (doit être égal à 160x200)");
				System.out.println("Taille pixel:  " + pixelSize + "Bytes (doit être 8)");
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e);
		}
	}

	public byte[] getBIN() {
		return pixelsAB;
	}
}

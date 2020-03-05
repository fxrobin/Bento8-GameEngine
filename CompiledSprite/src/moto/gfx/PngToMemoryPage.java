package moto.gfx;

import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.awt.image.ColorModel;
import java.io.File;

import javax.imageio.ImageIO;

public class PngToMemoryPage {
	// Charge un PNG et génère une page mémoire prête à l'affichage pour TO8

	BufferedImage image;
	ColorModel colorModel;
	int width;
	int height;
	byte[] pixels;
	byte[] pixelsAB;

	public PngToMemoryPage(String file) {
		try {
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
					//pixelsAB[j] = (byte)((pixels[i+1]-1) << 4 | (pixels[i]-1) & 0x0F );
					j++;
				}
				
				// RAMB
				for (i = 2, j = 0; i < width*height; i += 4) {
					pixelsAB[j] = (byte)((pixels[i]-1) << 4 | (pixels[i+1]-1) & 0x0F );
					//pixelsAB[j] = (byte)((pixels[i+1]-1) << 4 | (pixels[i]-1) & 0x0F );
					j++;
				}	
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

	public byte[] getBIN() {
		return pixelsAB;
	}
}

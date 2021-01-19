package fr.bento8.to8.image;

import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.awt.image.ColorModel;
import java.awt.Color;
import java.awt.geom.AffineTransform;
import java.io.File;
import javax.imageio.ImageIO;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.ArrayList;
import java.util.List;

public class SpriteSheet {
	// Convertion d'une planche de sprites en tableaux de donnéses RAMA et RAMB pour chaque Sprite
	// Thomson TO8/TO9+
	// Mode 160x200 en seize couleurs sans contraintes
	
	private static final Logger logger = LogManager.getLogger("log");

	private BufferedImage image;
	private String name;
	ColorModel colorModel;
	private int width; // largeur totale de l'image
	private int height; // longueur totale de l'image

	private Boolean hFlipped = false; // L'image est-elle inversée horizontalement ?
	private int subImageNb; // Nombre de sous-images
	private int subImageWidth; // Largeur des sous-images

	private byte[][][] pixels;
	private byte[][][] data;

	public SpriteSheet(String tag, String file, int nbImages, String flip) {
		try {
			subImageNb = nbImages;
			image = ImageIO.read(new File(file));
			name = tag;
			width = image.getWidth();
			height = image.getHeight();
			colorModel = image.getColorModel();
			int pixelSize = colorModel.getPixelSize();

			if (width % nbImages == 0) { // Est-ce que la division de la largeur par le nombre d'images donne un entier ?

				subImageWidth = width/nbImages; // Largeur de la sous-image

				if (subImageWidth <= 160 && height <= 200 && pixelSize == 8) { // Contrôle du format d'image

					// On inverse l'image verticalement		
					if (flip.equals("Y")) {
						AffineTransform tx = AffineTransform.getScaleInstance(1, -1);
						tx.translate(0, -image.getHeight(null));
						AffineTransformOp op = new AffineTransformOp(tx, AffineTransformOp.TYPE_NEAREST_NEIGHBOR);
						image = op.filter(image, null);
					}

					// On inverse l'image horizontalement		
					else if (flip.equals("X")) {
						hFlipped = true;
						AffineTransform tx = AffineTransform.getScaleInstance(-1, 1);
						tx.translate(-image.getWidth(null), 0);
						AffineTransformOp op = new AffineTransformOp(tx, AffineTransformOp.TYPE_NEAREST_NEIGHBOR);
						image = op.filter(image, null);
					}

					// On inverse l'image horizontalement et verticalement		
					else if (flip.equals("XY") || flip.equals("YX")) {
						hFlipped = true;
						AffineTransform tx = AffineTransform.getScaleInstance(-1, -1);
						tx.translate(-image.getWidth(null), -image.getHeight(null));
						AffineTransformOp op = new AffineTransformOp(tx, AffineTransformOp.TYPE_NEAREST_NEIGHBOR);
						image = op.filter(image, null);
					}

					prepareImages();

				} else {
					System.out.println("Le format de fichier de " + file + " n'est pas support�.");
					System.out.println("Resolution: " + subImageWidth + "x" + height + "px (doit �tre inf�rieur ou �gal � 160x200)");
					System.out.println("Taille pixel:  " + pixelSize + "Bytes (doit �tre 8)");
					// System.out.println("Nombre de composants: "+numComponents+" (doit être 3)");
				}
			}
			else {
				System.out.println("La largeur d'image :" + width + " n'est pas divisible par le nombre d'images :" +  nbImages);
			}

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e);
		}
	}

	public void prepareImages() {
		// s�pare l'image en deux parties pour la RAM A et RAM B
		// ajoute les pixels transparents pour constituer une image lin�aire de largeur 2x80px
		// l'image se termine par toujours par un multiple de 4 pixels Ram 0 et Ram 1 sont de m�me taille
		pixels = new byte[subImageNb][2][(80 * (height-1)) + ((subImageWidth + (subImageWidth % 4 == 0 ? 0 : (4 - (subImageWidth % 4)))) / 2)];
		data = new byte[subImageNb][2][(80 * (height-1)) + ((subImageWidth + (subImageWidth % 4 == 0 ? 0 : (4 - (subImageWidth % 4)))) / 2)];

		for (int position = 0; position < subImageNb; position++) { // Parcours de toutes les sous-images
			int index = subImageWidth*position;		
			int indexDest = 0;
			int curLine = 0;
			int page = 0;
			while (index<subImageWidth*(position+1) + width*(height-1)) { // Parcours de tous les pixels de l'image
				// Ecriture des pixels 2 � 2
				pixels[position][page][indexDest] = (byte) (((DataBufferByte) image.getRaster().getDataBuffer()).getElem(index));
				if (pixels[position][page][indexDest] == 0) {
					data[position][page][indexDest] = 0;
				} else {
					data[position][page][indexDest] = (byte) (pixels[position][page][indexDest]-1);
				}
				index++;

				if (index == subImageWidth*(position+1) + curLine*width) {
					curLine++;
					index = subImageWidth*position + curLine*width;
					indexDest = 80*curLine;
					page = 0;
				} else {
					pixels[position][page][indexDest+1] = (byte) (((DataBufferByte) image.getRaster().getDataBuffer()).getElem(index));
					if (pixels[position][page][indexDest+1] == 0) {
						data[position][page][indexDest+1] = 0;
					} else {
						data[position][page][indexDest+1] = (byte) (pixels[position][page][indexDest+1]-1);
					}
					index++;

					// Alternance des banques RAM A et RAM B
					if (page == 0) {
						page = 1;
					} else {
						page = 0;
						indexDest = indexDest+2;
					}

					if (index == subImageWidth*(position+1) + curLine*width) {
						curLine++;
						index = subImageWidth*position + curLine*width;
						indexDest = 80*curLine;
						page = 0;
					}
				}
			}
		}
	}

	public byte[] getSubImagePixels(int subImagePos, int ramPage) {
		int position = subImagePos;

		// si l'image est invers�e horizontalement, on inverse �galement l'index des sous-images
		if (hFlipped) {
			position = (subImageNb-1) - position;
		}

		return pixels[position][ramPage];
	}

	public byte[] getSubImageData(int subImagePos, int ramPage) {
		int position = subImagePos;

		// si l'image est invers�e horizontalement, on inverse �galement l'index des sous-images
		if (hFlipped) {
			position = (subImageNb-1) - position;
		}

		return data[position][ramPage];
	}

	public String getCodePalette(double gamma) {
		// std gamma: 3
		// suggestion : 2 ou 2.2
		
		String code = "\n";
		code += "\nTABPALETTE";
		
		// Construction de la palette de couleur
		for (int j = 1; j < 17; j++) {
			Color couleur = new Color(colorModel.getRGB(j));
			code += "\n\tFDB $0"
					+ Integer.toHexString((int) Math.round(15 * Math.pow((couleur.getBlue() / 255.0), gamma)))
					+ Integer.toHexString((int) Math.round(15 * Math.pow((couleur.getGreen() / 255.0), gamma)))
					+ Integer.toHexString((int) Math.round(15 * Math.pow((couleur.getRed() / 255.0), gamma)))
					+ "\t* index:"
					+ String.format("%-2.2s", j)
					+ " R:" + String.format("%-3.3s", couleur.getRed())
					+ " V:" + String.format("%-3.3s", couleur.getGreen())
					+ " B:" + String.format("%-3.3s", couleur.getBlue());
		}
		code += "\nFINTABPALETTE";

		logger.debug(code);

		return code;
	}

	public int getSize() {
		return subImageNb;
	}

	public String getName() {
		return name;
	}	

}
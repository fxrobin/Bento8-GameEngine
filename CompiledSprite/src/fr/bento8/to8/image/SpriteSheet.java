package fr.bento8.to8.image;

import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.awt.image.ColorModel;
import java.awt.Color;
import java.awt.geom.AffineTransform;
import java.io.File;
import javax.imageio.ImageIO;
import java.util.ArrayList;
import java.util.List;

public class SpriteSheet {
	// Convertion d'une planche de sprites en tableaux de données RAMA et RAMB pour chaque Sprite
	// Thomson TO8/TO9+
	// Mode 160x200 en seize couleurs sans contraintes

	private BufferedImage image;
	ColorModel colorModel;
	private int width; // largeur totale de l'image
	private int height; // longueur totale de l'image

	private Boolean hFlipped = false; // L'image est-elle inversée horizontalement ?
	private int subImageNb; // Nombre de sous-images
	private int subImageWidth; // Largeur des sous-images

	private byte[][][] pixels;

	public SpriteSheet(String file, int nbImages, String flip) {
		try {
			subImageNb = nbImages;
			image = ImageIO.read(new File(file));
			width = image.getWidth();
			height = image.getHeight();
			colorModel = image.getColorModel();
			int pixelSize = colorModel.getPixelSize();

			getCodePalette(2.2);

			if (width % nbImages == 0) { // Est-ce que la division de la largeur par le nombre d'images donne un entier ?

				subImageWidth = width/nbImages; // Largeur de la sous-image

				if (subImageWidth <= 160 && height <= 200 && pixelSize == 8) { // Contrôle du format d'image

					// On inverse l'image verticalement		
					if (flip.equals("V")) {
						AffineTransform tx = AffineTransform.getScaleInstance(1, -1);
						tx.translate(0, -image.getHeight(null));
						AffineTransformOp op = new AffineTransformOp(tx, AffineTransformOp.TYPE_NEAREST_NEIGHBOR);
						image = op.filter(image, null);
					}

					// On inverse l'image horizontalement		
					else if (flip.equals("H")) {
						hFlipped = true;
						AffineTransform tx = AffineTransform.getScaleInstance(-1, 1);
						tx.translate(-image.getWidth(null), 0);
						AffineTransformOp op = new AffineTransformOp(tx, AffineTransformOp.TYPE_NEAREST_NEIGHBOR);
						image = op.filter(image, null);
					}

					// On inverse l'image horizontalement et verticalement		
					else if (flip.equals("HV") || flip.equals("VH")) {
						hFlipped = true;
						AffineTransform tx = AffineTransform.getScaleInstance(-1, -1);
						tx.translate(-image.getWidth(null), -image.getHeight(null));
						AffineTransformOp op = new AffineTransformOp(tx, AffineTransformOp.TYPE_NEAREST_NEIGHBOR);
						image = op.filter(image, null);
					}

					prepareImages();

				} else {
					System.out.println("Le format de fichier de " + file + " n'est pas supporté.");
					System.out.println("Resolution: " + subImageWidth + "x" + height + "px (doit Ãªtre inférieur ou égal Ã  160x200)");
					System.out.println("Taille pixel:  " + pixelSize + "Bytes (doit Ãªtre 8)");
					// System.out.println("Nombre de composants: "+numComponents+" (doit Ãªtre 3)");
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
		// sépare l'image en deux parties pour la RAM A et RAM B
		// ajoute les pixels transparents pour constituer une image linéaire de largeur 2x80px
		// l'image se termine par toujours par un multiple de 4 pixels Ram 0 et Ram 1 sont de même taille
		pixels = new byte[subImageNb][2][(80 * (height-1)) + ((subImageWidth + (subImageWidth % 4 == 0 ? 0 : (4 - (subImageWidth % 4)))) / 2)];

		for (int position = 0; position < subImageNb; position++) { // Parcours de toutes les sous-images
			int index = subImageWidth*position;		
			int indexDest = 0;
			int curLine = 0;
			int page = 0;
			while (index<subImageWidth*(position+1) + width*(height-1)) { // Parcours de tous les pixels de l'image
				// Ecriture des pixels 2 à 2
				pixels[position][page][indexDest] = (byte) (((DataBufferByte) image.getRaster().getDataBuffer()).getElem(index));
				index++;
				
				if (index == subImageWidth*(position+1) + curLine*width) {
					curLine++;
					index = subImageWidth*position + curLine*width;
					indexDest = 80*curLine;
					page = 0;
				} else {
					pixels[position][page][indexDest+1] = (byte) (((DataBufferByte) image.getRaster().getDataBuffer()).getElem(index));
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

		// si l'image est inversée horizontalement, on inverse également l'index des sous-images
		if (hFlipped) {
			position = (subImageNb-1) - position;
		}

		return pixels[position][ramPage];
	}

	public List<String> getCodePalette(double gamma) {
		// std gamma: 3
		// suggestion : 2 ou 2.2
		List<String> code = new ArrayList<String>();
		code.add("");
		code.add("TABPALETTE");
		// Construction de la palette de couleur
		for (int j = 1; j < 17; j++) {
			Color couleur = new Color(colorModel.getRGB(j));
			code.add("\tFDB $0"
					+ Integer.toHexString((int) Math.round(15 * Math.pow((couleur.getBlue() / 255.0), gamma)))
					+ Integer.toHexString((int) Math.round(15 * Math.pow((couleur.getGreen() / 255.0), gamma)))
					+ Integer.toHexString((int) Math.round(15 * Math.pow((couleur.getRed() / 255.0), gamma)))
					+ "\t* index:"
					+ String.format("%-2.2s", j)
					+ " R:" + String.format("%-3.3s", couleur.getRed())
					+ " V:" + String.format("%-3.3s", couleur.getGreen())
					+ " B:" + String.format("%-3.3s", couleur.getBlue()));
		}
		code.add("FINTABPALETTE");
		
        for(String line : code) {
            System.out.println(line);
        }
		
		return code;
	}

	public int getSubImageNb() {
		return subImageNb;
	}	

	// Gestion des images en 32bits
	//	if (pixelSize == 32) {
	//	final byte[] pixels = ((DataBufferByte) image.getRaster().getDataBuffer()).getData();
	//	final int width = image.getWidth();
	//	final int height = image.getHeight();
	//	final boolean hasAlphaChannel = image.getAlphaRaster() != null;
	//
	//	int[][] result = new int[height][width];
	//	int alpha, red, green, blue;
	//	int[] palette = new int[256];
	//	byte[][] paletteRGBA = new byte[4][256];
	//	palette[0] = 0; // transparent
	//	int paletteSize = 1; // le premier index est la couleur transparente
	//	int i;
	//	boolean found = false;
	//	if (hasAlphaChannel) {
	//		final int pixelLength = 4;
	//		for (int pixel = 0, row = 0, col = 0; pixel + 3 < pixels.length; pixel += pixelLength) {
	//			alpha = (((int) pixels[pixel] & 0xff) << 24); // alpha
	//			blue = ((int) pixels[pixel + 1] & 0xff); // blue
	//			green = (((int) pixels[pixel + 2] & 0xff) << 8); // green
	//			red = (((int) pixels[pixel + 3] & 0xff) << 16); // red
	//			
	//			if (alpha==0) {
	//				result[row][col] = 0;
	//			} else {
	//				found = false;
	//				for (i = 1; i < palette.length-1; i++) {
	//					if (palette[i] == alpha+blue+green+red) {
	//						found = true;
	//						break;
	//					}
	//				}
	//				if (!found) {
	//					palette[paletteSize] = alpha+blue+green+red;
	//					paletteRGBA[0][paletteSize] = pixels[pixel + 3];
	//					paletteRGBA[1][paletteSize] = pixels[pixel + 2];
	//					paletteRGBA[2][paletteSize] = pixels[pixel + 1];
	//					paletteRGBA[3][paletteSize] = pixels[pixel + 0];
	//					result[row][col] = paletteSize;
	//					paletteSize++;
	//				} else {
	//					result[row][col] = i;
	//				}
	//
	//				col++;
	//				if (col == width) {
	//					col = 0;
	//					row++;
	//				}
	//			}
	//		}
	//	}
	//	
	//	IndexColorModel newColorModel = new IndexColorModel(8,256,paletteRGBA[0],paletteRGBA[1],paletteRGBA[2],0);
	//	BufferedImage indexedImage = new BufferedImage(image.getWidth(), image.getHeight(), BufferedImage.TYPE_BYTE_INDEXED, newColorModel);
	//	
	//    for (int x = 0; x < indexedImage.getWidth(); x++) {
	//        for (int y = 0; y < indexedImage.getHeight(); y++) {
	//        	indexedImage.setRGB(x, y, image.getRGB(x, y));
	//        }
	//    }
	//
	//	image=indexedImage;
	//	colorModel = image.getColorModel();
	//	pixelSize = colorModel.getPixelSize();
	//}

}
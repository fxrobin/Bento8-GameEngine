package fr.bento8.to8.image;

import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.awt.image.ColorModel;
import java.awt.geom.AffineTransform;
import java.io.File;
import javax.imageio.ImageIO;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class SpriteSheet {
	// Convertion d'une planche de sprites en tableaux de données RAMA et RAMB pour chaque Sprite
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
	int[] x1_offset; // position haut gauche de l'image par rapport au centre
	int[] y1_offset; // position haut gauche de l'image par rapport au centre		
	int[] x_size; // largeur de l'image en pixel (sans les pixels transparents)		
	int[] y_size; // hauteur de l'image en pixel (sans les pixels transparents)		
	int center; // position du centre de l'image (dans le référentiel pixels)

	public SpriteSheet(String tag, String file, int nbImages, String variant) {
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

					// On inverse l'image verticalement (x mirror)		
					if (variant.contains("X")) {
						AffineTransform tx = AffineTransform.getScaleInstance(1, -1);
						tx.translate(0, -image.getHeight(null));
						AffineTransformOp op = new AffineTransformOp(tx, AffineTransformOp.TYPE_NEAREST_NEIGHBOR);
						image = op.filter(image, null);
					}

					// On inverse l'image horizontalement (y mirror)
					else if (variant.contains("Y")) {
						hFlipped = true;
						AffineTransform tx = AffineTransform.getScaleInstance(-1, 1);
						tx.translate(-image.getWidth(null), 0);
						AffineTransformOp op = new AffineTransformOp(tx, AffineTransformOp.TYPE_NEAREST_NEIGHBOR);
						image = op.filter(image, null);
					}

					// On inverse l'image horizontalement et verticalement		
					else if (variant.contains("XY")) {
						hFlipped = true;
						AffineTransform tx = AffineTransform.getScaleInstance(-1, -1);
						tx.translate(-image.getWidth(null), -image.getHeight(null));
						AffineTransformOp op = new AffineTransformOp(tx, AffineTransformOp.TYPE_NEAREST_NEIGHBOR);
						image = op.filter(image, null);
					}

					prepareImages(variant);

				} else {
					logger.info("Le format de fichier de " + file + " n'est pas supporté.");
					logger.info("Resolution: " + subImageWidth + "x" + height + "px (doit être inférieur ou égal à 160x200)");
					logger.info("Taille pixel:  " + pixelSize + "Bytes (doit être 8)");
					// System.out.println("Nombre de composants: "+numComponents+" (doit être 3)");
				}
			}
			else {
				logger.info("La largeur d'image :" + width + " n'est pas divisible par le nombre d'images :" +  nbImages);
			}

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e);
		}
	}

	public void prepareImages(String variant) {
		// sépare l'image en deux parties pour la RAM A et RAM B
		// ajoute les pixels transparents pour constituer une image linéaire de largeur 2x80px
		int paddedImage = 80*height;
		pixels = new byte[subImageNb][2][paddedImage];
		data = new byte[subImageNb][2][paddedImage];
		x1_offset = new int[subImageNb];
		y1_offset = new int[subImageNb];		
		x_size = new int[subImageNb];		
		y_size = new int[subImageNb];
		
		center = (int) ((Math.ceil(height/2.0)-1)*40) +  subImageWidth/8;
		
		for (int position = 0; position < subImageNb; position++) { // Parcours de toutes les sous-images
			int index = subImageWidth*position;		
			int indexDest = 0;
			int curLine = 0;
			int page = 0;		
			int x_Min = 160;
			int x_Max = -1;
			int y_Min = 200;
			int y_Max = -1;			
			boolean firstPixel = true;
			
			while (index<subImageWidth*(position+1) + width*(height-1)) { // Parcours de tous les pixels de l'image
				// Ecriture des pixels 2 à 2
				pixels[position][page][indexDest] = (byte) (((DataBufferByte) image.getRaster().getDataBuffer()).getElem(index));
				if (pixels[position][page][indexDest] == 0) {
					data[position][page][indexDest] = 0;
				} else {
					data[position][page][indexDest] = (byte) (pixels[position][page][indexDest]-1);
					
					// Calcul des offset et size de l'image
					if (firstPixel) {
						firstPixel = false;
						y1_offset[position] = curLine-((height-1)/2);
					}
					if (indexDest*2+page*2-(160*curLine) < x_Min) {
						x_Min = indexDest*2+page*2-(160*curLine);
						x1_offset[position] = x_Min-(width/2);
					}
					if (indexDest*2+page*2-(160*curLine) > x_Max) {
						x_Max = indexDest*2+page*2-(160*curLine);
					}
					if (curLine < y_Min) {
						y_Min = curLine;
					}
					if (curLine > y_Max) {
						y_Max = curLine;
					}
					x_size[position] = x_Max-x_Min;
					y_size[position] = y_Max-y_Min;
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
						
						// Calcul des offset et size de l'image
						if (firstPixel) {
							firstPixel = false;
							y1_offset[position] = curLine-((height-1)/2);				
						}
						if (indexDest*2+page*2+1-(160*curLine) < x_Min) {
							x_Min = indexDest*2+page*2+1-(160*curLine);
							x1_offset[position] = x_Min-(width/2);							
						}
						if (indexDest*2+page*2+1-(160*curLine) > x_Max) {
							x_Max = indexDest*2+page*2+1-(160*curLine);
						}
						if (curLine < y_Min) {
							y_Min = curLine;						
						}
						if (curLine > y_Max) {
							y_Max = curLine;
						}		
						x_size[position] = x_Max-x_Min;
						y_size[position] = y_Max-y_Min;	
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
			
			if (variant.contains("1")) {
				// Décallage de l'image de 1px à droite pour chaque ligne
				for (int y=0; y<height; y++) {
					for (int x = 79; x >= 1; x -= 2) {
	                    if (x == 79) {
	                    	// Le pixel en fin de ligne revient au début de cette ligne
	                    	pixels[position][0][0+(80*y)]=pixels[position][1][x+(80*y)];
	                    	data[position][0][0+(80*y)]=data[position][1][x+(80*y)];
	                    } else {
	                    	pixels[position][0][(x+1)+(80*y)]=pixels[position][1][x+(80*y)];
	                    	data[position][0][(x+1)+(80*y)]=data[position][1][x+(80*y)];
	                    }

                    	pixels[position][1][x+(80*y)]=pixels[position][1][(x-1)+(80*y)];
                    	data[position][1][x+(80*y)]=data[position][1][(x-1)+(80*y)];
					
                    	pixels[position][1][(x-1)+(80*y)]=pixels[position][0][x+(80*y)];
                    	data[position][1][(x-1)+(80*y)]=data[position][0][x+(80*y)];
					
                    	pixels[position][0][x+(80*y)]=pixels[position][0][(x-1)+(80*y)];
                    	data[position][0][x+(80*y)]=data[position][0][(x-1)+(80*y)];
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

	public byte[] getSubImageData(int subImagePos, int ramPage) {
		int position = subImagePos;

		// si l'image est inversée horizontalement, on inverse également l'index des sous-images
		if (hFlipped) {
			position = (subImageNb-1) - position;
		}

		return data[position][ramPage];
	}

	public int getSize() {
		return subImageNb;
	}

	public String getName() {
		return name;
	}

	public int getSubImageX1Offset(int subImagePos) {
		return x1_offset[subImagePos];
	}	
	
	public int getSubImageY1Offset(int subImagePos) {
		return y1_offset[subImagePos];
	}

	public int getSubImageXSize(int subImagePos) {
		return x_size[subImagePos];
	}

	public int getSubImageYSize(int subImagePos) {
		return y_size[subImagePos];
	}
	
	public int getCenter() {
		return center;
	}
}
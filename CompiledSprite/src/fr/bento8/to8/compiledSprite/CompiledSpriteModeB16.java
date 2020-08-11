package fr.bento8.to8.compiledSprite;

import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.awt.image.ColorModel;
import java.awt.Color;
import java.awt.geom.AffineTransform;
import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

import javax.imageio.ImageIO;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

public class CompiledSpriteModeB16 {
	// Convertisseur d'image PNG en "Compiled Sprite"
	// Thomson TO8/TO9+
	// Mode 160x200 en seize couleurs sans contraintes

	// Image
	BufferedImage image;
	ColorModel colorModel;
	String spriteName;
	public String eraseAddress;
	int width;
	int height;
	byte[] pixels;

	// Calcul
	ArrayList<ArrayList<ArrayList<Integer>>> regCombos = new ArrayList<ArrayList<ArrayList<Integer>>>();
	final String[] pulReg = { "Y", "X", "DP", "B", "A", "D" };
	final int[] regSize = { 2, 2, 1, 1, 1, 2 };
	
	// Cycles
	final int[] regCostPULPSHx = { 2, 2, 1, 1, 1, 2 };
	final int[] regCostLDx = { 4, 3, 99, 2, 2, 3 }; // il n'y a pas de LDx pour DP
	final int[] regCostSTx = { 7, 6, 99, 5, 5, 6 }; // il n'y a pas de LDx pour DP
	
	// Taille mémoire
	final int[] regInstSizeLDx = { 2, 1, 99, 1, 1, 1 }; // il n'y a pas de LDx pour DP
	
	private int leas = 0;
	private int leasSelfMod = 0;
	private int stOffset = 0; // Offset pour les STx depuis le dernier LEAS

	// Code
	List<String> spriteCode1 = new ArrayList<String>();
	List<String> spriteCode2 = new ArrayList<String>();
	List<String> spriteData1 = new ArrayList<String>();
	List<String> spriteData2 = new ArrayList<String>();
	List<String> spriteECode1 = new ArrayList<String>();
	List<String> spriteECode2 = new ArrayList<String>();
	List<String> spriteEData1 = new ArrayList<String>();
	List<String> spriteEData2 = new ArrayList<String>();
	
	String drawLabel, eraseLabel, dataLabel, erasePosLabel, eraseCodeLabel, ssaveLabel;
	String erasePrefix;
	String posAdress;
	
	int cyclesCode = 0;
	int octetsCode = 0;
	int cyclesCodeSelfMod = 0;
	int octetsCodeSelfMod = 0;
	int cyclesWCode1 = 0;
	int octetsWCode1 = 0;
	int cyclesWCode2 = 0;
	int octetsWCode2 = 0;
	int cyclesECode1 = 0;
	int octetsECode1 = 0;
	int cyclesECode2 = 0;
	int octetsECode2 = 0;
	boolean isSelfModifying = false;
	boolean isDeleteCode = false;
	int codePart = 0; // Partie de code (1 ou 2)

	public CompiledSpriteModeB16(String file, String locspriteName, int nbImages, int numImage, int flip) {
		try {
			// Construction des combinaisons des 5 registres pour le PSH
			ComputeRegCombos();

			// Lecture de l'image a traiter
			image = ImageIO.read(new File(file));
			width = image.getWidth();
			height = image.getHeight();
			colorModel = image.getColorModel();
			int pixelSize = colorModel.getPixelSize();
			// int numComponents = colorModel.getNumComponents();
			spriteName = locspriteName.toUpperCase().replaceAll("[^A-Za-z0-9]", "");
			
			// Initialisation du code statique
			posAdress   = "9F00";
			
			// Etiquettes Code d'éctiture et Code d'effacement
			drawLabel   = "DRAW_" + spriteName;
			dataLabel   = "DATA_" + spriteName;
			ssaveLabel  = "SSAV_" + spriteName;
			
			// Etiquettes spécifiques Code d'effacement
			erasePrefix    = "ERASE_";
			eraseLabel     = erasePrefix + spriteName;
			erasePosLabel  = erasePrefix + "POS_"  + spriteName;
			eraseCodeLabel = erasePrefix + "CODE_"  + spriteName;
			
			// On inverse l'image horizontalement si le flag flip est positionné à 1
			if (flip==1) {
			    AffineTransform tx = AffineTransform.getScaleInstance(-1, 1);
			    tx.translate(-image.getWidth(null), 0);
			    AffineTransformOp op = new AffineTransformOp(tx,AffineTransformOp.TYPE_NEAREST_NEIGHBOR);
			    image = op.filter(image, null);
			    numImage = (nbImages-1) - numImage;
			}
			
//			if (pixelSize == 32) {
//				final byte[] pixels = ((DataBufferByte) image.getRaster().getDataBuffer()).getData();
//				final int width = image.getWidth();
//				final int height = image.getHeight();
//				final boolean hasAlphaChannel = image.getAlphaRaster() != null;
//
//				int[][] result = new int[height][width];
//				int alpha, red, green, blue;
//				int[] palette = new int[256];
//				byte[][] paletteRGBA = new byte[4][256];
//				palette[0] = 0; // transparent
//				int paletteSize = 1; // le premier index est la couleur transparente
//				int i;
//				boolean found = false;
//				if (hasAlphaChannel) {
//					final int pixelLength = 4;
//					for (int pixel = 0, row = 0, col = 0; pixel + 3 < pixels.length; pixel += pixelLength) {
//						alpha = (((int) pixels[pixel] & 0xff) << 24); // alpha
//						blue = ((int) pixels[pixel + 1] & 0xff); // blue
//						green = (((int) pixels[pixel + 2] & 0xff) << 8); // green
//						red = (((int) pixels[pixel + 3] & 0xff) << 16); // red
//						
//						if (alpha==0) {
//							result[row][col] = 0;
//						} else {
//							found = false;
//							for (i = 1; i < palette.length-1; i++) {
//								if (palette[i] == alpha+blue+green+red) {
//									found = true;
//									break;
//								}
//							}
//							if (!found) {
//								palette[paletteSize] = alpha+blue+green+red;
//								paletteRGBA[0][paletteSize] = pixels[pixel + 3];
//								paletteRGBA[1][paletteSize] = pixels[pixel + 2];
//								paletteRGBA[2][paletteSize] = pixels[pixel + 1];
//								paletteRGBA[3][paletteSize] = pixels[pixel + 0];
//								result[row][col] = paletteSize;
//								paletteSize++;
//							} else {
//								result[row][col] = i;
//							}
//
//							col++;
//							if (col == width) {
//								col = 0;
//								row++;
//							}
//						}
//					}
//				}
//				
//				IndexColorModel newColorModel = new IndexColorModel(8,256,paletteRGBA[0],paletteRGBA[1],paletteRGBA[2],0);
//				BufferedImage indexedImage = new BufferedImage(image.getWidth(), image.getHeight(), BufferedImage.TYPE_BYTE_INDEXED, newColorModel);
//				
//	            for (int x = 0; x < indexedImage.getWidth(); x++) {
//	                for (int y = 0; y < indexedImage.getHeight(); y++) {
//	                	indexedImage.setRGB(x, y, image.getRGB(x, y));
//	                }
//	            }
//
//				image=indexedImage;
//				colorModel = image.getColorModel();
//				pixelSize = colorModel.getPixelSize();
//			}
			
			System.out.println(getCodePalette(colorModel, 2));
			
			if (width % nbImages == 0) { // Est-ce que la division de la largeur par le nombre d'images donne un entier ?

				int iWidth = width/nbImages; // Largeur de la sous-image

				if (iWidth <= 160 && height <= 200 && pixelSize == 8) { // Contrôle du format d'image
					
					int offsetStart = 1;
					int offsetEnd = 0;
					if (iWidth % 2 != 0) { // Si la largeur d'image est impaire, on ajoute une colonne de pixel transparent a gauche de l'image
						offsetStart = 0;
						offsetEnd = 1;
					}
					
					pixels = new byte[(iWidth + offsetEnd) * height];
					for (int iSource = iWidth*numImage, iDest = 0, iCol = offsetStart; iDest < (iWidth + offsetEnd) * height; iDest++) {
						if (iCol == 0) {
							pixels[iDest] = 16;
						} else {
							if ((byte) ((DataBufferByte) image.getRaster().getDataBuffer()).getElem(iSource) == 0) {
								pixels[iDest] = (byte) 16;
							} else {
								pixels[iDest] = (byte) (((DataBufferByte) image.getRaster().getDataBuffer()).getElem(iSource)-1);
							}
							iSource++;
						}
						iCol++;
						if (iCol == iWidth + 1) {
							iCol = offsetStart;
							iSource += width - iWidth;
						}
					}
					iWidth = iWidth + offsetEnd;

					// Génération du code Assembleur
					width = iWidth;
					generateCode();
					
				} else {
					System.out.println("Le format de fichier de " + file + " n'est pas supporté.");
					System.out.println("Resolution: " + iWidth + "x" + height + "px (doit Ãªtre inférieur ou égal Ã  160x200)");
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

	public void generateCode() {
		// Génération du code source pour l'effacement des images
		isSelfModifying = false;
		isDeleteCode = true;
		generateCodeArray(1, spriteECode1, spriteEData1);
		cyclesECode2 = cyclesCode;
		octetsECode2 = octetsCode;
		
		generateCodeArray(3, spriteECode2, spriteEData2);
		cyclesECode1 = cyclesCode;
		octetsECode1 = octetsCode;

		// Génération du code source pour l'écriture des images
		isSelfModifying = true;
		isDeleteCode = false;
		generateCodeArray(1, spriteCode1, spriteData1);
		cyclesWCode2 = cyclesCode+cyclesCodeSelfMod;
		octetsWCode2 = octetsCode+octetsCodeSelfMod;
		
		generateCodeArray(3, spriteCode2, spriteData2);
		cyclesWCode1 = cyclesCode+cyclesCodeSelfMod;
		octetsWCode1 = octetsCode+octetsCodeSelfMod;
		
		System.out.println("W Cycles 1:  " + cyclesWCode1);
		System.out.println("W Cycles 2:  " + cyclesWCode2);
		System.out.println("E Cycles 1:  " + cyclesECode1);
		System.out.println("E Cycles 2:  " + cyclesECode2);
//		
		System.out.println("W Octets 1:  " + octetsWCode1);
		System.out.println("W Octets 2:  " + octetsWCode2);
		System.out.println("E Octets 1:  " + octetsECode1);
		System.out.println("E Octets 2:  " + octetsECode2);
		return;
	}

	public void generateCodeArray(int pos, List<String> spriteCode, List<String> spriteData) {
		int col = width;
		int row = height;
		int chunk = 1;
		int doubleFwd = 0;
		boolean leftAlphaPxl = false;
		boolean rightAlphaPxl = false;

		
		// Initialisation des variables globales
		leas = 0;
		leasSelfMod = 0;
		stOffset = 0;
		cyclesCode = 0;
		octetsCode = 0;
		cyclesCodeSelfMod = 0;
		octetsCodeSelfMod = 0;
		codePart = (pos==1 ? 2 : 1);

		ArrayList<String> fdbBytes = new ArrayList<String>();
		String fdbBytesResult = new String();
		String fdbBytesResultLigne = new String();
		String[] pulBytesOld = { "", "", "", "", "" };
		ArrayList<Integer> motif = new ArrayList<Integer>();

		// **************************************************************
		// Lecture des pixels par paire pos=1 -> ..XX pos=3 -> XX..
		// Index de couleur par pixel :
		// 0-15 couleur utile
		// 16-255 considéré comme couleur transparente
		// **************************************************************
		
		for (int pixel = (width * height) - 1; pixel >= 0; pixel = ((row - 1) * width) + col - 1) {

			// Initialisation en début de paire
			if (chunk == pos) {
				rightAlphaPxl = false;
				leftAlphaPxl = false;
			}

			// Lecture des pixels une paire sur deux, la paire lue dépend du paramètre
			// d'entrée pos
			if (chunk == pos || chunk == pos + 1) {

				// On ignore les paires de pixel transparents
				if (pixel > 0 && ((chunk == pos) && ((int) pixels[pixel] < 0 || (int) pixels[pixel] > 15)
						&& ((int) pixels[pixel - 1] < 0 || (int) pixels[pixel - 1] > 15))) {

					// Gestion du LEAS de début si on commence par du transparent
					if (pixel > (width * height) - 4) {
						// **************************************************************
						// Gestion des sauts de ligne
						// **************************************************************
						computeLEAS(pixel + 3, col + 3, pos, spriteCode);
						writeLEAS(pixel, spriteCode);
					}
					doubleFwd = 1;
				} else {
					doubleFwd = 0;

					// Construction d'une liste de pixels et transformation des pixels transparents
					// en 0
					if ((int) pixels[pixel] >= 0 && (int) pixels[pixel] <= 15) {
						fdbBytes.add(Integer.toHexString((int) pixels[pixel])); // pixel plein
					} else {
						fdbBytes.add("0"); // pixel transparent

						// Détection de la position du pixel transparent
						if (chunk == pos + 1) {
							leftAlphaPxl = true;
						} else {
							rightAlphaPxl = true;
						}
					}

					// **************************************************************************
					// Gestion du pixel transparent à gauche ou à droite dans une paire de pixels
					// **************************************************************************

					if (chunk == pos + 1 && (leftAlphaPxl == true || rightAlphaPxl == true)) {
						
						if (isSelfModifying) {
							if (stOffset == 0) {
								spriteCode.add("\tLDA ,S");
							} else {
								spriteCode.add("\tLDA " + stOffset + ",S");
							}
							computeStatsSelfMod8b(stOffset);
							
							//spriteCode.add("\tSTA " + eraseCodeLabel + "_" + codePart + "+" + (octetsCode+2+((stOffset > -129) ? ((stOffset > -17) ? 2 : 3) : 4)+1)); // +2 pour LDA, +2 ou +3 ou +4 pour ANDA, +1 pour ADDA (instruction seule)
							spriteCode.add("\tSTA " + eraseCodeLabel + "_" + codePart + "+" + (octetsCode+1));
							octetsCode -= 2+((stOffset > -129) ? ((stOffset > -17) ? 2 : 3) : 4);
							cyclesCodeSelfMod += 5;
							octetsCodeSelfMod += 3;
							
							// bug a HIL0_1 + 403 decalage de 1
						}
						
						if (!isDeleteCode) {
							if (leftAlphaPxl == true) {
								spriteCode.add("\tLDA  #$F0");
							} else {
								spriteCode.add("\tLDA  #$0F");
							}
							computeStats8b();

							if (stOffset == 0) {
								spriteCode.add("\tANDA ,S");
							} else {
								spriteCode.add("\tANDA " + stOffset + ",S");
							}
							computeStats8b(stOffset);

							spriteCode.add("\tADDA #$" + fdbBytes.get(fdbBytes.size() - 1) + fdbBytes.get(fdbBytes.size() - 2));
							computeStats8b();
						} else {
							// si on ecrit du code compilé pour réappliquer le fond
							// on ne gère pas les pixels transparent à gauche ou droite
							// pour des raisons d'optimisation on réapplique le bloc de deux pixels d'un coup
							spriteCode.add("\tLDA #$" + fdbBytes.get(fdbBytes.size() - 1) + fdbBytes.get(fdbBytes.size() - 2));
							computeStats8b();
						}
						
						if (stOffset == 0) {
							spriteCode.add("\tSTA ,S");
						} else {
							spriteCode.add("\tSTA " + stOffset + ",S");
						}
						computeStats8b(stOffset);

						pulBytesOld[4] = "zz"; // invalide l'historique du registre car transparence
						fdbBytes.clear();

						computeLEAS(pixel, col, pos, spriteCode);
					}

					// **************************************************************
					// Gestion d'une paire de pixels pleins
					// **************************************************************

					if (chunk == pos + 1 && fdbBytes.size() > 0 && (fdbBytes.size() == 12 || // 12px max par PSH
							(pixel <= 2) || // ou fin de l'image
							(col <= 3 && width < 160) || // ou fin de ligne avec image qui n'est pas plein ecran
							(pixel >= 4 && (((int) pixels[pixel - 3] < 0 || (int) pixels[pixel - 3] > 15)
									|| ((int) pixels[pixel - 4] < 0 || (int) pixels[pixel - 4] > 15))))) {

						motif = optimisationPUL(fdbBytes, pulBytesOld);
						String[][] result = generateCodePULPSH(fdbBytes, pulBytesOld, motif, pos);
						if (fdbBytes.size() / 2 > 2) { // Ecriture du LEAS avant utilisation du PSHS
							writeLEAS(pixel, spriteCode);
						}
						if (!result[0][0].equals("")) {   // In case registers are already sets PUL or LD are skipped
							spriteCode.add(result[0][0]); // PUL or LD code
						}
						spriteCode.add(result[1][0]); // PSH
						fdbBytesResultLigne += result[2][0];
						pulBytesOld = result[3];
						fdbBytes.clear();

						computeLEAS(pixel, col, pos, spriteCode);
					}
				}

				// **************************************************************
				// Copie des données en fin de ligne
				// **************************************************************
				if ((col - 3 <= 0 && width < 160) || (width == 160)) {
					if (pixel >= 0) {
						fdbBytesResult += fdbBytesResultLigne;
						fdbBytesResultLigne = "";
					}
				}
			}

			// **************************************************************
			// Gestion des lignes et colonnes
			// **************************************************************

			for (int avance = 0; avance <= doubleFwd; avance++) {
				col--;
				if (col == 0) {
					col = width;
					row--;
					chunk = 0;
				}
				if (chunk == 4) {
					chunk = 1;
				} else {
					chunk++;
				}
			}
		}

		// **************************************************************
		// Copie des données en fin de ligne
		// **************************************************************
		if (!fdbBytesResultLigne.equals("")) {
			fdbBytesResult += fdbBytesResultLigne;
			fdbBytesResultLigne = "";
		}

		generateDataFDB(fdbBytesResult, spriteData); // Construction du code des données
	}

	public void computeStats8b(int offset) {
		if (offset > -129) {
			if (offset == 0) {
				cyclesCode += 4;
			} else {
				cyclesCode += 5;
			}
			if (offset > -17) {
				octetsCode += 2;
			} else {
				octetsCode += 3;
			}
		} else {
			cyclesCode += 8;
			octetsCode += 4;
		}
	}
	
	public void computeStatsSelfMod8b(int offset) {
		if (offset > -129) {
			if (offset == 0) {
				cyclesCodeSelfMod += 4;
			} else {
				cyclesCodeSelfMod += 5;
			}
			if (offset > -17) {
				octetsCodeSelfMod += 2;
			} else {
				octetsCodeSelfMod += 3;
			}
		} else {
			cyclesCodeSelfMod += 8;
			octetsCodeSelfMod += 4;
		}
	}
	
	public void computeStats8b() {
			cyclesCode += 2;
			octetsCode += 2;
	}

	public void computeStats16b(int offset) {
		if (offset > -129) {
			if (offset == 0) {
				cyclesCode += 5;
			} else {
				cyclesCode += 6;
			}
			if (offset > -17) {
				octetsCode += 2;
			} else {
				octetsCode += 3;
			}
		} else {
			cyclesCode += 9;
			octetsCode += 4;
		}
	}
	
	public void computeStatsSelfMod16b(int offset) {
		if (offset > -129) {
			if (offset == 0) {
				cyclesCodeSelfMod += 5;
			} else {
				cyclesCodeSelfMod += 6;
			}
			if (offset > -17) {
				octetsCodeSelfMod += 2;
			} else {
				octetsCodeSelfMod += 3;
			}
		} else {
			cyclesCodeSelfMod += 9;
			octetsCodeSelfMod += 4;
		}
	}
	
	public void computeLEAS(int pixel, int col, int pos, List<String> spriteCode) {
		int fpixel = pixel; // intialisation des variables de travail
		int fcol = col;
		int offset = 0;

		// Initialisation variable globale
		leas = 0;
		leasSelfMod = 0;

		// en fonction du nombre de A ou B par image le retour à la ligne n'est pas le
		// même
		if (((width / 2) == (width / 4) * 2) || pos == 3) {
			offset = 0;
		} else {
			offset = 1;
		}

		// On regarde ce qui suit ...
		// *** CAS: Saut de ligne ***
		if (fcol <= 3) {
			fcol = width - pos;
			leas += -40 + (width / 4) + offset; // Remarque : dans le cas d'une image plein ecran leas=0
			if (((width / 2) == (width / 4) * 2)) {
				fpixel -= 4;
			} else if (pos == 1) {
				fpixel -= 2;
			} else if (pos == 3) {
				fpixel -= 6;
			}
		} else {
			fcol -= 4;
			fpixel -= 4;
		}

		// *** CAS : Pixels transparents par paires ***
		while (fpixel > 0 && ((int) pixels[fpixel] < 0 || (int) pixels[fpixel] > 15)
				&& ((int) pixels[fpixel + 1] < 0 || (int) pixels[fpixel + 1] > 15)) {
			fcol -= 4;
			leas--;
			if (fcol <= -1) {
				fcol = width - pos;
				leas += -40 + (width / 4) + offset;
				if (((width / 2) == (width / 4) * 2)) {
					fpixel -= 4;
				} else if (pos == 1) {
					fpixel -= 2;
				} else if (pos == 3) {
					fpixel -= 6;
				}
			} else {
				fpixel -= 4;
			}
		}

		// S'il y a un pixel transparent (gauche ou droite) on avance de 1 et stop
		if ((fpixel > 0) && ((((int) pixels[fpixel] >= 0 && (int) pixels[fpixel] <= 15)
				&& ((int) pixels[fpixel + 1] < 0 || (int) pixels[fpixel + 1] > 15))
				|| (((int) pixels[fpixel] < 0 || (int) pixels[fpixel] > 15)
						&& ((int) pixels[fpixel + 1] >= 0 && (int) pixels[fpixel + 1] <= 15)))) {
			leas--;
		}
		stOffset += leas;
		leas = stOffset;

		if (stOffset < -128) {
			writeLEAS(fpixel, spriteCode);
		}
	}

	public void writeLEAS(int pixel, List<String> spriteCode) {
		if (leas+leasSelfMod < 0) {
			spriteCode.add("\tLEAS " + (leas+leasSelfMod) + ",S");

			// Séparation du comptage entre mode normal ou Self Modification
			// car le LEAS est commun
			int c_cyclesCode = 0;
			int t_cyclesCode = 0;
			int c_octetsCode = 0;
			int t_octetsCode = 0;
			
			if (leas <0) {
				if (leas > -129) {
					c_cyclesCode += 5;
					if (leas > -17) {
						c_octetsCode += 2;
					} else {
						c_octetsCode += 3;
					}
				} else {
					c_cyclesCode += 8;
					c_octetsCode += 4;
				}
			}
			
			if (leas+leasSelfMod > -129) {
				t_cyclesCode += 5;
				if (leas+leasSelfMod > -17) {
					t_octetsCode += 2;
				} else {
					t_octetsCode += 3;
				}
			} else {
				t_cyclesCode += 8;
				t_octetsCode += 4;
			}	
			
			cyclesCode += c_cyclesCode;
			octetsCode += c_octetsCode;
			cyclesCodeSelfMod += t_cyclesCode - c_cyclesCode;
			octetsCodeSelfMod += t_octetsCode - c_octetsCode;

			stOffset = 0;
			leas = 0;
			leasSelfMod = 0;
		}
	}

	public ArrayList<Integer> optimisationPUL(ArrayList<String> fdbBytes, String[] pulBytesOld) {
		int somme = 0;
		int minSomme = 99;
		ArrayList<Integer> listeRegistres = new ArrayList<Integer>();
		ArrayList<Integer> minlr = new ArrayList<Integer>();
		int ilst = 0;
		String[] pulBytes = new String[5];
		int nbBytes = fdbBytes.size() / 2;

		// **************************************************************
		// Test de toutes les combinaisons de registres pour savoir
		// laquelle necessite le moins de registres a recharger pour
		// construire le PUL
		// **************************************************************

		for (ArrayList<Integer> lcr : regCombos.get(nbBytes)) {
			for (Integer cr : lcr) {
				pulBytes[cr] = "";
				if (cr == 0 || cr == 1) {
					pulBytes[cr] += fdbBytes.get(ilst + 3);
					pulBytes[cr] += fdbBytes.get(ilst + 2);
					pulBytes[cr] += fdbBytes.get(ilst + 1);
					pulBytes[cr] += fdbBytes.get(ilst);
					ilst += 4;
				} else {
					pulBytes[cr] += fdbBytes.get(ilst + 1);
					pulBytes[cr] += fdbBytes.get(ilst);
					ilst += 2;
				}

				if (!pulBytes[cr].equals(pulBytesOld[cr])) {
					if (nbBytes == 7) {
						somme += regCostPULPSHx[cr];
					}
					if (nbBytes >= 3 && nbBytes <= 6) {
						somme += regCostLDx[cr];
					}
					if (nbBytes <= 2) {
						somme += regCostLDx[cr];
					}
				}

				if (nbBytes <= 2) {
					somme += regCostSTx[cr];
				}

				listeRegistres.add(cr);
			}

			if (somme < minSomme) {
				minlr = new ArrayList<>(listeRegistres);
				minSomme = somme;
			}

			somme = 0;
			listeRegistres.clear();
			ilst = 0;
			pulBytes = new String[5];
		}

		return minlr;
	}

	public String[][] generateCodePULPSH(ArrayList<String> fdbBytes, String[] pulBytesOld,
			ArrayList<Integer> listeIndexReg, int pos) {
		String read = new String("");
		String erase_read = new String("");
		String write = new String("");
		String erase_write = new String("");
		String[] pulBytes = { "", "", "", "", "" };
		String[] pulBytesFiltered = { "", "", "", "", "" };
		String fdbBytesResult = new String("");
		String[][] result = new String[4][];
		int ilst = 0;
		int nbBytes = fdbBytes.size() / 2;

		// **************************************************************
		// Construction du PUL/LD et du PSH/ST
		// **************************************************************
		if (nbBytes >= 3 && nbBytes <= 7) {
			for (int i = 0; i < listeIndexReg.size(); i++) {
				if (listeIndexReg.get(i) < 2) {
					pulBytes[listeIndexReg.get(i)] += fdbBytes.get(ilst + 3);
					pulBytes[listeIndexReg.get(i)] += fdbBytes.get(ilst + 2);
					pulBytes[listeIndexReg.get(i)] += fdbBytes.get(ilst + 1);
					pulBytes[listeIndexReg.get(i)] += fdbBytes.get(ilst);
					ilst += 4;
				} else {
					pulBytes[listeIndexReg.get(i)] += fdbBytes.get(ilst + 1);
					pulBytes[listeIndexReg.get(i)] += fdbBytes.get(ilst);
					ilst += 2;
				}
			}
		}
		if (nbBytes <= 2) {
			for (int i = listeIndexReg.size() - 1; i >= 0; i--) {
				if (listeIndexReg.get(i) < 2) {
					pulBytes[listeIndexReg.get(i)] += fdbBytes.get(ilst + 3);
					pulBytes[listeIndexReg.get(i)] += fdbBytes.get(ilst + 2);
					pulBytes[listeIndexReg.get(i)] += fdbBytes.get(ilst + 1);
					pulBytes[listeIndexReg.get(i)] += fdbBytes.get(ilst);
					ilst += 4;
				} else {
					pulBytes[listeIndexReg.get(i)] += fdbBytes.get(ilst + 1);
					pulBytes[listeIndexReg.get(i)] += fdbBytes.get(ilst);
					ilst += 2;
				}
			}
		}

		// Case 1/3 : 7 bytes to write
		// ***************************
		
//		if (nbBytes == 7) {
//			read += "\tPULU A,B,DP,X,Y\n";
//			cyclesCode += 12;
//			octetsCode += 2;
//			erase_read += "";
//			write += "\tPSHS Y,X,DP,B,A\n";
//			cyclesCode += 12;
//			octetsCode += 2;
//			erase_write += "";
//		}
		
		// Case 2/3 : 3 to 6 bytes to write
		// ********************************
		
		if (nbBytes >= 3 && nbBytes <= 6 && isSelfModifying) // Construction du code auto-modifié pour l'effacement
		{
			int offset = octetsCode+((leas < 0) ? ((leas > -129) ? ((leas > -17) ? 2 : 3) : 4) : 0);  // On ajoute le LEAS
			for (int i = listeIndexReg.size() - 1; i >= 0 ; i--) {
				// Lecture des registres en sens inverse pour construction du PULS
				if (erase_read.equals("")) {
					erase_read += "\tPULS ";
					cyclesCodeSelfMod += 5;
					octetsCodeSelfMod += 2;
				} else {
					erase_read += ",";
				}
				erase_read += pulReg[listeIndexReg.get(i)];

				leasSelfMod -= regSize[listeIndexReg.get(i)]; // modification du positionnement avant le PULS
				cyclesCodeSelfMod += regCostPULPSHx[listeIndexReg.get(i)];
				
				// Lecture des registres en sens inverse pour construction des ST
				offset += regInstSizeLDx[listeIndexReg.get(i)];
				erase_write += "\tST" + pulReg[listeIndexReg.get(i)] + " " + eraseCodeLabel + "_" + codePart + "+" + offset + "\n";
				offset += regSize[listeIndexReg.get(i)];
				
				// Mise à jour stats (A faire : gestion des cyles en fonction du mode d'adressage)
				cyclesCodeSelfMod += regCostSTx[listeIndexReg.get(i)];
				octetsCodeSelfMod += regInstSizeLDx[listeIndexReg.get(i)];
			}
			erase_read += "\n";
		}
		
		for (Integer indexReg : listeIndexReg) {
			if (nbBytes >= 3 && nbBytes <= 6) {
				//if (!pulBytes[indexReg].equals(pulBytesOld[indexReg])) {
				if (!read.equals("")) {
					read = "\n" + read;
				}
				read = "\tLD" + pulReg[indexReg] + " #$" + pulBytes[indexReg] + read;
				pulBytesOld[indexReg] = pulBytes[indexReg];

				cyclesCode += regCostLDx[indexReg];
				octetsCode += regInstSizeLDx[indexReg] + regSize[indexReg];
				//}

				if (write.equals("")) {
					write += "\tPSHS ";
					cyclesCode += 5;
					octetsCode += 2;
				} else {
					write += ",";
				}
				write += pulReg[indexReg];
				
				cyclesCode += regCostPULPSHx[indexReg];
			}
			
			// Case 3/3 : 1 to 2 bytes to write
			// ********************************
			if (nbBytes <= 2) {
				
				// Dans le cas ou on n'utilise pas de PSHS pour ecrire il faut faire avancer S
				if (indexReg < 2) {
					stOffset -= 2;
					leas -= 2;
				} else {
					stOffset -= 1;
					leas -= 1;
				}
		
				if (isSelfModifying) {
					if (stOffset == 0) {
						read += "\tLD" + pulReg[indexReg] + " ,S\n";
					} else {
						read += "\tLD" + pulReg[indexReg] + " " + stOffset + ",S\n";
					}
					
					// LD Offset
					if (indexReg < 2) {
						computeStatsSelfMod16b(stOffset);
					} else {
						computeStatsSelfMod8b(stOffset);
					}
					
					read += "\tST" + pulReg[indexReg] + " " + eraseCodeLabel + "_" + codePart + "+" + (octetsCode+1); // +1 pour l'octet du LD
					
					//ST Offset
					cyclesCodeSelfMod += regCostSTx[indexReg];
					octetsCodeSelfMod += 3;
				}		
				
				//if (!pulBytes[indexReg].equals(pulBytesOld[indexReg])) {
				if (!read.equals("")) {
					read += "\n";
				}
				read += "\tLD" + pulReg[indexReg] + " #$" + pulBytes[indexReg];
				pulBytesOld[indexReg] = pulBytes[indexReg];

				cyclesCode += regCostLDx[indexReg];
				octetsCode += regInstSizeLDx[indexReg] + regSize[indexReg];
				//}
				
				if (!write.equals("")) {
					write += "\n";
				}
				write += "\tST" + pulReg[indexReg] + " " + stOffset + ",S";
				if (indexReg < 2) {
					computeStats16b(stOffset);
				} else {
					computeStats8b(stOffset);
				}
			}
		}

		// Enregistre les données FDB en sens inverse et filtrées
		for (int i = listeIndexReg.size() - 1; i >= 0; i--) {
			fdbBytesResult += pulBytesFiltered[listeIndexReg.get(i)];
		}

		result[0] = new String[] { erase_read + erase_write + read };
		result[1] = new String[] { write };
		result[2] = new String[] { fdbBytesResult };
		result[3] = pulBytesOld;
		return result;
	}

	public void ComputeRegCombos() {
		ArrayList<Integer> registresCourant = new ArrayList<Integer>();
		regCombos.clear();

		// **************************************************************
		// Construit un tableau dont l'indice est un nombre d'octet
		// de 0 à 7. Chaque indice contient les listes de toutes les
		// combinaisons des registres dont la taille totale correspond
		// au nombre d'octets défini dans l'indice.
		// **************************************************************

		for (int i = 0; i < 8; i++) {
			regCombos.add(new ArrayList<ArrayList<Integer>>());
		}

		// génération des combinaisons binaires pour 5 bits
		for (int nbe = 0, nbBytes = 0, x = 0; nbe < 32; nbe++) {
			nbBytes = 0;
			for (int i = 4, j = 0; i >= 0; i--) {
				x = ((nbe & (1 << i)) != 0) ? 1 : 0;
				;
				if (x == 1) {
					registresCourant.add(j);
					nbBytes += regSize[j];
				}
				j++;
			}
			regCombos.get(nbBytes).add(registresCourant);
			registresCourant = new ArrayList<Integer>();
		}

		return;
	}

	public void generateDataFDB(String pixels, List<String> spriteData) {
		int bitIndex = 0;
		int bitIndexEnd = 4;
		String dataLine = new String();

		// **************************************************************
		// Construit un tableau de données en assembleur
		// **************************************************************

		spriteData.add("");

		for (int i = 0; i < pixels.length(); i++) {
			bitIndex++;
			if (bitIndex == 1 && i < pixels.length() - 2) {
				dataLine = "\tFDB $";
			} else if (bitIndex == 1) {
				dataLine = "\tFCB $";
				bitIndexEnd = 2;				
			}

			dataLine += pixels.charAt(i);

			if (bitIndex == bitIndexEnd) {
				spriteData.add(dataLine);
				bitIndex = 0;
			}
		}

		// On complete le FCB ou FDB pour la dernière ligne de données
		if (dataLine.length() == 7 || dataLine.length() == 9) {
			dataLine += "0";
			spriteData.add(dataLine);
		}
	}

	public String removeExtension(String s) {

		String separator = System.getProperty("file.separator");
		String filename;

		// Remove the path upto the filename.
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

	public List<String> getCompiledCode(int i) {
		return (i == 1) ? spriteCode2 : spriteCode1;
	}

	public List<String> getCompiledData(int i) {
		return getCompiledData("", i);
	}	
	
	public List<String> getCompiledData(String prefix, int i) {
		if (i == 1) {
			spriteData2.set(0, prefix + dataLabel + "_2");
		} else {
			spriteData1.set(0, prefix + dataLabel + "_1");
		}
		return (i == 1) ? spriteData2 : spriteData1;
	}


	public List<String> getCompiledECode(int i) {
		return (i == 1) ? spriteECode2 : spriteECode1;
	}

	public List<String> getCompiledEData(int i) {
		return getCompiledEData("", i);
	}	
	
	public List<String> getCompiledEData(String prefix, int i) {
		if (i == 1) {
			spriteEData2.set(0, prefix + dataLabel + "_2");
		} else {
			spriteEData1.set(0, prefix + dataLabel + "_1");
		}
		return (i == 1) ? spriteEData2 : spriteEData1;
	}

	public List<String> getCodeHeader(String label, int pos) {
		return getCodeHeader("", label, pos);
	}	
	
	public List<String> getCodeHeader(String prefix, String label, int pos) {
		List<String> code = new ArrayList<String>();
		code.add(label);
		code.add("\tPSHS U,DP");
		code.add("\tSTS " + prefix + ssaveLabel + "+2");
		code.add("");
		if (prefix.contentEquals(""))
		{
			code.add("\tLDS $" + posAdress);
			code.add("\tSTS " + erasePosLabel + "_" + pos + "+2"); // auto-modification du code
		}
		else {
			code.add(erasePosLabel + "_" + pos); // label pour auto-modification du code
			code.add("\tLDS #$0000");
		}
		code.add("\tLDU #" + prefix + dataLabel + "_" + pos);
		
		if (prefix.contentEquals(""))
		{
			code.add("");
		}
		else {
			code.add(eraseCodeLabel + "_" + pos);
		}
		
		return code;
	}
	
	public List<String> getCodeSwitchData(int pos) {
		return getCodeSwitchData("", pos);
	}

	public List<String> getCodeSwitchData(String prefix, int pos) {
		List<String> code = new ArrayList<String>();
		code.add("");
		if (prefix.contentEquals(""))
		{
			code.add("\tLDS $" + posAdress + "+2");
			code.add("\tSTS " + erasePosLabel + "_" + pos + "+2"); // auto-modification du code
		}
		else {
			code.add(erasePosLabel + "_" + pos); // label pour auto-modification du code
			code.add("\tLDS #$0000");
		}
		
		code.add("\tLDU #" + prefix + dataLabel + "_" + pos);

		if (prefix.contentEquals(""))
		{
			code.add("");
		}
		else {
			code.add(eraseCodeLabel + "_" + pos);
		}
		return code;
	}
	
	public List<String> getCodeFooter() {
		return getCodeFooter("");
	}

	public List<String> getCodeFooter(String prefix) {
		List<String> code = new ArrayList<String>();
		code.add("");
		code.add(prefix + ssaveLabel);
		code.add("\tLDS #$0000");
		code.add("\tPULS U,DP");
		code.add("\tRTS");
		code.add("");
		return code;
	}
	
	public byte[] getCompiledCode(String org) {
		byte[]  content = {};
		List<String> code = new ArrayList<String>();
		String tempFile="TMP";
		String tempASSFile=tempFile+".ASS";
		String tempBINFile=tempFile+".BIN";
		try
		{
			// Read PNG and generate assembly code
			Path assemblyFile = Paths.get(tempASSFile);
			Files.deleteIfExists(assemblyFile);
			Files.createFile(assemblyFile);
			
			code.add("(main)"+tempASSFile);
			code.add("\tORG $"+org);
			Files.write(assemblyFile, code, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCodeHeader(drawLabel, 1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCompiledCode(1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCodeSwitchData(2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCompiledCode(2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCodeFooter(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCompiledData(1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCompiledData(2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			//Files.write(assemblyFile, getCodeDataPos(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);

			Files.write(assemblyFile, getCodeHeader(erasePrefix, eraseLabel, 1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCompiledECode(1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCodeSwitchData(erasePrefix, 2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCompiledECode(2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCodeFooter(erasePrefix), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCompiledEData(erasePrefix, 1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCompiledEData(erasePrefix, 2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			
		    // Delete binary file
			Path binaryFile = Paths.get(tempBINFile);
			Files.deleteIfExists(binaryFile);
			
			// Generate binary code from assembly code
			Process p = new ProcessBuilder("c6809.exe", "-bd", tempASSFile, tempBINFile).start();
			BufferedReader br=new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;
			while((line=br.readLine())!=null){
				 System.out.println(line);
			}
			p.waitFor();
			
			// Load binary code
		    content = Files.readAllBytes(Paths.get(tempBINFile));	
			Files.deleteIfExists(binaryFile);
			
			// Rename .lst File
            File f = new File("codes.lst"); 
			Path lstFile = Paths.get(spriteName+".lst");
			Files.deleteIfExists(lstFile);
            f.renameTo(new File(spriteName+".lst"));
            
            Pattern pattern = Pattern.compile(".*Label (.*) ERASE_"+spriteName);
            try (Stream<String> lines = Files.lines(Paths.get(spriteName+".lst"), Charset.forName("ISO-8859-1"))) {
                lines.map(pattern::matcher)
                .filter(Matcher::matches)
                .findFirst()
                .ifPresent(matcher -> eraseAddress = matcher.group(1));
            }
		} 
		catch (Exception e)
		{
			e.printStackTrace(); 
			System.out.println(e); 
		}
        return content;
	}
	
	public List<String> getCodePalette(ColorModel colorModel, double gamma) {
		// std gamma: 3
		// suggestion : 2 pour couleurs pastel
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
		return code;
	}	
}

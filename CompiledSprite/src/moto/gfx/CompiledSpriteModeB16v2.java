package moto.gfx;

import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.awt.image.ColorModel;
import java.awt.Color;
import java.io.File;
import javax.imageio.ImageIO;
import java.util.ArrayList;
import java.util.List;

// METAL SLUG : 3192 cycles - Taille : A0B5 (41141) a A69E (42654) = 1513 octets
// optim ADDA : 3012 cycles - Taille : A0B5 (41141) a A670 (42608) = 1467 octets
// suppr otim renversement : 3055 cycles - Taille : A0B5 (41141) a A695 (42645) = 1504 octets
// Version 2 : 2814 cycles - Taille : A0B5 (41141) a A6C4 (42692) = 1551 octets
// optim offet ST : 2529 cycles - Taille : A0B5 (41141) a A68D (42637) = 1496 octets
// optim offet ST sur TR et -128 : 2513 cycles - Taille :  A0B5 (41141) a A6A0 (42656) = 1515 octets

// TODO
// Ajout optim LEAS ,--S au lieu de LEAS -2,S
// Ajout génération complete du code
// Modification de l'algo pour LD Ã  la place du PUL
// Calcul nb cycles
// Ajout gestion de l'avance par 1 pixel
// Ajout methode d'effacement du fond d'ecran
// Ajout gestion bit depth 4+Transparence ou bit depth 8+T
// Ajout mode non indexé avec Transparence
// Ajout GUI + gestion resize avec aspect ratio
// Ajout diminution de palette et selection manuelle de la couleur Transparente
// Mode batch
// Gestion Raster Effect
// Ajout priority flag (avant plan ou arriere plan)
// Gestion flip horizontal ou vertical
// rotate, scaling, warping
// slice (tranche a gauche et tranche a droite) effect d'entrelacement explosion : ou apparition en empilement de lignes
// effet de chaleur en variant les retours de ligne
// clignotement

public class CompiledSpriteModeB16v2 {
	// Convertisseur d'image PNG en "Compiled Sprite"
	// Thomson TO8/TO9+
	// Mode 160x200 en seize couleurs sans contraintes

	// Image
	BufferedImage image;
	ColorModel colorModel;
	String spriteName;
	int width;
	int height;
	byte[] pixels;

	// Calcul
	ArrayList<ArrayList<ArrayList<Integer>>> regCombos = new ArrayList<ArrayList<ArrayList<Integer>>>();
	final String[] pulReg = { "Y", "X", "DP", "B", "A", "D" };
	final int[] regCostPULx = { 2, 2, 1, 1, 1, 2 };
	final int[] regCostLDx = { 4, 3, 99, 2, 2, 3 }; // il n'y a pas de LDx pour DP
	final int[] regCostSTx = { 6, 5, 99, 4, 4, 5 }; // il n'y a pas de LDx pour DP
	private int leas = 0;
	private int stOffset = 0;

	// Code
	List<String> spriteCode1 = new ArrayList<String>();
	List<String> spriteCode2 = new ArrayList<String>();
	List<String> spriteData1 = new ArrayList<String>();
	List<String> spriteData2 = new ArrayList<String>();
	List<String> spriteE1Code1 = new ArrayList<String>();
	List<String> spriteE1Code2 = new ArrayList<String>();
	List<String> spriteE1Data1 = new ArrayList<String>();
	List<String> spriteE1Data2 = new ArrayList<String>();
	List<String> spriteE2Code1 = new ArrayList<String>();
	List<String> spriteE2Code2 = new ArrayList<String>();
	List<String> spriteE2Data1 = new ArrayList<String>();
	List<String> spriteE2Data2 = new ArrayList<String>();
	
	String drawLabel, drawELabel;
	String dataLabel;
	String posLabel;
	
	int cyclesCode = 0;
	int octetsCode = 0;
	int cyclesWCode1 = 0;
	int octetsWCode1 = 0;
	int cyclesWCode2 = 0;
	int octetsWCode2 = 0;
	int cyclesE1Code1 = 0;
	int octetsE1Code1 = 0;
	int cyclesE1Code2 = 0;
	int octetsE1Code2 = 0;
	int cyclesE2Code1 = 0;
	int octetsE2Code1 = 0;
	int cyclesE2Code2 = 0;
	int octetsE2Code2 = 0;
	boolean isSelfModifying = false;
	int offsetCode = 0;

	public CompiledSpriteModeB16v2(String file) {
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
			spriteName = removeExtension(file).toUpperCase().replaceAll("[^A-Za-z0-9]", "");

			// Initialisation du code statique
			drawLabel   = "DRAW_" + spriteName;
			dataLabel   = "DATA_" + spriteName;
			posLabel    = "POS_" + spriteName;
			drawELabel  = "DRAW_EREF_" + spriteName;

			// System.out.println("Type image:"+image.getType());
			// ContrÃ´le du format d'image
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
						// System.out.println(pixels[iDest]);
						iCol++;
						if (iCol == width + 1) {
							iCol = 0;
						}
					}
					width = width + 1;
				} else { // Sinon construction du tableau de pixels Ã  partir de l'image
					pixels = ((DataBufferByte) image.getRaster().getDataBuffer()).getData();
				}

				// Génération du code Assembleur
				generateCode();
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

	public void generateCode() {
		// Génération du code source pour l'effacement des images
		isSelfModifying = false;
		generateCodeArray(1, spriteE1Code1, spriteE1Data1);
		cyclesE1Code1 = cyclesCode;
		octetsE1Code1 = octetsCode;
		System.out.println("E1 Cycles 1:  " + cyclesCode);
		System.out.println("E1 Octets 1:  " + octetsCode);
		
		generateCodeArray(3, spriteE1Code2, spriteE1Data2);
		cyclesE1Code2 = cyclesCode;
		octetsE1Code2 = octetsCode;
		System.out.println("E1 Cycles 2:  " + cyclesCode);
		System.out.println("E1 Octets 2:  " + octetsCode);

		// Génération du code source pour l'effacement des images
		isSelfModifying = false;
		generateCodeArray(1, spriteE2Code1, spriteE2Data1);
		cyclesE2Code1 = cyclesCode;
		octetsE2Code1 = octetsCode;
		System.out.println("E2 Cycles 1:  " + cyclesCode);
		System.out.println("E2 Octets 1:  " + octetsCode);
		
		generateCodeArray(3, spriteE2Code2, spriteE2Data2);
		cyclesE2Code2 = cyclesCode;
		octetsE2Code2 = octetsCode;
		System.out.println("E2 Cycles 2:  " + cyclesCode);
		System.out.println("E2 Octets 2:  " + octetsCode);
		
		// Génération du code source pour l'écriture des images
		isSelfModifying = true;
		generateCodeArray(1, spriteCode1, spriteData1);
		cyclesWCode1 = cyclesCode;
		octetsWCode1 = octetsCode;
		System.out.println("W Cycles 1:  " + cyclesCode);
		System.out.println("W Octets 1:  " + octetsCode);
		
		generateCodeArray(3, spriteCode2, spriteData2);
		cyclesWCode2 = cyclesCode;
		octetsWCode2 = octetsCode;
		System.out.println("W Cycles 2:  " + cyclesCode);
		System.out.println("W Octets 2:  " + octetsCode);
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
		stOffset = 0;
		if (isSelfModifying) {
			offsetCode = (pos==1) ? 19+octetsE2Code2 : 12;
		}
		cyclesCode = 0;
		octetsCode = 0;

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

		if (isSelfModifying) {
			spriteCode.add("\tLDY " + drawELabel);
		}		
		
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

					if (chunk == pos + 1 && fdbBytes.size() > 0 && (fdbBytes.size() == 14 || // 14px max par PSH
							(pixel <= 2) || // ou fin de l'image
							(col <= 3 && width < 160) || // ou fin de ligne avec image qui n'est pas plein ecran
							(pixel >= 4 && (((int) pixels[pixel - 3] < 0 || (int) pixels[pixel - 3] > 15)
									|| ((int) pixels[pixel - 4] < 0 || (int) pixels[pixel - 4] > 15))))) {

						motif = optimisationPUL(fdbBytes, pulBytesOld);
						String[][] result = generateCodePULPSH(fdbBytes, pulBytesOld, motif);
						if (fdbBytes.size() / 2 > 2) {
							writeLEAS(pixel, spriteCode);
						}
						if (!result[0][0].equals("")) {
							spriteCode.add(result[0][0]); // PUL
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
	
	public void computeStats16b() {
			cyclesCode += 3;
			octetsCode += 3;
	}
	
	public void computeLEAS(int pixel, int col, int pos, List<String> spriteCode) {
		int fpixel = pixel; // intialisation des variables de travail
		int fcol = col;
		int offset = 0;

		// Initialisation variable globale
		leas = 0;

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
		if (pixel > 3 && leas < 0) {
			spriteCode.add("\tLEAS " + leas + ",S");
			computeStats8b(leas);
			stOffset = 0;
			leas = 0;
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
						somme += regCostPULx[cr];
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
			ArrayList<Integer> listeIndexReg) {
		String read = new String("");
		String write = new String("");
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

		for (Integer indexReg : listeIndexReg) {
			if (nbBytes == 7) {
				if (!pulBytes[indexReg].equals(pulBytesOld[indexReg])) {
					if (read.equals("")) {
						read += "\tPULU ";
						cyclesCode += 5;
						octetsCode += 2;
					} else {
						read += ",";
					}
					read += pulReg[indexReg];
					pulBytesOld[indexReg] = pulBytes[indexReg];
					pulBytesFiltered[indexReg] += pulBytes[indexReg];
					if (indexReg < 2) {
						cyclesCode += 2;
					} else {
						cyclesCode += 1;
					}
				}

				if (write.equals("")) {
					write += "\tPSHS ";
					cyclesCode += 5;
					octetsCode += 2;
				} else {
					write += ",";
				}
				write += pulReg[indexReg];
				if (indexReg < 2) {
					cyclesCode += 2;
				} else {
					cyclesCode += 1;
				}
			}
			if (nbBytes >= 3 && nbBytes <= 6) {
				if (!pulBytes[indexReg].equals(pulBytesOld[indexReg])) {
					if (!read.equals("")) {
						read = "\n" + read;
					}
					read = "\tLD" + pulReg[indexReg] + " #$" + pulBytes[indexReg] + read;
					pulBytesOld[indexReg] = pulBytes[indexReg];
					if (indexReg < 2) {
						computeStats16b();
					} else {
						computeStats8b();
					}
				}

				if (write.equals("")) {
					write += "\tPSHS ";
					cyclesCode += 5;
					octetsCode += 2;
				} else {
					write += ",";
				}
				write += pulReg[indexReg];
				if (indexReg < 2) {
					cyclesCode += 2;
				} else {
					cyclesCode += 1;
				}
			}
			if (nbBytes <= 2) {
				if (!pulBytes[indexReg].equals(pulBytesOld[indexReg])) {
					if (!read.equals("")) {
						read += "\n";
					}
					read += "\tLD" + pulReg[indexReg] + " #$" + pulBytes[indexReg];
					pulBytesOld[indexReg] = pulBytes[indexReg];
					if (indexReg < 2) {
						computeStats16b();
					} else {
						computeStats8b();
					}
				}
				if (!write.equals("")) {
					write += "\n";
				}
				if (isSelfModifying) {
					write += "\tST" + pulReg[indexReg] + " "+ (offsetCode+octetsCode) +",Y\n";
				}
				if (indexReg < 2) {
					stOffset -= 2;
					leas -= 2;
					write += "\tST" + pulReg[indexReg] + " " + stOffset + ",S";
					computeStats16b(stOffset);
				} else {
					stOffset -= 1;
					leas -= 1;
					write += "\tST" + pulReg[indexReg] + " " + stOffset + ",S";
					computeStats8b(stOffset);
				}
			}
		}

		// Enregistre les données FDB en sens inverse et filtrées
		for (int i = listeIndexReg.size() - 1; i >= 0; i--) {
			fdbBytesResult += pulBytesFiltered[listeIndexReg.get(i)];
		}

		result[0] = new String[] { read };
		result[1] = new String[] { write };
		result[2] = new String[] { fdbBytesResult };
		result[3] = pulBytesOld;
		return result;
	}

	public void ComputeRegCombos() {
		final int[] registres = { 2, 2, 1, 1, 1 }; // taille en octet de chaque registre dans l'ordre du PSH X, Y, DP,
													// B, A
		ArrayList<Integer> registresCourant = new ArrayList<Integer>();
		regCombos.clear();

		// **************************************************************
		// Construit un tableau dont l'indice est un nombre d'octet
		// de 0 Ã  7. Chaque indice contient les listes de toutes les
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
					nbBytes += registres[j];
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


	public List<String> getCompiledE1Code(int i) {
		return (i == 1) ? spriteE1Code2 : spriteE1Code1;
	}

	public List<String> getCompiledE1Data(int i) {
		return getCompiledE1Data("", i);
	}	
	
	public List<String> getCompiledE1Data(String prefix, int i) {
		if (i == 1) {
			spriteE1Data2.set(0, prefix + dataLabel + "_2");
		} else {
			spriteE1Data1.set(0, prefix + dataLabel + "_1");
		}
		return (i == 1) ? spriteE1Data2 : spriteE1Data1;
	}

	public List<String> getCompiledE2Code(int i) {
		return (i == 1) ? spriteE1Code2 : spriteE1Code1;
	}

	public List<String> getCompiledE2Data(int i) {
		return getCompiledE1Data("", i);
	}	
	
	public List<String> getCompiledE2Data(String prefix, int i) {
		if (i == 1) {
			spriteE1Data2.set(0, prefix + dataLabel + "_2");
		} else {
			spriteE1Data1.set(0, prefix + dataLabel + "_1");
		}
		return (i == 1) ? spriteE1Data2 : spriteE1Data1;
	}	
	
	public List<String> getCodeStart() {
		List<String> code = new ArrayList<String>();
		code.add("********************************************************************************");
		code.add("*                               CompiledSprite                                 *");
		code.add("********************************************************************************");
		code.add("* Auteur  :                                                                    *");
		code.add("* Date    :                                                                    *");
		code.add("* Licence :                                                                    *");
		code.add("********************************************************************************");
		code.add("*");
		code.add("********************************************************************************");
		code.add("");
		code.add("(main)" + spriteName.substring(0, Math.min(spriteName.length(), 8)) + ".asm");
		code.add("\tORG $8000");
		code.add("");
		code.add("********************************************************************************  ");
		code.add("* Constantes et variables");
		code.add("********************************************************************************");
		code.add("DEBUTECRANA EQU $0014	* test pour fin stack blasting");
		code.add("FINECRANA   EQU $1F40	* fin de la RAM A video");
		code.add("DEBUTECRANB EQU $2014	* test pour fin stack blasting");
		code.add("FINECRANB   EQU $3F40	* fin de la RAM B video");
		code.add("JOY_BD EQU $05       * Bas Droite");
		code.add("JOY_HD EQU $06       * Haut Droite");
		code.add("JOY_D  EQU $07       * Droite");
		code.add("JOY_BG EQU $09       * Bas Gauche");
		code.add("JOY_HG EQU $0A       * Haut Gauche");
		code.add("JOY_G  EQU $0B       * Gauche");
		code.add("JOY_B  EQU $0D       * Bas");
		code.add("JOY_H  EQU $0E       * Haut");
		code.add("JOY_C  EQU $0F       * Centre");
		code.add("");
		code.add("SSAVE FDB $0000");
		code.add("");
		code.add("********************************************************************************  ");
		code.add("* Debut du programme");
		code.add("********************************************************************************");
		code.add("\tORCC #$50	* a documenter (interruption)");
		code.add("\t");
		code.add("\tLDA #$7B	* passage en mode 160x200x16c");
		code.add("\tSTA $E7DC	");
		code.add("");
		code.add("********************************************************************************  ");
		code.add("* Initialisation de la palette de couleurs");
		code.add("********************************************************************************");
		code.add("\tLDY #TABPALETTE");
		code.add("\tCLRA");
		code.add("SETPALETTE");
		code.add("\tPSHS A");
		code.add("\tASLA");
		code.add("\tSTA $E7DB");
		code.add("\tLDD ,Y++");
		code.add("\tSTB $E7DA");
		code.add("\tSTA $E7DA");
		code.add("\tPULS A");
		code.add("\tINCA");
		code.add("\tCMPY #FINTABPALETTE");
		code.add("\tBNE	SETPALETTE");
		code.add("");
		code.add("********************************************************************************");
		code.add("* Initialisation de la routine de commutation de page video");
		code.add("********************************************************************************");
		code.add("\tLDB $6081 * A documenter");
		code.add("\tORB #$10  * mettre le bit d4 a 1");
		code.add("\tSTB $6081");
		code.add("\tSTB $E7E7");
		code.add("\tJSR SCRC * page 2 en RAM Cartouche (0000-3FFF) - page 0 en RAM Ecran (4000-5FFF)");
		code.add("");
		code.add("*-------------------------------------------------------------------------------");
		code.add("* Initialisation des deux pages videos avec Fond et sprites");
		code.add("*-------------------------------------------------------------------------------");
		code.add("\tLDB #$03  * On monte la page 3");
		code.add("\tSTB $E7E5 * en RAM Donnees (A000-DFFF)");
		code.add("");
		code.add("\tJSR DRAW_RAM_DATA_TO_CART_160x200");
		code.add("\tJSR DRAW_TEST1X100000               * TODO Boucle sur tous les sprites visibles");
		code.add("\tJSR SCRC                            * page 0 en RAM Cartouche (0000-3FFF) - page 2 en RAM Ecran (4000-5FFF)");
		code.add("\tJSR DRAW_RAM_DATA_TO_CART_160x200");
		code.add("\tJSR DRAW_TEST1X100000               * TODO Boucle sur tous les sprites visibles");
		code.add("\tJSR SCRC                            * page 2 en RAM Cartouche (0000-3FFF) - page 0 en RAM Ecran (4000-5FFF)");
		code.add("");
		code.add("*-------------------------------------------------------------------------------");
		code.add("* Boucle principale");
		code.add("*-------------------------------------------------------------------------------");
		code.add("MAIN");
		code.add("\t* Effacement et affichage des sprites");
		code.add("\tJSR ["+ drawELabel +"] * TODO boucler sur tous les effacements de sprite visibles dans le bon ordre");
		code.add("\tJSR "+ drawLabel +" * TODO boulcuer sur tous les sprites visibles dans le bon ordre");
		code.add("");
		code.add("\t* Gestion des deplacements");
		code.add("\tJSR JOY_READ");
		code.add("\tJSR Hero_Move");
		code.add("");
		code.add("\tJSR SCRC        * changement de page ecran");
		code.add("\tBRA MAIN");
		code.add("");
		code.add("********************************************************************************");
		code.add("* Changement de page ESPACE ECRAN (affichage du buffer visible)");
		code.add("*	$E7DD determine la page affichee dans ESPACE ECRAN (4000 a 5FFF)");
		code.add("*	D7=0 D6=0 D5=0 D4=0 (#$0_) : page 0");
		code.add("*	D7=0 D6=1 D5=0 D4=0 (#$4_) : page 1");
		code.add("*	D7=1 D6=0 D5=0 D4=0 (#$8_) : page 2");
		code.add("*	D7=1 D6=1 D5=0 D4=0 (#$C_) : page 3");
		code.add("*   D3 D2 D1 D0  (#$_0 a #$_F) : couleur du cadre");
		code.add("*   Remarque : D5 et D4 utilisable uniquement en mode MO");
		code.add("*");
		code.add("* Changement de page ESPACE CARTOUCHE (ecriture dans buffer invisible)");
		code.add("*	$E7E6 determine la page affichee dans ESPACE CARTOUCHE (0000 a 3FFF)");
		code.add("*   D5 : 1 = espace cartouche recouvert par de la RAM");
		code.add("*   D4 : 0 = CAS1N valide : banques 0-15 / 1 = CAS2N valide : banques 16-31");
		code.add("*	D5=1 D4=0 D3=0 D2=0 D1=0 D0=0 (#$60) : page 0");
		code.add("*   ...");
		code.add("*	D5=1 D4=0 D3=1 D2=1 D1=1 D0=1 (#$6F) : page 15");
		code.add("*	D5=1 D4=1 D3=0 D2=0 D1=0 D0=0 (#$70) : page 16");
		code.add("*   ...");
		code.add("*	D5=1 D4=1 D3=1 D2=1 D1=1 D0=1 (#$7F) : page 31");
		code.add("********************************************************************************");
		code.add("SCRC");
		code.add("\tJSR VSYNC");
		code.add("");
		code.add("\tLDX DRAW_EREF_TEST1X100000	* permute les routines");
		code.add("\tLDY DRAW_EREF_TEST1X100000+2  * d effacement");
		code.add("\tSTY DRAW_EREF_TEST1X100000    * des sprites");
		code.add("\tSTX DRAW_EREF_TEST1X100000+2  * TODO faire boucle sur tous les sprites VISIBLES");
		code.add("");
		code.add("\tLDB SCRC0+1\t* charge la valeur du LDB suivant SCRC0 en lisant directement dans le code");
		code.add("\tANDB #$80\t* permute #$00 ou #$80 (suivant la valeur B #$00 ou #$FF) / fond couleur 0");
		code.add("\tORB #$0F\t* recharger la couleur de cadre si diff de 0 car effacee juste au dessus (couleur F)");
		code.add("\tSTB $E7DD\t* changement page dans ESPACE ECRAN");
		code.add("\tCOM SCRC0+1\t* modification du code alterne 00 et FF sur le LDB suivant SCRC0");
		code.add("SCRC0");
		code.add("\tLDB #$00");
		code.add("\tANDB #$02\t* permute #$60 ou #$62 (suivant la valeur B #$00 ou #$FF)");
		code.add("\tORB #$60\t* espace cartouche recouvert par RAM / ecriture autorisee");
		code.add("\tSTB $E7E6\t* changement page dans ESPACE CARTOUCHE permute 60/62 dans E7E6 pour demander affectation banque 0 ou 2 dans espace cartouche"); 
		code.add("\tRTS\t\t\t* E7E6 D5=1 pour autoriser affectation banque");
		code.add("\t\t\t\t* CAS1N : banques 0-15 CAS2N : banques 16-31");
		code.add("");		
		code.add("********************************************************************************");
		code.add("* Attente VBL");
		code.add("********************************************************************************");
		code.add("VSYNC");
		code.add("VSYNC_1");
		code.add("\tTST	$E7E7");
		code.add("\tBPL	VSYNC_1");
		code.add("VSYNC_2");
		code.add("\tTST	$E7E7");
		code.add("\tBMI	VSYNC_2");
		code.add("\tRTS");
		code.add("");
		code.add("*---------------------------------------");
		code.add("* Get joystick parameters");
		code.add("*---------------------------------------");
		code.add("JOY_READ");
		code.add("\tldx    #$e7cf");
		code.add("\tldy    #$e7cd");
		code.add("\tldd    #$400f ");
		code.add("\tandb   >$e7cc     * Read position");
		code.add("\tstb    JOY_DIR_STATUS");
		code.add("\tanda   ,y         * Read button");
		code.add("\teora   #$40");
		code.add("\tsta    JOY_BTN_STATUS");
		code.add("\tRTS");
		code.add("JOY_DIR_STATUS");
		code.add("\tFCB $00 * Position Pad");
		code.add("JOY_BTN_STATUS");
		code.add("\tFCB $00 * 40 Bouton A enfonce");
		code.add("");
		code.add("*---------------------------------------------------------------------------");
		code.add("* Subroutine to	make hero walk/run");
		code.add("*---------------------------------------------------------------------------");
		code.add("");
		code.add("Hero_Move");
		code.add("\tLDA JOY_G");
		code.add("\tCMPA JOY_DIR_STATUS");
		code.add("\tBNE Hero_NotLeft");
		code.add("\tBSR Hero_MoveLeft");
		code.add("");
		code.add("Hero_NotLeft                   * XREF: Hero_Move");
		code.add("\tLDA JOY_D");
		code.add("\tCMPA JOY_DIR_STATUS");
		code.add("\tBNE Hero_NotRight");
		code.add("\tBSR Hero_MoveRight");
		code.add("");
		code.add("Hero_NotRight                  * XREF: Hero_NotLeft");
		code.add("\tLDD TEST1X10_G_SPEED");
		code.add("\tCMPD #$0000");
		code.add("\tBLO Hero_NotRight_00");
		code.add("\tSUBD TEST1X10_ACCELERATION * If you are not pressing Left or Right, friction (frc) kicks in. In any step in which the game recieves no horizontal input,");
		code.add("\tBCC Hero_NotRight_01       * frc is subtracted from gsp (depending on the sign of gsp), where if it then passes over 0, it's set back to 0.");
		code.add("\tLDA #$01                   * Charge animation STOP R");
		code.add("Hero_NotRight_02");
		code.add("\tSTA TEST1X10_ANIMATION");
		code.add("\tLDD	#$0000");
		code.add("Hero_NotRight_01");
		code.add("\tSTD TEST1X10_G_SPEED");
		code.add("\tRTS");
		code.add("Hero_NotRight_00");
		code.add("\tADDD TEST1X10_ACCELERATION ");
		code.add("\tBCC Hero_NotRight_01      ");
		code.add("\tLDA #$02                   * Charge animation STOP L     ");
		code.add("\tBRA Hero_NotRight_02	");
		code.add("");
		code.add("Hero_MoveLeft                  * XREF: Hero_Move");
		code.add("\tLDD TEST1X10_G_SPEED");
		code.add("\tCMPD #$0000");
		code.add("\tBLT Hero_MoveLeft_00       * BRANCH si la vitesse actuelle est negative");
		code.add("\tSUBD TEST1X10_DECELERATION * gsp decrease by deceleration");
		code.add("\tBCC Hero_MoveLeft_03       * BRANCH si la vitesse actuelle est positive");
		code.add("\tLDD TEST1X10_DECELERATION  * si la vitesse est devenue negative on la force a la va leur de DECELERATION");
		code.add("Hero_MoveLeft_03	");
		code.add("\tSTD TEST1X10_G_SPEED       * la vitesse actuelle est negative, Hero va a gauche");
		code.add("\tBRA Hero_MoveLeft_02	");
		code.add("Hero_MoveLeft_00		");
		code.add("\tCMPD TEST1X10_NEG_TOP_SPEED");
		code.add("\tBEQ Hero_MoveLeft_02       * gsp est deja au maximum");
		code.add("\tSUBD TEST1X10_ACCELERATION * gsp increases by acc every step");
		code.add("\tCMPD TEST1X10_NEG_TOP_SPEED");
		code.add("\tBLE Hero_MoveLeft_01       * if gsp exceeds top it's set to top");
		code.add("\tLDA #$06                   * Charge animation RUN L");
		code.add("\tSTA TEST1X10_ANIMATION");
		code.add("\tLDD TEST1X10_NEG_TOP_SPEED");
		code.add("\tSTD TEST1X10_G_SPEED");
		code.add("\tBRA Hero_MoveLeft_02");
		code.add("Hero_MoveLeft_01");
		code.add("\tSTD TEST1X10_G_SPEED");
		code.add("\tLDA #$04                   * Charge animation WALK L");
		code.add("\tSTA TEST1X10_ANIMATION");
		code.add("\tLDD TEST1X10_G_SPEED");
		code.add("Hero_MoveLeft_02");
		code.add("\tSTD TEST1X10_X_SPEED       * TODO xsp = gsp*cos(angle)");
		code.add("\tADDD TEST1X10_X_POS");
		code.add("\tSTD TEST1X10_X_POS");
		code.add("\tLDD #$0000                 * TODO ysp = gsp*-sin(angle)");
		code.add("\tSTD TEST1X10_Y_SPEED");
		code.add("\tADDD TEST1X10_Y_POS");
		code.add("\tSTD TEST1X10_Y_POS");
		code.add("\tRTS");
		code.add("");
		code.add("Hero_MoveRight                  * XREF: Hero_NotLeft");
		code.add("\tLDD TEST1X10_G_SPEED");
		code.add("\tCMPD #$0000");
		code.add("\tBGE Hero_MoveRight_00       * BRANCH si la vitesse actuelle est nulle ou positive");
		code.add("\tADDD TEST1X10_DECELERATION 	* gsp decrease by deceleration");
		code.add("\tBCC Hero_MoveRight_03       * BRANCH si la vitesse actuelle est negative");
		code.add("\tLDD TEST1X10_DECELERATION   * si la vitesse est devenue positive on la force a la va leur de DECELERATION");
		code.add("Hero_MoveRight_03	");
		code.add("\tSTD TEST1X10_G_SPEED        * la vitesse actuelle est negative, Hero va a gauche");
		code.add("\tBRA Hero_MoveRight_02	");
		code.add("Hero_MoveRight_00		");
		code.add("\tCMPD TEST1X10_TOP_SPEED");
		code.add("\tBEQ Hero_MoveRight_02       * gsp est deja au maximum");
		code.add("\tADDD TEST1X10_ACCELERATION 	* gsp increases by acc every step");
		code.add("\tCMPD TEST1X10_TOP_SPEED");
		code.add("\tBLE Hero_MoveRight_01       * if gsp exceeds top it's set to top");
		code.add("\tLDA #$05                    * Charge animation RUN R");
		code.add("\tSTA TEST1X10_ANIMATION");
		code.add("\tLDD TEST1X10_TOP_SPEED");
		code.add("\tSTD TEST1X10_G_SPEED");
		code.add("\tBRA Hero_MoveRight_02");
		code.add("Hero_MoveRight_01");
		code.add("\tSTD TEST1X10_G_SPEED");
		code.add("\tLDA #$03                    * Charge animation WALK R");
		code.add("\tSTA TEST1X10_ANIMATION");
		code.add("\tLDD TEST1X10_G_SPEED");
		code.add("Hero_MoveRight_02");
		code.add("\tSTD TEST1X10_X_SPEED        * TODO xsp = gsp*cos(angle)");
		code.add("\tADDD TEST1X10_X_POS");
		code.add("\tSTD TEST1X10_X_POS");
		code.add("\tLDD #$0000                  * TODO ysp = gsp*-sin(angle)");
		code.add("\tSTD TEST1X10_Y_SPEED");
		code.add("\tADDD TEST1X10_Y_POS");
		code.add("\tSTD TEST1X10_Y_POS");
		code.add("\tRTS");
		code.add("");
		code.add("* TODO : Braking Animation");
		code.add("* Sonic enters his braking animation when you turn around only if his absolute gsp is equal to or more than 4.");
		code.add("* In Sonic 1 and Sonic CD, he then stays in the braking animation until gsp reaches zero or changes sign.");
		code.add("* In the other 3 games, Sonic returns to his walking animation after the braking animation finishes displaying all of its frames.");
		code.add("");
		code.add("Compute_Position");
		code.add("* Doit calculer ici les deux positions POS_TEST1X100000 pour RAMA et RAMB en fonction de TEST1X10_X_POS et TEST1X10_Y_POS");
		code.add("\t*LDX POS_TEST1X100000	* avance de 2 px a gauche");
		code.add("\t*LDD POS_TEST1X100000+2");
		code.add("\t*STX POS_TEST1X100000+2");
		code.add("\t*SUBD JOY_STATUS");
		code.add("\t*STD POS_TEST1X100000");
		code.add("\tRTS");
		code.add("********************************************************************************  ");
		code.add("* Affichage de l arriere plan xxx cycles");
		code.add("********************************************************************************	");
		code.add("DRAW_RAM_DATA_TO_CART_160x200");
		code.add("\tPSHS U,DP		* sauvegarde des registres pour utilisation du stack blast");
		code.add("\tSTS >SSAVE");
		code.add("\t");
		code.add("\tLDS #FINECRANA	* init pointeur au bout de la RAM A video (ecriture remontante)");
		code.add("\tLDU #$A000");
		code.add("");
		code.add("DRAW_RAM_DATA_TO_CART_160x200A");
		code.add("\tPULU A,B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B,A");
		code.add("\tPULU A,B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B,A");
		code.add("\tPULU A,B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B,A");
		code.add("\tPULU A,B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B,A");
		code.add("\tPULU A,B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B,A");
		code.add("\tPULU A,B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B,A");
		code.add("\tCMPS #DEBUTECRANA");
		code.add("\tBNE DRAW_RAM_DATA_TO_CART_160x200A");
		code.add("\tPULU A,B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B,A");
		code.add("\tPULU A,B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B,A");
		code.add("\tPULU B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B");
		code.add("");
		code.add("\tLDS #FINECRANB	* init pointeur au bout de la RAM B video (ecriture remontante)");
		code.add("\tLDU #$C000");
		code.add("");
		code.add("DRAW_RAM_DATA_TO_CART_160x200B");
		code.add("\tPULU A,B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B,A");
		code.add("\tPULU A,B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B,A");
		code.add("\tPULU A,B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B,A");
		code.add("\tPULU A,B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B,A");
		code.add("\tPULU A,B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B,A");
		code.add("\tPULU A,B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B,A");
		code.add("\tCMPS #DEBUTECRANB");
		code.add("\tBNE DRAW_RAM_DATA_TO_CART_160x200B");
		code.add("\tPULU A,B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B,A");
		code.add("\tPULU A,B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B,A");
		code.add("\tPULU B,DP,X,Y");
		code.add("\tPSHS Y,X,DP,B");
		code.add("");
		code.add("\tLDS  >SSAVE		* rechargement des registres");
		code.add("\tPULS U,DP");
		code.add("\tRTS");
		code.add("");
		code.add("********************************************************************************");
		code.add("* Affiche un computed sprite en xxx cycles");
		code.add("********************************************************************************");
		code.add("TEST1X10_X_POS");
		code.add("\tFDB $0000        * position horizontale");
		code.add("TEST1X10_Y_POS");
		code.add("\tFDB $0000        * position verticale");
		code.add("TEST1X10_G_SPEED");
		code.add("\tFDB $0000        * vitesse au sol");
		code.add("TEST1X10_X_SPEED");
		code.add("\tFDB $0000        * vitesse horizontale");
		code.add("TEST1X10_Y_SPEED");
		code.add("\tFDB $0000        * vitesse verticale");
		code.add("TEST1X10_TOP_SPEED");
		code.add("\tFDB $0600        * vitesse maximum autorisee 6 = 1536/256");
		code.add("TEST1X10_NEG_TOP_SPEED");
		code.add("\tFDB $FA00        * vitesse maximum autorisee -6 = -1536/256");
		code.add("TEST1X10_ACCELERATION");
		code.add("\tFDB $000C        * constante acceleration 0.046875 = 12/256");
		code.add("TEST1X10_DECELERATION");
		code.add("\tFDB $0080        * constante deceleration 0.5 = 128/256");
		code.add("TEST1X10_FRICTION");
		code.add("\tFDB $000C        * constante de friction 0.046875 = 12/256");
		code.add("TEST1X10_ANIMATION");
		code.add("\tFCB $00          * Animation courante");
//		code.add("TEST1X10_REF_ANIMATIONS");
//		code.add("\tFDB DRAW_TEST1X10_NULL * sprite invisible");
//		code.add("\tFDB DRAW_TEST1X10_IDLE_R * sprite immobile Droite");
//		code.add("\tFDB DRAW_TEST1X10_IDLE_L * sprite immobile Gauche");
//		code.add("\tFDB DRAW_TEST1X10_WALK_R * sprite marche Droite");
//		code.add("\tFDB DRAW_TEST1X10_WALK_L * sprite marche Gauche");
//		code.add("\tFDB DRAW_TEST1X10_JOG_R * sprite cours Droite");
//		code.add("\tFDB DRAW_TEST1X10_JOG_L * sprite cours Gauche");
//		code.add("\tFDB DRAW_TEST1X10_SKID_R * sprite freine Droite");
//		code.add("\tFDB DRAW_TEST1X10_SKID_L * sprite freine Gauche");
//		code.add("\tFDB DRAW_TEST1X10_SKIDTURN_R * sprite se retourne Droite");
//		code.add("\tFDB DRAW_TEST1X10_SKIDTURN_L * sprite se retourne Gauche");
		code.add("");
		return code;
	}

	public List<String> getCodeHeader(int pos) {
		return getCodeHeader("", pos);
	}	
	
	public List<String> getCodeHeader(String prefix, int pos) {
		List<String> code = new ArrayList<String>();
		code.add(prefix + drawLabel);
		code.add("\tPSHS U,DP");
		code.add("\tSTS >SSAVE");
		code.add("");
		code.add("\tLDS " + prefix + posLabel);
		code.add("\tLDU #" + prefix + dataLabel + "_" + pos);
		return code;
	}
	
	public List<String> getCodeSwitchData(int pos) {
		return getCodeSwitchData("", pos);
	}

	public List<String> getCodeSwitchData(String prefix, int pos) {
		List<String> code = new ArrayList<String>();
		code.add("");
		code.add("\tLDS " + prefix + posLabel + "+2");
		code.add("\tLDU #" + prefix + dataLabel + "_" + pos);
		code.add("");
		return code;
	}

	public List<String> getCodeFooter() {
		List<String> code = new ArrayList<String>();
		code.add("");
		code.add("\tLDS  >SSAVE");
		code.add("\tPULS U,DP");
		code.add("\tRTS");
		code.add("");
		return code;
	}

	public List<String> getCodeDataPos() {
		return getCodeDataPos("");
	}
	
	public List<String> getCodeDataPos(String prefix) {
		List<String> code = new ArrayList<String>();
		code.add(prefix + posLabel);
		code.add("\tFDB $1F40");
		code.add("\tFDB $3F40");
		code.add("");
		return code;
	}

	public List<String> getCodeEREFLabel(String e1, String e2) {
		List<String> code = new ArrayList<String>();
		code.add(drawELabel);
		code.add("\tFDB " + e1 + drawLabel);
		code.add("\tFDB " + e2 + drawLabel);
		code.add("");
		return code;
	}

	public ColorModel getColorModel() {
		return colorModel;
	}
	
	public List<String> getCodePalette(ColorModel colorModel, int gamma) {
		// std gamma: 3
		// suggestion : 2 pour couleurs pastel
		List<String> code = new ArrayList<String>();

		code.add("TABPALETTE");
		// Construction de la palette de couleur
		for (int j = 0; j < 16; j++) {
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

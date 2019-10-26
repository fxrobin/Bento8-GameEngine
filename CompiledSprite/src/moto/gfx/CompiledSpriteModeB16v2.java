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
// optim offet ST sur TR et -127 : 2513 cycles - Taille :  A0B5 (41141) a A6A0 (42656) = 1515 octets

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
	// Thomson MO5NR, MO6, TO8, TO9 et TO9+
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
	final String[] pulReg    = { "Y", "X", "DP", "B", "A", "D" };
	final int[] regCostPULx  = { 2, 2,  1, 1, 1, 2 };
	final int[] regCostLDx   = { 4, 3, 99, 2, 2, 3 }; // il n'y a pas de LDx pour DP
	final int[] regCostSTx   = { 6, 5, 99, 4, 4, 5 }; // il n'y a pas de LDx pour DP
	private int leas = 0;
	private int stOffset=0;

	// Code
	List<String> spriteCode1 = new ArrayList<String>();
	List<String> spriteCode2 = new ArrayList<String>();
	List<String> spriteData1 = new ArrayList<String>();
	List<String> spriteData2 = new ArrayList<String>();

	String posLabel;
	String drawLabel;
	String dataLabel;

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
			posLabel = "POS_" + spriteName;
			drawLabel = "DRAW_" + spriteName;
			dataLabel = "DATA_" + spriteName;

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
		// Génération du code source pour l'écriture des images
		generateCodeArray(1, spriteCode1, spriteData1);
		generateCodeArray(3, spriteCode2, spriteData2);
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
		stOffset=0;

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
						computeLEAS(pixel+3, col+3, pos, spriteCode);
						writeLEAS(pixel, spriteCode);
					}
					doubleFwd = 1;
				} else {
					doubleFwd = 0;

					// Construction d'une liste de pixels et transformation des pixels transparents en 0
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

						spriteCode.add("\tANDA "+stOffset+",S");
						spriteCode.add("\tADDA #$"+fdbBytes.get(fdbBytes.size()-1)+fdbBytes.get(fdbBytes.size()-2));
						spriteCode.add("\tSTA "+stOffset+",S");
						
						pulBytesOld[4] = "zz"; // invalide l'historique du registre car transparence
						fdbBytes.clear();

						computeLEAS(pixel, col, pos, spriteCode);
					}

					// **************************************************************
					// Gestion d'une paire de pixels pleins
					// **************************************************************
					
					if (chunk == pos + 1 && fdbBytes.size() > 0
						&& (fdbBytes.size() == 14 || // 14px max par PSH
						(pixel <= 2) || // ou fin de l'image
						(col <= 3 && width < 160) || // ou fin de ligne avec image qui n'est pas plein ecran
						(pixel >= 4 && (((int) pixels[pixel-3] < 0 || (int) pixels[pixel-3] > 15)
						             || ((int) pixels[pixel-4] < 0 || (int) pixels[pixel-4] > 15))) )) { 

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

		generateDataFDB(fdbBytesResult, (pos == 1) ? 2 : 1, spriteData); // Construction du code des données
	}

	public void computeLEAS(int pixel, int col, int pos, List<String> spriteCode) {
		int fpixel = pixel; // intialisation des variables de travail
		int fcol = col;
		int offset = 0;
		
		// Initialisation variable globale
		leas = 0;

		// en fonction du nombre de A ou B par image le retour à la ligne n'est pas le même
		if (((width/2) == (width/4)*2) || pos == 3) {
			offset = 0;
		} else {
			offset = 1;
		}
		
		// On regarde ce qui suit ...
		// *** CAS: Saut de ligne ***
		if (fcol <= 3) {
			fcol = width - pos;
			leas += -40 + (width / 4) + offset; // Remarque : dans le cas d'une image plein ecran leas=0
			if (((width/2) == (width/4)*2)) {
				fpixel -= 4;
			} else if (pos == 1) {
				fpixel -= 2;
			} else if (pos == 3) {
				fpixel -= 6;
			}
		}
		else {
			fcol -= 4;
			fpixel -= 4;
		}

		// *** CAS : Pixels transparents par paires ***
		while (fpixel > 0 && ((int) pixels[fpixel]   < 0 || (int) pixels[fpixel]   > 15)
				          && ((int) pixels[fpixel+1] < 0 || (int) pixels[fpixel+1] > 15)) {
			fcol -= 4;
			leas--;			
			if (fcol <= -1) {
				fcol = width - pos;
				leas += -40 + (width / 4) + offset;
				if (((width/2) == (width/4)*2)) {
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
		if ((fpixel > 0) && ((((int) pixels[fpixel]   >= 0 && (int) pixels[fpixel]   <= 15)
				           && ((int) pixels[fpixel+1]  < 0 || (int) pixels[fpixel+1]  > 15))
				          || (((int) pixels[fpixel]    < 0 || (int) pixels[fpixel]    > 15)
				           && ((int) pixels[fpixel+1] >= 0 && (int) pixels[fpixel+1] <= 15)))) {
			leas--;
		}
		stOffset += leas;
		leas = stOffset;
		
		if (stOffset < -127) {
			writeLEAS(fpixel, spriteCode);
		}
	}
	
	public void writeLEAS(int pixel, List<String> spriteCode) {
		if (pixel > 3 && leas < 0) {
			spriteCode.add("\tLEAS " + leas + ",S");
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

	public String[][] generateCodePULPSH(ArrayList<String> fdbBytes, String[] pulBytesOld, ArrayList<Integer> listeIndexReg) {
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
					} else {
						read += ",";
					}
					read += pulReg[indexReg];
					pulBytesOld[indexReg] = pulBytes[indexReg];
					pulBytesFiltered[indexReg] += pulBytes[indexReg];
				}

				if (write.equals("")) {
					write += "\tPSHS ";
				} else {
					write += ",";
				}
				write += pulReg[indexReg];
			}
			if (nbBytes >= 3 && nbBytes <= 6) {
				if (!pulBytes[indexReg].equals(pulBytesOld[indexReg])) {
					if (!read.equals("")) {
						read = "\n" + read;
					}
					read = "\tLD" + pulReg[indexReg] + " #$" + pulBytes[indexReg] + read;
					pulBytesOld[indexReg] = pulBytes[indexReg];
				}

				if (write.equals("")) {
					write += "\tPSHS ";
				} else {
					write += ",";
				}
				write += pulReg[indexReg];
			}
			if (nbBytes <= 2) {
				if (!pulBytes[indexReg].equals(pulBytesOld[indexReg])) {
					if (!read.equals("")) {
						read += "\n";
					}
					read += "\tLD"+pulReg[indexReg]+" #$"+pulBytes[indexReg];
					pulBytesOld[indexReg] = pulBytes[indexReg];
				}
				if (!write.equals("")) {
					write += "\n";
				}
				if (indexReg < 2) {
					stOffset -= 2;
					leas -= 2;
					write += "\tST"+pulReg[indexReg]+" "+stOffset+",S";
				} else {
					stOffset -= 1;
					leas -= 1;
					write += "\tST"+pulReg[indexReg]+" "+stOffset+",S";
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

	public void generateDataFDB(String pixels, int x, List<String> spriteData) {
		int bitIndex = 0;
		String dataLine = new String();

		// **************************************************************
		// Construit un tableau de données en assembleur
		// **************************************************************

		spriteData.add(dataLabel + "_" + x);

		for (int i = 0; i < pixels.length(); i++) {
			bitIndex++;
			if (bitIndex == 1) {
				dataLine = "\tFDB $";
			}

			dataLine += pixels.charAt(i);

			if (bitIndex == 4) {
				spriteData.add(dataLine);
				bitIndex = 0;
			}
		}

		// On complete le mot pour la dernière ligne de données
		if (bitIndex > 0) {
			while (bitIndex < 4) {
				dataLine += "0";
				bitIndex++;
			}
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
		return (i == 1) ? spriteData2 : spriteData1;
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
		code.add("\tORG $A000");
		code.add("");
		code.add("********************************************************************************  ");
		code.add("* Constantes et variables");
		code.add("********************************************************************************");
		code.add("DEBUTECRANA EQU $0000	* debut de la RAM A video");
		code.add("FINECRANA EQU $1F40	* fin de la RAM A video");
		code.add("DEBUTECRANB EQU $2000	* debut de la RAM B video");
		code.add("FINECRANB EQU $3F40	* fin de la RAM B video");
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
		code.add("\t");
		code.add("********************************************************************************  ");
		code.add("* Initialisation de la couleur de bordure");
		code.add("********************************************************************************");
		code.add("INITBORD");
		code.add("\tLDA	#$04	* couleur 4");
		code.add("\tSTA	$E7DD");
		code.add("");
		code.add("********************************************************************************");
		code.add("* Initialisation de la routine de commutation de page video");
		code.add("********************************************************************************");
		code.add("\tLDB $6081");
		code.add("\tORB #$10");
		code.add("\tSTB $6081");
		code.add("\tSTB $E7E7");
		code.add("");
		code.add("********************************************************************************");
		code.add("* Effacement ecran (les deux pages)");
		code.add("********************************************************************************");
		code.add("\tJSR SCRC");
		code.add("\tJSR EFF");
		code.add("\tJSR SCRC");
		code.add("\tJSR EFF");
		code.add("");
		code.add("********************************************************************************");
		code.add("* Boucle principale");
		code.add("********************************************************************************");
		code.add("MAIN");
		code.add("\tJSR DRAWBCKGRN");
		code.add("\t*LDX >" + posLabel);
		code.add("\t*LEAX -1,X");
		code.add("\t*STX >" + posLabel);
		code.add("\tJSR " + drawLabel);
		code.add("\tJSR SCRC        * changement de page ecran");
		code.add("\tBRA MAIN");
		code.add("");
		code.add("********************************************************************************");
		code.add("* Changement de page ecran");
		code.add("********************************************************************************");
		code.add("SCRC");
		code.add("\tLDB SCRC0+1");
		code.add("\tANDB #$80          * BANK1 utilisee ou pas pour l affichage / fond couleur 0");
		code.add("\tORB #$0A           * contour ecran = couleur A");
		code.add("\tSTB $E7DD");
		code.add("\tCOM SCRC0+1");
		code.add("SCRC0");
		code.add("\tLDB #$00");
		code.add("\tANDB #$02          * page RAM no0 ou no2 utilisee dans l espace cartouche");
		code.add("\tORB #$60           * espace cartouche recouvert par RAM / ecriture autorisee");
		code.add("\tSTB $E7E6");
		code.add("\tRTS");
		code.add("");
		code.add("********************************************************************************");
		code.add("* Effacement de l ecran");
		code.add("********************************************************************************");
		code.add("EFF");
		code.add("\tLDA #$AA  * couleur fond");
		code.add("\tLDY #$0000");
		code.add("EFF_RAM");
		code.add("\tSTA ,Y+");
		code.add("\tCMPY #$3FFF");
		code.add("\tBNE EFF_RAM");
		code.add("\tRTS");
		code.add("");
		code.add("********************************************************************************  ");
		code.add("* Affichage de l arriere plan xxx cycles");
		code.add("********************************************************************************	");
		code.add("DRAWBCKGRN");
		code.add("\tPSHS U,DP		* sauvegarde des registres pour utilisation du stack blast");
		code.add("\tSTS >SSAVE");
		code.add("\t");
		code.add("\tLDS #FINECRANA	* init pointeur au bout de la RAM A video (ecriture remontante)");
		code.add("\tLDU #TILEBCKGRNDA");
		code.add("\tPULU X,Y,DP,D");
		code.add("");
		code.add("DRWBCKGRNDA");
		code.add("\tPSHS X,Y,DP,D");
		code.add("\tPSHS X,Y,DP,D");
		code.add("\tPSHS X,Y,DP,D");
		code.add("\tPSHS X,Y,DP,D");
		code.add("\tPSHS X,Y,DP,D");
		code.add("\tPSHS X,Y,DP");
		code.add("\tCMPS #DEBUTECRANA");
		code.add("\tBNE DRWBCKGRNDA");
		code.add("\t");
		code.add("\tLDS #FINECRANB	* init pointeur au bout de la RAM B video (ecriture remontante)");
		code.add("\tLDU #TILEBCKGRNDB");
		code.add("\tPULU X,Y,DP,D");
		code.add("");
		code.add("DRWBCKGRNDB");
		code.add("\tPSHS X,Y,DP,D");
		code.add("\tPSHS X,Y,DP,D");
		code.add("\tPSHS X,Y,DP,D");
		code.add("\tPSHS X,Y,DP,D");
		code.add("\tPSHS X,Y,DP,D");
		code.add("\tPSHS X,Y,DP");
		code.add("\tCMPS #DEBUTECRANB");
		code.add("\tBNE DRWBCKGRNDB");
		code.add("\t");
		code.add("\tLDS  >SSAVE		* rechargement des registres");
		code.add("\tPULS U,DP");
		code.add("\tRTS");
		code.add("");
		code.add("********************************************************************************");
		code.add("* Affiche un computed sprite en xxx cycles");
		code.add("********************************************************************************");
		return code;
	}

	public List<String> getCodeEnd() {
		List<String> code = new ArrayList<String>();
		code.add("********************************************************************************  ");
		code.add("* Tile arriere plan   ");
		code.add("********************************************************************************");
		code.add("TILEBCKGRNDA");
		code.add("\tFDB $eeee");
		code.add("\tFDB $eeee");
		code.add("\tFDB $eeee");
		code.add("\tFDB $eeee");
		code.add("");
		code.add("TILEBCKGRNDB");
		code.add("\tFDB $ffff");
		code.add("\tFDB $ffff");
		code.add("\tFDB $ffff");
		code.add("\tFDB $ffff");
		return code;
	}

	public List<String> getCodeHeader(int pos) {
		List<String> code = new ArrayList<String>();
		code.add(drawLabel);
		code.add("\tPSHS U,DP");
		code.add("\tSTS >SSAVE");
		code.add("");
		code.add("\tLDS >" + posLabel);
		code.add("\tLDU #" + dataLabel + "_" + pos);
		code.add("");
		return code;
	}

	public List<String> getCodeSwitchData(int pos) {
		List<String> code = new ArrayList<String>();
		code.add("");
		code.add("\tLDS >" + posLabel);
		code.add("\tLEAS 8192,S");
		code.add("\tLDU #" + dataLabel + "_" + pos);
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
		List<String> code = new ArrayList<String>();
		code.add(posLabel);
		code.add("\tFDB $1F40");
		code.add("");
		return code;
	}

	public List<String> getCodePalette() {
		List<String> code = new ArrayList<String>();

		code.add("TABPALETTE");
		// Construction de la palette de couleur
		for (int j = 0; j < 16; j++) {
			Color couleur = new Color(colorModel.getRGB(j));
			code.add("\tFDB $0" + Integer.toHexString((int) Math.round(15 * Math.pow((couleur.getBlue() / 255.0), 3)))
					+ Integer.toHexString((int) Math.round(15 * Math.pow((couleur.getGreen() / 255.0), 3)))
					+ Integer.toHexString((int) Math.round(15 * Math.pow((couleur.getRed() / 255.0), 3))) + "\t* index:"
					+ String.format("%-2.2s", j) + " R:" + String.format("%-3.3s", couleur.getRed()) + " V:"
					+ String.format("%-3.3s", couleur.getGreen()) + " B:" + String.format("%-3.3s", couleur.getBlue()));
		}
		code.add("FINTABPALETTE");
		return code;
	}

	// public static BufferedImage rgbaToIndexedBufferedImage(BufferedImage
	// sourceBufferedImage) {
	// //With this constructor we create an indexed bufferedimage with the same
	// dimensiosn and with a default 256 color model
	// BufferedImage indexedImage= new
	// BufferedImage(sourceBufferedImage.getWidth(),sourceBufferedImage.getHeight(),BufferedImage.TYPE_BYTE_INDEXED);
	//
	//
	// ColorModel cm = indexedImage.getColorModel();
	// IndexColorModel icm=(IndexColorModel) cm;
	//
	// int size=icm.getMapSize();
	//
	// byte[] reds = new byte[size];
	// byte[] greens = new byte[size];
	// byte[] blues = new byte[size];
	// icm.getReds(reds);
	// icm.getGreens(greens);
	// icm.getBlues(blues);
	//
	// WritableRaster raster=indexedImage.getRaster();
	// int pixel = raster.getSample(0, 0, 0);
	// IndexColorModel icm2 = new IndexColorModel(8, size, reds, greens,
	// blues,pixel);
	// indexedImage=new BufferedImage(icm2,
	// raster,sourceBufferedImage.isAlphaPremultiplied(), null);
	// indexedImage.getGraphics().drawImage(sourceBufferedImage, 0, 0, null);
	// return indexedImage;
	// }
}

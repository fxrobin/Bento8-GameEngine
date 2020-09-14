package fr.bento8.to8.build;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.regex.Pattern;

import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.core.config.Configurator;

import fr.bento8.to8.boot.Bootloader;
import fr.bento8.to8.compiledSprite.AssemblyGenerator;
import fr.bento8.to8.disk.FdUtil;
import fr.bento8.to8.image.PngToBottomUpBinB16;
import fr.bento8.to8.image.SpriteSheet;
import fr.bento8.to8.util.C6809Util;
import fr.bento8.to8.util.FileUtil;
import fr.bento8.to8.util.knapsack.Item;
import fr.bento8.to8.util.knapsack.Knapsack;
import fr.bento8.to8.util.knapsack.Solution;

public class BuildDisk
{
	private static final Logger logger = LogManager.getLogger("log");

	private static String binTmpFile = "TMP.BIN";
	private static String bootFile;
	private static String mainFile;
	private static String outputFileName;
	private static String debugMode;
	public  static String tmpDirName;
	public  static String compiler;
	private static String animationPalette;
	private static String animationPaletteTag;
	private static String animationTag;
	private static String memoryPages;
	private static int[] pages;
	private static HashMap<String, String[]> animationImages;
	private static HashMap<String, String[]> animationScripts;
	private static String initVideoFile;

	/**
	 * Génère une image de disquette dans les formats .fd et .sd pour 
	 * l'ordinateur Thomson TO8.
	 * L'image de disquette contient un secteur d'amorçage et le code
	 * principal qui sera chargé en mémoire par le code d'amorçage.
	 * Ce programme n'utilise donc pas de système de fichier.
	 * 
	 * Plan d'adressage d'une disquette Thomson TO8 ou format .fd (655360 octets ou 640kiB)
	 * Identifiant des faces: 0-1
	 * Pour chaque face, identifiant des pistes: 0-79
	 * Pour chaque piste, identifiant des secteurs: 1-16
	 * Taille d'un secteur: 256 octets
	 * face=0 piste=0 secteur=1 : octets=0 à 127 (Secteur d'amorçage)
	 * face=0 piste=0 secteur=2 : octets=256 à 16383 (Main ASM)
	 * face=0 piste=4 secteur=1 : octets=16384 à 32767 (init video)
	 * face=0 piste=8 secteur=1 : octets=32768 à x (Pages)
	 * 
	 * Le format .sd (1310720 octets ou 1,25MiB) reprend la même structure que le format .fd mais ajoute
	 * 256 octets à la fin de chaque secteur avec la valeur FF
	 * 
	 * Remarque il est posible dans un fichier .fd ou .sd de concaténer deux disquettes
	 * Cette fonctionnalité n'est pas implémentée ici.
	 * 
	 * 	Mode graphique utilisé: 160x200 (seize couleurs sans contraintes)
	 * 
	 * @param args nom du fichier properties contenant les données de configuration
	 * @throws Exception 
	 */
	public static void main(String[] args) throws Exception
	{
		int face=0, track=0, sector=1;
		byte[] binary;

		try {
			// Chargement du fichier de configuration
			logger.info("Lecture du fichier de configuration: "+args[0]);
			readProperties(args[0]);

			if (debugMode.contentEquals("Y")) {
				Configurator.setAllLevels(LogManager.getRootLogger().getName(), Level.DEBUG);
			}

			// Initialisation de l'image de disquette en sortie
			FdUtil fd = new FdUtil();

			// Compilation du code d'initialisation (boot)
			// *******************************************
			
			if (compile(bootFile) == 0) {

				// Traitement du binaire issu de la compilation et génération du secteur d'amorçage
				Bootloader bootLoader = new Bootloader();
				byte[] bootLoaderBytes = bootLoader.encodeBootLoader(binTmpFile);

				fd.setIndex(0, 0, 1);
				fd.write(bootLoaderBytes);
				
				// Traitement de l'image pour l'écran de démarrage
				// ***********************************************

				PngToBottomUpBinB16 initVideo = new PngToBottomUpBinB16(initVideoFile);
				byte[] initVideoBIN = initVideo.getBIN();

				fd.setIndex(0, 4, 1);
				fd.write(initVideoBIN);

				// Génération des sprites compilés et organisation en pages de 16Ko par l'algorithme du sac à dos
				// **********************************************************************************************
				
				// Map contenant tous les planches de sprites
				HashMap<String, SpriteSheet> spriteSheets = new HashMap<String, SpriteSheet>();
				
				// List contenant toutes les images distinctes utilisées dans les scripts d'animation
				List<String> singleImages = new ArrayList<String>();
				
				String key;
				String[] imageParam;
				int nbAllSubImages=0;
				
				// Parcours de toutes les animations à la recherche des planches utilisées
				for (String[] scriptLine : animationScripts.values())
				{
					// Debut des références images en index 3 dans le script d'animation
					for (int i = 3; !scriptLine[i].contentEquals("GO") && !scriptLine[i].contentEquals("RET"); i++) {
						
						// Charge toutes les planches utiles
						key = scriptLine[i].split(":")[0];
						if (!spriteSheets.containsKey(key)) {
							imageParam = animationImages.get(key);
							
							// Paramètres : tag, fichier, nombre d'images, flip
							spriteSheets.put(key, new SpriteSheet(imageParam[0], imageParam[1], Integer.parseInt(imageParam[2]), imageParam[3]));
						}
						
						// Enregistre et compte le nombre total d'images distinctes utilisées
						if (!singleImages.contains(scriptLine[i])) {
							singleImages.add(scriptLine[i]);
							nbAllSubImages++;
						}
					}
				}
				
				// Map contenant l'ensemble du code ASM pour chaque image
				HashMap<String, AssemblyGenerator> asmImages = new HashMap<String, AssemblyGenerator>();
				AssemblyGenerator asm;
				
				// Initialise un item pour chaque image utile
				Item[] items = new Item[nbAllSubImages];
				int itemIdx = 0;

				// première compilation de sprite pour connaitre leur taille
				for (String currentImage : singleImages) {
					
					logger.debug("**************** Génération du code ASM de l'image " + currentImage + " ****************");
					asm = new AssemblyGenerator (spriteSheets.get(currentImage.split(":")[0]), Integer.parseInt(currentImage.split(":")[1]));
					
					// Sauvegarde du code généré
					asmImages.put(currentImage, asm);
					
					logger.debug("**************** Compilation de l'image " + currentImage + " ****************");
					binary = asm.getCompiledCode("A000");
					
					// Création de l'item pour l'algo sac à dos
					items[itemIdx++] = new Item(currentImage, 1, binary.length); // id, priority, bytes

					logger.debug(currentImage+" octets: "+binary.length);
					
					// Une image compilée doit tenir sur une page de 16Ko pour pouvoir être exécutée
					if (binary.length>16384)
						logger.fatal("Image "+currentImage+" trop grande, code compilé :"+binary.length+" octets (max 16384)");
				}

				// Ecriture des sprites en pages de 16Ko sur disquette
				// ***************************************************
				face = 0; // 0-1
				track = 8; // 0-79
				sector = 1; // 1-16
				fd.setIndex(face, track, sector);
				
				int orgOffset, org = 40960; // org = A000
				int currentPageIndex = 0;
				
				// Map constenant l'ensemble des adresses d'appel a chaque image
				HashMap<String, String> imageAddress = new HashMap<String, String>();

				while (items.length>0) {

					logger.debug("**************** Page : " + pages[currentPageIndex] + " ****************");
					orgOffset = 0;

					if (currentPageIndex >= pages.length)
						logger.fatal("Plus de pages disponibles.");

					// les données sont réparties en pages en fonction de leur taille par un algorithme "sac à dos"
					Knapsack knapsack = new Knapsack(items, 16384); //Sac à dos de poids max 16Ko
					knapsack.display();
					
					Solution solution = knapsack.solve();
					solution.display();

					// Parcours de la solution
					for (Iterator<Item> iter = solution.items.listIterator(); iter.hasNext(); ) {
						Item currentItem = iter.next();

						// Pour la solution obtenue, compilation des sprites avec l'adresse mémoire cible
						System.out.println("**************** Compilation de l'image " + currentItem.name + " à l'adresse "+String.format("%1$04X",org+orgOffset)+"****************");
						asm = asmImages.get(currentItem.name);
						binary = asm.getCompiledCode(String.format("%1$04X",org+orgOffset));

						// Sauvegarde de la référence des adresses pour la construction des scripts d'animation
						imageAddress.put(currentItem.name, "\n\tFCB $" + String.format("%1$02X",pages[currentPageIndex]) +
														   "\n\tFDB $" + String.format("%1$04X",org+orgOffset) +
														   "\n\tFDB $" + asm.getEraseAddress());
						
						// Avance de l'ORG
						orgOffset += binary.length;

						// Ecriture sur disquette du sprite compilé à l'adresse cible
						fd.write(binary);

						// construit la liste des éléments restants à organiser
						for (int itemIndex=0; itemIndex<items.length; itemIndex++) {
							if (items[itemIndex].name.contentEquals(currentItem.name)) {
								Item[] newItems = new Item[items.length-1];
								for (int l=0; l<itemIndex; l++) {
									newItems[l]=items[l];
								}
								for (int j=itemIndex; j<items.length-1; j++) {
									newItems[j]=items[j+1];
								}
								items = newItems;
								break;
							}
						}
					}
					
					// Avance des curseurs de page et pointeurs sur disquette
					currentPageIndex++;
					track += 4;
					if (track > 79) {
						face += 1;
						track = 0;

						if (face>1) {
							logger.fatal("Plus d'espace dans l'image de disquette.");
						}
					}
					fd.setIndex(face, track, sector);
				}


				// Construction des scripts d'animation
				// ************************************
				
				String sAnimationScript = new String();
				for (String[] animationScript : animationScripts.values()) {
					sAnimationScript += "\n\n\tFDB $"+(animationScript[2].contentEquals("GSP") ? "01" : "00")+String.format("%1$02X", Integer.parseInt(animationScript[1]));
					sAnimationScript += "\n"+animationScript[0];

					// Debut des références images en index 3 dans le script d'animation
					for (int subImage = 3; subImage < animationScript.length; subImage++) {
						String subImageAddress = imageAddress.get(animationScript[subImage]);
						if (subImageAddress != null) {
							sAnimationScript += subImageAddress;
						} else if (animationScript[subImage].contentEquals("GO")) {
							sAnimationScript += "\n\tFCB $FF";
							subImage++;
							sAnimationScript += "\n\tFDB "+animationScript[subImage++];
							sAnimationScript += "\n\tFDB $"+String.format("%1$02X", Integer.parseInt(animationScript[subImage++]))+String.format("%1$02X", Integer.parseInt(animationScript[subImage]));
						} else {
							if (animationScript[subImage].contentEquals("RET")){
								sAnimationScript += "\n\tFCB $FE";
							} else {
								throw new Exception("Unknown image: "+animationScript[subImage]+" in animation script: "+animationScript[0]+" position: "+subImage);
							}
						}
					}
				}

				// Assemblage du fichier MAIN
				// **************************
				
				Path pathMain = Paths.get(mainFile);
				Path pathMainTmp = Paths.get("./"+tmpDirName+"/GEN-"+pathMain.getFileName().toString());
				Files.deleteIfExists(pathMainTmp);
				Charset charset = StandardCharsets.UTF_8;

				// Remplacement du TAG animation par le code généré des scripts d'animations
				String content = new String(Files.readAllBytes(pathMain), charset);
				content = content.replace(animationTag, sAnimationScript);
				
				// Remplacement du TAG palette par le code généré
				if (!spriteSheets.containsKey(animationPalette))
					logger.fatal("animationPalette: L'image "+animationPalette+" n'est pas déclarée ou n'est pas utilisée dans une animation.");
				
				content = content.replace(animationPaletteTag, spriteSheets.get(animationPalette).getCodePalette(3));
				Files.write(pathMainTmp, content.getBytes(charset));

				// Compilation du code principal
				if (compile(pathMainTmp.toString()) == 0) {
					byte[] mainBytes = Files.readAllBytes(Paths.get(binTmpFile));

					// Ecriture sur disquette
					fd.setIndex(0, 0, 2);
					fd.write(mainBytes);

					// Génération des images disquette
					fd.save(outputFileName);
					fd.saveToSd(outputFileName);

					// Affichage de l'usage mémoire
					String line = "\nUsed Pages :";
					for (int usedPagesIndex=0; usedPagesIndex<currentPageIndex; usedPagesIndex++) {
						line += pages[usedPagesIndex]+" ($"+String.format("%1$02X",pages[usedPagesIndex])+") ";
					}
					line += "("+currentPageIndex*16+"ko)\nFree Pages :";
					for (int freePagesIndex=currentPageIndex; freePagesIndex<pages.length; freePagesIndex++) {
						line += pages[freePagesIndex]+" ($"+String.format("%1$02X",pages[freePagesIndex])+") ";
					}
					line += "("+(pages.length-currentPageIndex)*16+" ko)\n";
					
					logger.debug(line);
				}
			}
		} catch (Exception e) {
			logger.fatal("Erreur lors de la lecture du fichier de configuration.", e);
		}
	}

	private static void readProperties(String file) throws Exception {
		Properties prop = new Properties();
		try {
			InputStream input = new FileInputStream(file);
			prop.load(input);
		} catch (Exception e) {
			logger.fatal("Impossible de charger le fichier de configuration: "+file, e); 
		}

		bootFile = prop.getProperty("bootfile");
		if (bootFile == null) {
			throw new Exception("Paramètre bootfile manquant dans le fichier "+file);
		}

		mainFile = prop.getProperty("mainfile");
		if (mainFile == null) {
			throw new Exception("Paramètre mainfile manquant dans le fichier "+file);
		}

		outputFileName = prop.getProperty("outputfile");
		if (outputFileName == null) {
			throw new Exception("Paramètre outputfile manquant dans le fichier "+file);
		}

		debugMode = prop.getProperty("debugmode");
		if (debugMode == null) {
			throw new Exception("Paramètre debugMode manquant dans le fichier "+file);
		}

		tmpDirName = prop.getProperty("tmpdir");
		if (tmpDirName == null) {
			throw new Exception("Paramètre tmpdir manquant dans le fichier "+file);
		}
		tmpDirName = tmpDirName.replace("^./", ""); // Bug fix c6809

		binTmpFile = tmpDirName + "/" + binTmpFile;

		compiler = prop.getProperty("compiler");
		if (compiler == null) {
			throw new Exception("Paramètre compiler manquant dans le fichier "+file);
		}

		memoryPages = prop.getProperty("memorypages");
		if (memoryPages == null) {
			throw new Exception("Paramètre memorypages manquant dans le fichier "+file);
		}

		String[] el = memoryPages.split(";");
		pages = new int[el.length];
		for (int i=0;i<el.length;i++) {
			pages[i]=Integer.parseInt(el[i]);
		}
		
		animationTag  = prop.getProperty("animation.tag");
		if (animationTag == null) {
			throw new Exception("Paramètre animation.tag manquant dans le fichier "+file);
		}

		animationImages = getPropertyList(prop, "animation.image");
		if (animationImages.isEmpty()) {
			throw new Exception("Paramètre animation.image.x manquant dans le fichier "+file);
		}
		
		animationPalette  = prop.getProperty("animation.palette");
		if (animationPalette == null) {
			throw new Exception("Paramètre animation.palette manquant dans le fichier "+file);
		}
		
		animationPaletteTag  = prop.getProperty("animation.palette.tag");
		if (animationPaletteTag == null) {
			throw new Exception("Paramètre animation.palette.tag manquant dans le fichier "+file);
		}

		animationScripts = getPropertyList(prop, "animation.script");
		if (animationScripts.isEmpty()) {
			throw new Exception("Paramètre animation.script.x manquant dans le fichier "+file);
		}

		initVideoFile = prop.getProperty("init.video");
		if (initVideoFile == null) {
			throw new Exception("Paramètre init.video manquant dans le fichier "+file);
		}
	}

	/**
	 * Effectue la compilation du code assembleur
	 * 
	 * @param asmFile fichier contenant le code assembleur a compiler
	 * @return
	 */
	private static int compile(String asmFile) {
		try {
			// Purge des fichiers temporaires
			Files.deleteIfExists(Paths.get(binTmpFile));
			Files.deleteIfExists(Paths.get("codes.lst"));

			// Lancement de la compilation du fichier contenant le code de boot
			System.out.println("**************** COMPILE "+asmFile+" ****************");
			// l'option -bd permet la génération d'un binaire brut (sans entête)
			Process p = new ProcessBuilder(compiler, "-bd", Paths.get(asmFile).toString(), Paths.get(binTmpFile).toString()).start();
			BufferedReader br=new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;

			while((line=br.readLine())!=null){
				System.out.println(line);
			}

			int result = p.waitFor();

			// Purge et remplacement de l'ancien fichier lst
			File f = new File("codes.lst"); 
			String basename = FileUtil.removeExtension(Paths.get(asmFile).getFileName().toString());
			String destFileName = "./"+tmpDirName+"/"+basename+".lst";
			Path lstFile = Paths.get(destFileName);
			Files.deleteIfExists(lstFile);

			File newFile = new File(destFileName);
			f.renameTo(newFile);
			logger.debug(destFileName + " c6809.exe cycles: " + C6809Util.countCycle(newFile.getAbsoluteFile().toString()));

			return result;

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e); 
			return -1;
		}
	}

	/**
	 * Effectue le chargement d'une liste de propriétés de type key.1, key.2, ...
	 * 
	 * @param Properties propriétés, String nom de la propriété
	 * @return HashMap<String, String[]> La liste des valeurs pour la propriété
	 */
	public static HashMap<String, String[]> getPropertyList(Properties properties, String name) 
	{
		List<String> lignes = new ArrayList<String>();
		HashMap<String, String[]> result = new HashMap<String, String[]>();
		String[] splitedLine;

		for (Entry<Object, Object> entry : properties.entrySet())
		{
			if (((String)entry.getKey()).matches("^" + Pattern.quote(name) + "\\.\\d+$"))
			{
				lignes.add((String) entry.getValue());
			}
		}

		for (String line : lignes)
		{
			splitedLine = line.split(";");
			result.put(splitedLine[0], splitedLine);
		}

		return result;
	}
}

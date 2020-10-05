package fr.bento8.to8.build;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
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
import org.apache.logging.log4j.core.LoggerContext;
import org.apache.logging.log4j.core.config.Configuration;
import org.apache.logging.log4j.core.config.Configurator;
import org.apache.logging.log4j.core.config.LoggerConfig;

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

	private static boolean debug;
	private static boolean logtodisplay;
	private static String bootFile;
	private static String exomizerFile;
	private static String mainFile;
	private static String outputFileName;
	public  static String genDirName;
	public  static String compiler;
	public  static String exomizer;
	private static int[] memoryPages;
	private static List<String> levelOrder;
	private static HashMap<String, String[]> level;
	public static boolean useCache;
	public  static int maxTries;

	private static String binTmpFile = "TMP.BIN";
	private static String lstTmpFile = "codes.lst";

	//	private static String animationPalette;
	//	private static double animationPaletteGamma;
	//	private static String animationPaletteTag;
	//	private static String animationTag;
	//	private static HashMap<String, String[]> animationImages;
	//	private static HashMap<String, String[]> animationScripts;
	//	private static String initVideoFile;

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
	 * face=0 piste=4 secteur=1 : octets=16384 à x (Pages)
	 * 
	 * Le format .sd (1310720 octets ou 1,25MiB) reprend la même structure que le format .fd mais ajoute
	 * 256 octets à la fin de chaque secteur avec la valeur FF
	 * 
	 * Remarque il est posible dans un fichier .fd ou .sd de concaténer deux disquettes
	 * Cette fonctionnalité n'est pas implémentée ici.
	 * 
	 * Mode graphique utilisé: 160x200 (seize couleurs sans contraintes)
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

			if (debug) {
				Configurator.setAllLevels(LogManager.getRootLogger().getName(), Level.DEBUG);
			}

			LoggerContext context = LoggerContext.getContext(false);
			Configuration configuration = context.getConfiguration();
			LoggerConfig loggerConfig = configuration.getLoggerConfig(LogManager.getRootLogger().getName());

			if (!logtodisplay) {
				loggerConfig.removeAppender("LogToConsole");
				context.updateLoggers();
			}

			// Initialisation de l'image de disquette en sortie
			FdUtil fd = new FdUtil();

			// Traitement de l'image pour l'écran de démarrage
			// ***********************************************

			//				PngToBottomUpBinB16 initVideo = new PngToBottomUpBinB16(initVideoFile);
			//				byte[] initVideoBIN = initVideo.getBIN();
			//
			//				fd.setIndex(0, 4, 1);
			//				fd.write(initVideoBIN);

			//				// Génération des sprites compilés et organisation en pages de 16Ko par l'algorithme du sac à dos
			//				// **********************************************************************************************
			//				
			//				// Map contenant tous les planches de sprites
			//				HashMap<String, SpriteSheet> spriteSheets = new HashMap<String, SpriteSheet>();
			//				
			//				// List contenant toutes les images distinctes utilisées dans les scripts d'animation
			//				List<String> singleImages = new ArrayList<String>();
			//				
			//				String key;
			//				String[] imageParam;
			//				int nbAllSubImages=0;
			//				
			//				// Parcours de toutes les animations à la recherche des planches utilisées
			//				for (String[] scriptLine : animationScripts.values())
			//				{
			//					// Debut des références images en index 3 dans le script d'animation
			//					for (int i = 3; !scriptLine[i].contentEquals("GO") && !scriptLine[i].contentEquals("RET"); i++) {
			//						
			//						// Charge toutes les planches utiles
			//						key = scriptLine[i].split(":")[0];
			//						if (!spriteSheets.containsKey(key)) {
			//							imageParam = animationImages.get(key);
			//							
			//							// Paramètres : tag, fichier, nombre d'images, flip
			//							spriteSheets.put(key, new SpriteSheet(imageParam[0], imageParam[1], Integer.parseInt(imageParam[2]), imageParam[3]));
			//						}
			//						
			//						// Enregistre et compte le nombre total d'images distinctes utilisées
			//						if (!singleImages.contains(scriptLine[i])) {
			//							singleImages.add(scriptLine[i]);
			//							nbAllSubImages++;
			//						}
			//					}
			//				}
			//				
			//				// Map contenant l'ensemble du code ASM pour chaque image
			//				HashMap<String, AssemblyGenerator> asmImages = new HashMap<String, AssemblyGenerator>();
			//				AssemblyGenerator asm;
			//				
			//				// Initialise un item pour chaque image utile
			//				Item[] items = new Item[nbAllSubImages];
			//				int itemIdx = 0;
			//				int binaryLength = 0;
			//
			//				// génération du sprite compilé
			//				for (String currentImage : singleImages) {
			//					
			//					logger.debug("**************** Génération du code ASM de l'image " + currentImage + " ****************");
			//					asm = new AssemblyGenerator (spriteSheets.get(currentImage.split(":")[0]), Integer.parseInt(currentImage.split(":")[1]));
			//					
			//					// Sauvegarde du code généré
			//					asmImages.put(currentImage, asm);
			//					
			//					// Calcul de la taille du binaire a partir du code ASM
			//					binaryLength = asm.getSize();
			//					
			//					// Création de l'item pour l'algo sac à dos
			//					items[itemIdx++] = new Item(currentImage, 1, binaryLength); // id, priority, bytes
			//
			//					logger.debug(currentImage+" octets: "+binaryLength);
			//					
			//					// Une image compilée doit tenir sur une page de 16Ko pour pouvoir être exécutée
			//					if (binaryLength>16384)
			//						logger.fatal("Image "+currentImage+" trop grande, code compilé :"+binaryLength+" octets (max 16384)");
			//				}
			//
			//				// Ecriture des sprites en pages de 16Ko sur disquette
			//				// ***************************************************
			//				face = 0; // 0-1
			//				track = 8; // 0-79
			//				sector = 1; // 1-16
			//				fd.setIndex(face, track, sector);
			//				
			//				int orgOffset, org = 40960; // org = A000
			//				int currentPageIndex = 0;
			//				
			//				// Map constenant l'ensemble des adresses d'appel a chaque image
			//				HashMap<String, String> imageAddress = new HashMap<String, String>();
			//
			//				while (items.length>0) {
			//
			//					logger.debug("**************** Page : " + memoryPages[currentPageIndex] + " ****************");
			//					orgOffset = 0;
			//
			//					if (currentPageIndex >= memoryPages.length)
			//						logger.fatal("Plus de pages disponibles.");
			//
			//					// les données sont réparties en pages en fonction de leur taille par un algorithme "sac à dos"
			//					Knapsack knapsack = new Knapsack(items, 16384); //Sac à dos de poids max 16Ko
			//					knapsack.display();
			//					
			//					Solution solution = knapsack.solve();
			//					solution.display();
			//
			//					// Parcours de la solution
			//					for (Iterator<Item> iter = solution.items.listIterator(); iter.hasNext(); ) {
			//						Item currentItem = iter.next();
			//
			//						// Pour la solution obtenue, compilation des sprites avec l'adresse mémoire cible
			//						logger.debug("**************** Compilation de l'image " + currentItem.name + " à l'adresse "+String.format("%1$04X",org+orgOffset)+"****************");
			//						asm = asmImages.get(currentItem.name);
			//						binary = asm.getCompiledCode(String.format("%1$04X",org+orgOffset));
			//
			//						// Sauvegarde de la référence des adresses pour la construction des scripts d'animation
			//						imageAddress.put(currentItem.name, "\n\tFCB $" + String.format("%1$02X",memoryPages[currentPageIndex]) +
			//														   "\n\tFDB $" + String.format("%1$04X",org+orgOffset) +
			//														   "\n\tFDB $" + asm.getEraseAddress());
			//						
			//						// Avance de l'ORG
			//						orgOffset += binary.length;
			//
			//						// Ecriture sur disquette du sprite compilé à l'adresse cible
			//						fd.write(binary);
			//
			//						// construit la liste des éléments restants à organiser
			//						for (int itemIndex=0; itemIndex<items.length; itemIndex++) {
			//							if (items[itemIndex].name.contentEquals(currentItem.name)) {
			//								Item[] newItems = new Item[items.length-1];
			//								for (int l=0; l<itemIndex; l++) {
			//									newItems[l]=items[l];
			//								}
			//								for (int j=itemIndex; j<items.length-1; j++) {
			//									newItems[j]=items[j+1];
			//								}
			//								items = newItems;
			//								break;
			//							}
			//						}
			//					}
			//					
			//					// Avance des curseurs de page et pointeurs sur disquette
			//					currentPageIndex++;
			//					track += 4;
			//					if (track > 79) {
			//						face += 1;
			//						track = 0;
			//
			//						if (face>1) {
			//							logger.fatal("Plus d'espace dans l'image de disquette.");
			//						}
			//					}
			//					fd.setIndex(face, track, sector);
			//				}
			//
			//
			//				// Construction des scripts d'animation
			//				// ************************************
			//				
			//				String sAnimationScript = new String();
			//				for (String[] animationScript : animationScripts.values()) {
			//					sAnimationScript += "\n\n\tFDB $"+(animationScript[2].contentEquals("GSP") ? "01" : "00")+String.format("%1$02X", Integer.parseInt(animationScript[1]));
			//					sAnimationScript += "\n"+animationScript[0];
			//
			//					// Debut des références images en index 3 dans le script d'animation
			//					for (int subImage = 3; subImage < animationScript.length; subImage++) {
			//						String subImageAddress = imageAddress.get(animationScript[subImage]);
			//						if (subImageAddress != null) {
			//							sAnimationScript += subImageAddress;
			//						} else if (animationScript[subImage].contentEquals("GO")) {
			//							sAnimationScript += "\n\tFCB $FF";
			//							subImage++;
			//							sAnimationScript += "\n\tFDB "+animationScript[subImage++];
			//							sAnimationScript += "\n\tFDB $"+String.format("%1$02X", Integer.parseInt(animationScript[subImage++]))+String.format("%1$02X", Integer.parseInt(animationScript[subImage]));
			//						} else {
			//							if (animationScript[subImage].contentEquals("RET")){
			//								sAnimationScript += "\n\tFCB $FE";
			//							} else {
			//								throw new Exception("Unknown image: "+animationScript[subImage]+" in animation script: "+animationScript[0]+" position: "+subImage);
			//							}
			//						}
			//					}
			//				}

			// Assemblage du fichier MAIN
			// **************************

			//				Path pathMain = Paths.get(mainFile);
			//				Path pathMainTmp = Paths.get(genDirName+"/"+pathMain.getFileName().toString());
			//				Files.deleteIfExists(pathMainTmp);
			//				Charset charset = StandardCharsets.UTF_8;

			//				// Remplacement du TAG animation par le code généré des scripts d'animations
			//				String content = new String(Files.readAllBytes(pathMain), charset);
			//				content = content.replace(animationTag, sAnimationScript);
			//				
			//				// Remplacement du TAG palette par le code généré
			//				if (!spriteSheets.containsKey(animationPalette))
			//					logger.fatal("animationPalette: L'image "+animationPalette+" n'est pas déclarée ou n'est pas utilisée dans une animation.");
			//				
			//				content = content.replace(animationPaletteTag, spriteSheets.get(animationPalette).getCodePalette(animationPaletteGamma));
			//				Files.write(pathMainTmp, content.getBytes(charset));

			// Compilation du code principal
			compileLIN(mainFile);
			byte[] mainBINBytes = Files.readAllBytes(Paths.get(getBINFileName(mainFile)));
			int mainBINSize = mainBINBytes.length-10;
			
			if (mainBINSize > 15360) {
				throw new Exception("Le fichier Main est trop volumineux:"+mainBINSize+" octets (max:15360 va jusqu'en 9F00, avec une pile de 256 octets 9F00-9FFF)");
			}
			
			exomize(getBINFileName(mainFile));
			byte[] mainEXOBytes = Files.readAllBytes(Paths.get(getEXOFileName(mainFile)));
			int mainEXOSize = mainEXOBytes.length;
			
			// Ecriture sur disquette
			fd.setIndex(0, 0, 2);
			fd.write(mainEXOBytes);
			
			// Complément du code exomizer avec paramètres d'init pour le décodage du MAIN
			
	        int uReg = 40960 + mainEXOSize; //A000
	        int yReg = 25344 + mainBINSize; //6300  
	        
	        String exomizerTmpFile = duplicateFile(exomizerFile);
	        replaceTag(exomizerTmpFile, "<SOURCE>", String.format("%1$04X", uReg));
	        replaceTag(exomizerTmpFile, "<DESTINATION>", String.format("%1$04X", yReg));

			// Compilation du code de décodage exomizer
			compileLIN(exomizerTmpFile);
			byte[] exoBytes = Files.readAllBytes(Paths.get(getBINFileName(exomizerTmpFile)));

			// Ecriture sur disquette
			fd.setIndex(0, 0, 3); // TODO poser le bon index en fonction de l'ecriture du main
			fd.write(exoBytes, 5, exoBytes.length-10); // On ne recopie pas le header et trailer

			// Compilation du code d'initialisation (boot)
			// *******************************************

	        String bootTmpFile = duplicateFile(bootFile);
	        replaceTag(bootTmpFile, "<DERNIER_BLOC>", String.format("%1$02X", uReg >> 8));
			
			compileRAW(bootTmpFile);

			// Traitement du binaire issu de la compilation et génération du secteur d'amorçage
			Bootloader bootLoader = new Bootloader();
			byte[] bootLoaderBytes = bootLoader.encodeBootLoader(getBINFileName(bootTmpFile));

			fd.setIndex(0, 0, 1);
			fd.write(bootLoaderBytes);
			
			// Génération des images disquette
			fd.save(outputFileName);
			fd.saveToSd(outputFileName);

			// Affichage de l'usage mémoire
			//					String line = "\nUsed Pages :";
			//					for (int usedPagesIndex=0; usedPagesIndex<currentPageIndex; usedPagesIndex++) {
			//						line += memoryPages[usedPagesIndex]+" ($"+String.format("%1$02X",memoryPages[usedPagesIndex])+") ";
			//					}
			//					line += "("+currentPageIndex*16+"ko)\nFree Pages :";
			//					for (int freePagesIndex=currentPageIndex; freePagesIndex<memoryPages.length; freePagesIndex++) {
			//						line += memoryPages[freePagesIndex]+" ($"+String.format("%1$02X",memoryPages[freePagesIndex])+") ";
			//					}
			//					line += "("+(memoryPages.length-currentPageIndex)*16+" ko)\n";

			//					logger.debug(line);

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

		if (prop.getProperty("debug") == null) {
			throw new Exception("Paramètre debug manquant dans le fichier "+file);
		}
		debug = (prop.getProperty("debug").contentEquals("Y")?true:false);

		if (prop.getProperty("logtodisplay") == null) {
			throw new Exception("Paramètre logtodisplay manquant dans le fichier "+file);
		}
		logtodisplay = (prop.getProperty("logtodisplay").contentEquals("Y")?true:false);

		bootFile = prop.getProperty("file.boot");
		if (bootFile == null) {
			throw new Exception("Paramètre file.boot manquant dans le fichier "+file);
		}

		exomizerFile = prop.getProperty("file.exomizer");
		if (exomizerFile == null) {
			throw new Exception("Paramètre file.exomizer manquant dans le fichier "+file);
		}

		mainFile = prop.getProperty("file.main");
		if (mainFile == null) {
			throw new Exception("Paramètre file.main manquant dans le fichier "+file);
		}

		outputFileName = prop.getProperty("file.output");
		if (outputFileName == null) {
			throw new Exception("Paramètre file.output manquant dans le fichier "+file);
		}

		genDirName = prop.getProperty("dir.gen");
		if (genDirName == null) {
			throw new Exception("Paramètre dir.gen manquant dans le fichier "+file);
		}
		binTmpFile = genDirName + "/" + binTmpFile;

		compiler = prop.getProperty("compiler");
		if (compiler == null) {
			throw new Exception("Paramètre compiler manquant dans le fichier "+file);
		}

		exomizer = prop.getProperty("compressor");
		if (exomizer == null) {
			throw new Exception("Paramètre compressor manquant dans le fichier "+file);
		}

		if (prop.getProperty("memorypages") == null) {
			throw new Exception("Paramètre memorypages manquant dans le fichier "+file);
		}

		String[] el = prop.getProperty("memorypages").split(";");
		memoryPages = new int[el.length];
		for (int i=0;i<el.length;i++) {
			memoryPages[i]=Integer.parseInt(el[i]);
		}

		if (prop.getProperty("level.order") == null) {
			throw new Exception("Paramètre level.order manquant dans le fichier "+file);
		}

		el = prop.getProperty("level.order").split(";");
		levelOrder = new ArrayList<String>();
		for (int i=0;i<el.length;i++) {
			levelOrder.add(el[i]);
		}

		level = getPropertyList(prop, "level");
		if (level == null) {
			throw new Exception("Paramètre level manquant dans le fichier "+file);
		}

		if (prop.getProperty("compilatedsprite.maxtries") == null) {
			throw new Exception("Paramètre compilatedsprite.maxtries manquant dans le fichier "+file);
		}
		maxTries = Integer.parseInt(prop.getProperty("compilatedsprite.maxtries"));

		if (prop.getProperty("compilatedsprite.usecache") == null) {
			throw new Exception("Paramètre compilatedsprite.usecache manquant dans le fichier "+file);
		}
		useCache = (prop.getProperty("compilatedsprite.usecache").contentEquals("Y")?true:false);

		//		animationTag  = prop.getProperty("animation.tag");
		//		if (animationTag == null) {
		//			throw new Exception("Paramètre animation.tag manquant dans le fichier "+file);
		//		}
		//
		//		animationImages = getPropertyList(prop, "animation.image");
		//		if (animationImages.isEmpty()) {
		//			throw new Exception("Paramètre animation.image.x manquant dans le fichier "+file);
		//		}
		//		
		//		animationPalette  = prop.getProperty("animation.palette");
		//		if (animationPalette == null) {
		//			throw new Exception("Paramètre animation.palette manquant dans le fichier "+file);
		//		}
		//		
		//		if (prop.getProperty("animation.palette.gamma") == null) {
		//			throw new Exception("Paramètre animation.palette.gamma manquant dans le fichier "+file);
		//		}
		//		animationPaletteGamma  = Double.parseDouble(prop.getProperty("animation.palette.gamma"));
		//		
		//		animationPaletteTag  = prop.getProperty("animation.palette.tag");
		//		if (animationPaletteTag == null) {
		//			throw new Exception("Paramètre animation.palette.tag manquant dans le fichier "+file);
		//		}
		//
		//		animationScripts = getPropertyList(prop, "animation.script");
		//		if (animationScripts.isEmpty()) {
		//			throw new Exception("Paramètre animation.script.x manquant dans le fichier "+file);
		//		}
		//
		//		initVideoFile = prop.getProperty("init.video");
		//		if (initVideoFile == null) {
		//			throw new Exception("Paramètre init.video manquant dans le fichier "+file);
		//		}
	}

	/**
	 * Effectue la compilation du code assembleur
	 * 
	 * @param asmFile fichier contenant le code assembleur a compiler
	 * @return
	 */
	private static int compileRAW(String asmFile) {
		try {
			// Purge des fichiers temporaires
			Files.deleteIfExists(Paths.get(binTmpFile));
			Files.deleteIfExists(Paths.get(lstTmpFile));

			// Lancement de la compilation du fichier contenant le code de boot
			logger.debug("**************** COMPILE "+asmFile+" ****************");
			Process p = new ProcessBuilder(compiler, "-bd", Paths.get(asmFile).toString(), Paths.get(binTmpFile).toString()).start();
			BufferedReader br=new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;

			while((line=br.readLine())!=null){
				logger.debug(line);
			}

			// c6809.exe bugfix: retour du processus vaut 0 même en cas d'erreur
			// de compilation, on lit le lst pour compter les erreurs
			p.waitFor();
			int result = C6809Util.countErrors(lstTmpFile);

			if (result == 0) {
				// Purge et remplacement de l'ancien fichier lst
				File lstFile = new File(lstTmpFile); 
				String basename = FileUtil.removeExtension(Paths.get(asmFile).getFileName().toString());
				String destFileName = genDirName+"/"+basename+".lst";
				Path lstFilePath = Paths.get(destFileName);
				Files.deleteIfExists(lstFilePath);
				File newLstFile = new File(destFileName);
				lstFile.renameTo(newLstFile);

				// Purge et remplacement de l'ancien fichier lst
				File binFile = new File(binTmpFile); 
				basename = FileUtil.removeExtension(Paths.get(asmFile).getFileName().toString());
				destFileName = genDirName+"/"+basename+".BIN";
				Path binFilePath = Paths.get(destFileName);
				Files.deleteIfExists(binFilePath);
				File newBinFile = new File(destFileName);
				binFile.renameTo(newBinFile);

				logger.debug(destFileName + " cycles: " + C6809Util.countCycles(newLstFile.getAbsoluteFile().toString()) + " BIN size: " + newBinFile.length());
			} else {
				throw new Exception ("Erreur de compilation "+asmFile);
			}

			return result;

		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(e); 
			return -1;
		}
	}

	/**
	 * Effectue la compilation du code assembleur
	 * 
	 * @param asmFile fichier contenant le code assembleur a compiler
	 * @return
	 */
	private static int compileLIN(String asmFile) {
		try {
			// Purge des fichiers temporaires
			Files.deleteIfExists(Paths.get(binTmpFile));
			Files.deleteIfExists(Paths.get(lstTmpFile));

			// Lancement de la compilation du fichier contenant le code de boot
			logger.debug("**************** COMPILE "+asmFile+" ****************");
			Process p = new ProcessBuilder(compiler, "-bl", Paths.get(asmFile).toString(), Paths.get(binTmpFile).toString()).start();
			BufferedReader br=new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;

			while((line=br.readLine())!=null){
				logger.debug(line);
			}

			// c6809.exe bugfix: retour du processus vaut 0 même en cas d'erreur
			// de compilation, on lit le lst pour compter les erreurs
			p.waitFor();
			int result = C6809Util.countErrors(lstTmpFile);

			if (result == 0) {
				// Purge et remplacement de l'ancien fichier lst
				File lstFile = new File(lstTmpFile); 
				String basename = FileUtil.removeExtension(Paths.get(asmFile).getFileName().toString());
				String destFileName = genDirName+"/"+basename+".lst";
				Path lstFilePath = Paths.get(destFileName);
				Files.deleteIfExists(lstFilePath);
				File newLstFile = new File(destFileName);
				lstFile.renameTo(newLstFile);

				// Purge et remplacement de l'ancien fichier lst
				File binFile = new File(binTmpFile); 
				basename = FileUtil.removeExtension(Paths.get(asmFile).getFileName().toString());
				destFileName = genDirName+"/"+basename+".BIN";
				Path binFilePath = Paths.get(destFileName);
				Files.deleteIfExists(binFilePath);
				File newBinFile = new File(destFileName);
				binFile.renameTo(newBinFile);

				logger.debug(destFileName + " cycles: " + C6809Util.countCycles(newLstFile.getAbsoluteFile().toString()) + " BIN size: " + newBinFile.length());
			} else {
				throw new Exception ("Erreur de compilation "+asmFile);
			}

			return result;

		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(e); 
			return -1;
		}
	}

	/**
	 * Effectue la compression du code assembleur
	 * 
	 * @param binFile fichier contenant le code assembleur a compiler
	 * @return
	 */
	private static int exomize(String binFile) {
		try {
			String basename = FileUtil.removeExtension(Paths.get(binFile).getFileName().toString());
			String destFileName = genDirName+"/"+basename+".EXO";

			// Purge des fichiers temporaires
			Files.deleteIfExists(Paths.get(destFileName));

			// Lancement de la compilation du fichier contenant le code de boot
			logger.debug("**************** EXOMIZE "+binFile+" ****************");
			Process p = new ProcessBuilder(exomizer, "", Paths.get(binFile).toString()).start();
			BufferedReader br=new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;

			while((line=br.readLine())!=null){
				logger.debug(line);
			}

			if (p.waitFor() != 0) {
				throw new Exception ("Erreur de compilation "+binFile);
			}
			return 0;

		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(e); 
			return -1;
		}
	}
	
	public static void replaceTag(String fileName, String tag, String value) throws IOException {
        Path path = Paths.get(fileName);
        Charset charset = StandardCharsets.ISO_8859_1;

        String content = new String(Files.readAllBytes(path), charset);
        content = content.replaceAll(tag, value);
        Files.write(path, content.getBytes(charset));
	}
	
	public static String duplicateFile(String fileName) throws IOException {
		String basename = FileUtil.removeExtension(Paths.get(fileName).getFileName().toString());
		String destFileName = genDirName+"/"+basename+".ASM";
		
        Path original = Paths.get(fileName);        
        Path copied = Paths.get(destFileName);
        Files.copy(original, copied, StandardCopyOption.REPLACE_EXISTING);
        return destFileName;
	}

	/**
	 * Effectue le chargement d'une liste de propriétés de type propriete=key1;xxx, propriete=key2;xxx, ...
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
			if (((String)entry.getKey()).matches("^" + Pattern.quote(name) + "$"))
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

	public static String getBINFileName (String name) {
		return genDirName+"/"+FileUtil.removeExtension(Paths.get(name).getFileName().toString())+".BIN";
	}

	public static String getEXOFileName (String name) {
		return genDirName+"/"+FileUtil.removeExtension(Paths.get(name).getFileName().toString())+".EXO";
	}
}

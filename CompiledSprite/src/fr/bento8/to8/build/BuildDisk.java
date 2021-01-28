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
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.regex.Matcher;
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
import fr.bento8.to8.disk.ImgIndex;
import fr.bento8.to8.image.PaletteTO8;
import fr.bento8.to8.image.Sprite;
import fr.bento8.to8.image.SpriteSheet;
import fr.bento8.to8.image.SubSprite;
import fr.bento8.to8.image.SubSpriteBin;
import fr.bento8.to8.util.ByteUtil;
import fr.bento8.to8.util.C6809Util;
import fr.bento8.to8.util.FileUtil;
import fr.bento8.to8.util.knapsack.Item;
import fr.bento8.to8.util.knapsack.Knapsack;
import fr.bento8.to8.util.knapsack.Solution;

public class BuildDisk
{
	private static final Logger logger = LogManager.getLogger("log");

	// Engine Loader
	private static String engineAsmBoot;
	private static String engineAsmGameMode;
	private static String engineAsmGameModeEngine;	
	private static HashMap<String, String[]> engineLoaderAsmIncludes;
	
	// Main Engines
	private static String engineAsmMainEngine;
	private static HashMap<String, HashMap<String, String[]>> engineAsmIncludes = new HashMap<String, HashMap<String, String[]>>();	

	// Game Mode
	private static String gameModeBoot;
	private static HashMap<String, String[]> gameMode; // <Game Mode name, Game Mode properties file name[0]>
	private static HashMap<String, Integer> gameModeDataSize = new HashMap<String, Integer>(); // <Game Mode name, Game Mode DataSize>	
	private static HashMap<String, HashMap<String, String[]>> gameModeObjectProperties = new HashMap<String, HashMap<String, String[]>>(); // <Game Mode name, <Object name, Object properties file name[0]>>  
	private static HashMap<String, HashMap<String, HashMap<String, String[]>>> gameModeActProperties = new HashMap<String, HashMap<String, HashMap<String, String[]>>>(); // <Game Mode name, <Act Name, <Property, values[]>>>

	// Object
	private static HashMap<String, String> allObjectCode = new HashMap<String, String>();
	private static HashMap<String, HashMap<String, String[]>> objectSprite = new HashMap<String, HashMap<String, String[]>>();
	private static HashMap<String, HashMap<String, String[]>> objectAnimation = new HashMap<String, HashMap<String, String[]>>();
	
	// Build
	public  static String c6809;
	public  static String exobin;
	private static boolean debug;
	private static boolean logToConsole;
	private static String outputDiskName;
	public  static String generatedCodeDirName;
	private static boolean memoryExtension;
	private static int nbMaxPagesRAM;
	public static boolean useCache;
	public  static int maxTries;

	private static String binTmpFile = "TMP.BIN";
	private static String lstTmpFile = "codes.lst";

	private static Charset charset = StandardCharsets.UTF_8;
	
	public static FdUtil fd;
	public static AsmSourceCode glb;
	
	public static byte[] engineAsmGameModeBytes;	
	public static byte[] mainEXOBytes;
	public static byte[] bootLoaderBytes;
	
	// Tags
	private static String tag_Globals = "GLOBALS";
	private static String tag_GmeData = "GMEDATA";
	private static String tag_Palette = "PALETTE";
	private static String tag_ObjectIndex = "OBJINDEX";
	private static String tag_ImageIndex = "IMAGEIDX";
	private static String tag_AnimationScript = "ANIMSCPT";
	private static String tag_LoadAct = "LOADACT";

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
	 * face=0 piste=0 secteur=1 : octets=0 à 256 (Secteur d'amorçage)
	 * ...
	 * 
	 * Le format .sd (1310720 octets ou 1,25MiB) reprend la même structure que le format .fd mais ajoute
	 * 256 octets à la fin de chaque secteur avec la valeur FF
	 * 
	 * Remarque il est posible dans un fichier .fd ou .sd de concaténer deux disquettes
	 * Cette fonctionnalité n'est pas (encore ;-)) implémentée ici.
	 * 
	 * Mode graphique utilisé: 160x200 (seize couleurs sans contraintes)
	 * 
	 * @param args nom du fichier properties contenant les données de configuration
	 * @throws Exception 
	 */
	public static void main(String[] args) throws Exception
	{
		try {
			logger.info("Initialisation");
			logger.info("**************************************************************************");		

			// Chargement du fichier de configuration principal
			logger.info("Chargement du fichier de configuration: "+args[0]);
			readProperties(args[0]);

			// Initialisation du logger
			if (debug) {
				Configurator.setAllLevels(LogManager.getRootLogger().getName(), Level.DEBUG);
			}

			LoggerContext context = LoggerContext.getContext(false);
			Configuration configuration = context.getConfiguration();
			LoggerConfig loggerConfig = configuration.getLoggerConfig(LogManager.getRootLogger().getName());

			if (!logToConsole) {
				loggerConfig.removeAppender("LogToConsole");
				context.updateLoggers();
			}			
			
			// Chargement des fichiers de configuration secondaires
			for (Map.Entry<String,String[]> curGameMode : gameMode.entrySet()) {
				logger.info("Chargement du fichier de configuration GameMode "+curGameMode.getKey()+" : "+curGameMode.getValue()[0]);
				readGameModeProperties(curGameMode);
			}

			// Initialisation de l'image de disquette en sortie
			fd = new FdUtil();

			// Initialisation des variables globales
			glb = new AsmSourceCode(getIncludeFilePath(tag_Globals));

			logger.info("\nCompilation du Game Mode Engine et encodage du binaire (GMENGINE)");
			logger.info("**************************************************************************");			

			String engineAsmIncludeTmpFile = duplicateFile(engineAsmGameModeEngine);
			compileRAW(engineAsmIncludeTmpFile);
			byte[] BINBytes = Files.readAllBytes(Paths.get(getBINFileName(engineAsmIncludeTmpFile)));
			String HEXValues = ByteUtil.bytesToHex(BINBytes);
			String content = "";

			// Inversion des données par bloc de 7 octets (simplifie la copie au runtime)
			for (int i = HEXValues.length()-14; i >= 0; i -= 14) {
				content += "\n        fcb   $" + HEXValues.charAt(i)    + HEXValues.charAt(i+1)  +
				                          ",$" + HEXValues.charAt(i+2)  + HEXValues.charAt(i+3)  +
				                          ",$" + HEXValues.charAt(i+4)  + HEXValues.charAt(i+5)  +
				                          ",$" + HEXValues.charAt(i+6)  + HEXValues.charAt(i+7)  +
				                          ",$" + HEXValues.charAt(i+8)  + HEXValues.charAt(i+9)  +
				                          ",$" + HEXValues.charAt(i+10) + HEXValues.charAt(i+11) +
				                          ",$" + HEXValues.charAt(i+12) + HEXValues.charAt(i+13);				                          
			}
			
			try {
				Files.write(Paths.get(engineAsmIncludeTmpFile), content.getBytes());
			} catch (IOException ioExceptionObj) {
				System.out.println("Problème à l'écriture du fichier " + engineAsmIncludeTmpFile + ": "
						+ ioExceptionObj.getMessage());
			}

			int dernierBloc = processGameModes();

			logger.info("\nCompilation du code de boot");
			logger.info("**************************************************************************");			
			
			String bootTmpFile = duplicateFile(engineAsmBoot);
			glb.addConstant("boot_dernier_bloc", String.format("$%1$02X", dernierBloc >> 8)+"00"); // On tronque l'octet de poids faible
			glb.flush();
			compileRAW(bootTmpFile);

			// Traitement du binaire issu de la compilation et génération du secteur d'amorçage
			Bootloader bootLoader = new Bootloader();
			bootLoaderBytes = bootLoader.encodeBootLoader(getBINFileName(bootTmpFile));
			
			// Ecriture disquette du boot
			fd.setIndex(0, 0, 1);
			fd.write(bootLoaderBytes);			

			logger.info("\nGénération des images de disquettes");
			logger.info("**************************************************************************");
			
			fd.save(outputDiskName);
			fd.saveToSd(outputDiskName);
			
			logger.info("\nFin du traitement.");

		} catch (Exception e) {
			logger.fatal("Erreur lors du build.", e);
		}
	}

	private static int processGameModes() throws Exception {
		
		logger.info("\nCompilation des données de Game Mode (GMEDATA)");
		logger.info("**************************************************************************");
		
		// GLOBALS - Génération des identifiants d'objets pour l'ensemble des game modes (numérotation commune)
		// ----------------------------------------------------------------------------------------------------		
		logger.info("\nGénération des identifiants objets:");
		int objIndex = 1;
		for(Entry<String, HashMap<String, String[]>> entry : gameModeObjectProperties.entrySet()) {
			for (String key : entry.getValue().keySet()) {
				if (!objectSprite.containsKey(key)) { 
					readObjectProperties(key, entry.getValue().get(key)[0]);
					glb.addConstant("ObjID_"+key, Integer.toString(objIndex++));
					logger.info("ObjID_"+key+": "+Integer.toString(objIndex++));
				}
			}
		}
		glb.flush();
		
		// GAME MODE DATA - Génération des sprites compilés pour l'ensemble des game modes
		// -------------------------------------------------------------------------------
		logger.info("\nGénération des sprites compilés:");
		
		// Map contenant l'ensemble des données pour chaque image (<SpriteTag, Sprite>)
		HashMap<String, Sprite> allSprites = new HashMap<String, Sprite>();
		List<SubSpriteBin> allSubSpriteBin = new ArrayList<SubSpriteBin>();
		AssemblyGenerator asm;
		
		// génération du sprite compilé
		String spriteFile;
		String[] flip, type;
		SubSprite curSubSprite;
		
		// Parcours de tous les objets du jeu
		for (Entry<String, HashMap<String, String[]>> object : objectSprite.entrySet()) {
			
			// Parcours des images de l'objet et compilation de l'image
			for (String spriteTag : object.getValue().keySet()) {
				
				spriteFile = object.getValue().get(spriteTag)[0];
				flip = object.getValue().get(spriteTag)[1].split(",");
				type = object.getValue().get(spriteTag)[2].split(",");
				Sprite sprite = new Sprite();
				sprite.name = spriteTag;
				
				// Parcours des modes mirroir demandés pour chaque image
				for (String curFlip : flip) {
					logger.info("\nGénération du code ASM du sprite: " + spriteTag + " image:" + spriteFile + " flip:" + curFlip);
					asm = new AssemblyGenerator(new SpriteSheet(spriteTag, spriteFile, 1, curFlip), 0);
					
					// Sauvegarde du code généré pour le mode mirroir courant
					curSubSprite = new SubSprite(sprite);
					curSubSprite.setName(curFlip);
					for (String curType : type) {
						if (curType.equals("B")) {
							logger.info("Compilation de l'image (Backup Background/Draw/Erase) ...");
							asm.compileCode("A000");

							logger.info("Exomize ...");
							curSubSprite.bckDraw = new SubSpriteBin(curSubSprite);
							curSubSprite.bckDraw.setName("bckDraw");
							curSubSprite.bckDraw.bin = exomize(asm.getBckDrawBINFile());
							curSubSprite.bckDraw.fileIndex = new ImgIndex();
							allSubSpriteBin.add(curSubSprite.bckDraw);
							
							curSubSprite.erase = new SubSpriteBin(curSubSprite);
							curSubSprite.erase.setName("erase");
							curSubSprite.erase.bin = exomize(asm.getEraseBINFile());
							curSubSprite.erase.fileIndex = new ImgIndex();
							allSubSpriteBin.add(curSubSprite.erase);
						}

						if (curType.equals("D")) {
							logger.info("Compilation de l'image (Draw) ...");
							//asm.compileDraw("A000");
							
							logger.info("Exomize ...");
							curSubSprite.draw = new SubSpriteBin(curSubSprite);
							curSubSprite.draw.setName("draw");
							curSubSprite.draw.bin = exomize(asm.getDrawBINFile());
							curSubSprite.draw.fileIndex = new ImgIndex();
							allSubSpriteBin.add(curSubSprite.draw);
						}
					}
					
					sprite.setSubSprite(curFlip, curSubSprite);
				}

				// Sauvegarde de tous les modes mirroir demandés pour l'image en cours
				allSprites.put(spriteTag, sprite);
			}
		}
		
		logger.info("\nCompilation du code Main Engine pour chaque Game Mode");
		logger.info("**************************************************************************");

		for (Map.Entry<String, String[]> curGameMode : gameMode.entrySet()) {		

			// Initialisation a vide des fichiers source générés
			AsmSourceCode asmPalette = new AsmSourceCode(getIncludeFilePath(tag_Palette, curGameMode.getKey()));
			AsmSourceCode asmObjIndex = new AsmSourceCode(getIncludeFilePath(tag_ObjectIndex, curGameMode.getKey()));
			AsmSourceCode asmImgIndex = new AsmSourceCode(getIncludeFilePath(tag_ImageIndex, curGameMode.getKey()));
			AsmSourceCode asmAnimScript = new AsmSourceCode(getIncludeFilePath(tag_AnimationScript, curGameMode.getKey()));
			AsmSourceCode asmLoadAct = new AsmSourceCode(getIncludeFilePath(tag_LoadAct, curGameMode.getKey()));
			
			asmObjIndex.addLabel("Obj_Index");
			asmObjIndex.flush();
			
			asmLoadAct.addLabel("LoadAct");
			asmLoadAct.flush();			
			
			String mainEngineTmpFile = duplicateFile(engineAsmMainEngine, curGameMode.getKey());

			compileLIN(mainEngineTmpFile, curGameMode.getKey());
			byte[] binBytes = Files.readAllBytes(Paths.get(getBINFileName(mainEngineTmpFile)));
			int binBytesSize = binBytes.length - 10;

			if (binBytesSize > 0x4000) {
				throw new Exception("Le fichier " + engineAsmMainEngine + " est trop volumineux:" + binBytesSize + " octets (max:"+0x4000+")");
			}

			exomize(getBINFileName(mainEngineTmpFile));
			mainEXOBytes = Files.readAllBytes(Paths.get(getEXOFileName(mainEngineTmpFile)));
			logger.info("Exomize : " + mainEXOBytes.length + " bytes");
			fd.write(mainEXOBytes);
		}
		
		// GAME MODE DATA - Compilation du code de chaque objet pour l'ensemble des game modes
		// -----------------------------------------------------------------------------------

		// Map contenant l'ensemble des données asm pour chaque objet
		HashMap<String, ObjectBin> allObjectBin = new HashMap<String, ObjectBin>();
				
		// for each Game Mode ?
		for (Entry<String, HashMap<String, String[]>> object : objectSprite.entrySet()) {
			ObjectBin objectCode = new ObjectBin();
			String objectCodeTmpFile = duplicateFile(allObjectCode.get(object.getKey()), object.getKey());

			compileLIN(objectCodeTmpFile);
			byte[] binBytes = Files.readAllBytes(Paths.get(getBINFileName(objectCodeTmpFile)));

			if (binBytes.length-10 > 0x4000) {
				throw new Exception("Le fichier "+objectCodeTmpFile+" est trop volumineux:"+(binBytes.length-10)+" octets (max:"+0x4000+")");
			}
			
			exomize(getBINFileName(objectCodeTmpFile));
			objectCode.setName(object.getKey());
			objectCode.bin = Files.readAllBytes(Paths.get(getEXOFileName(objectCodeTmpFile)));
			objectCode.fileIndex = new ImgIndex();
			allObjectBin.put(object.getKey(), objectCode);
		}		
		
		// Parcours des objets de tous les Game Mode pour calculer la taille de Game Mode Data
		int cur_gmd_size, gmd_size = 0;
		for (Map.Entry<String, String[]> curGameMode : gameMode.entrySet()) {
			cur_gmd_size = 0;
			for (Map.Entry<String, String[]> curObject : gameModeObjectProperties.get(curGameMode.getKey()).entrySet()) {
				
				cur_gmd_size += 7; // Object
				
				// Parcours des sprites de l'objet
				for (Entry<String, String[]> sprite : objectSprite.get(curObject.getKey()).entrySet()) {
					for (SubSpriteBin curSubSpriteBin : allSubSpriteBin) {
						if (curSubSpriteBin.parent.parent.name.equals(sprite.getKey())) {
							cur_gmd_size += 7; // Image
						}
					}
				}
			}
			cur_gmd_size += 3; // Entete +2 et Balise de fin +1
			gmd_size += cur_gmd_size;
			gameModeDataSize.put(curGameMode.getKey(), cur_gmd_size);
		}

		// GAME MODE - compilation pour connaitre la taille Game Mode + Game Mode Engine sans les DATA
		// -------------------------------------------------------------------------------------------
		
		// Nécessite d'avoir un fichier gmeData vide mais présent
		AsmSourceCode gmeData = new AsmSourceCode(getIncludeFilePath(tag_GmeData));
		
		String gameModeTmpFile = duplicateFile(engineAsmGameMode);
		compileRAW(gameModeTmpFile);
		byte[] engineAsmGameModeBytes = Files.readAllBytes(Paths.get(getBINFileName(gameModeTmpFile)));
		int gme_totalSize = engineAsmGameModeBytes.length + gmd_size;

		if (gme_totalSize > 0x4000) {
			throw new Exception("Le fichier "+engineAsmGameMode+" est trop volumineux:"+gme_totalSize+" octets (max:"+0x4000+")");
		}		
		
		// Toutes les images ont été compilées, compressées, on connait maintenant la taille des données
		// Game Mode Data, on réserve l'espace sur la disquette
		
		fd.setIndex(0, 0, 2);
		fd.setIndex(fd.getIndex() + gme_totalSize);
		
		// GAME MODE DATA - Ecriture sur disquette des images de sprite
		// ------------------------------------------------------------
		for (Entry<String, Sprite> curSprite : allSprites.entrySet()) {
			curSprite.getValue().setAllFileIndex(fd);
		}
		
		// GAME MODE DATA - Ecriture sur disquette du code des objets
		// ----------------------------------------------------------
		for (Map.Entry<String, ObjectBin> curObjectBin : allObjectBin.entrySet()) {
			allObjectBin.get(curObjectBin.getKey()).setFileIndex(fd);
		}		

		// GAME MODE DATA - Répartition des données en RAM
		// -----------------------------------------------
		
		logger.info("\nGAME MODE DATA - Répartition des données en RAM");
		logger.info("-----------------------------------------------");
		
		// Initialise un item pour chaque élément a écrire en RAM
		Item[] items = new Item[allSubSpriteBin.size()+allObjectBin.size()];
		int itemIdx = 0;

		for (SubSpriteBin curSubSpriteBin : allSubSpriteBin) {
			items[itemIdx++] = new Item(curSubSpriteBin, 1); // element, priority
		}
		
		for (Map.Entry<String, ObjectBin> curObjectBin : allObjectBin.entrySet()) {
			items[itemIdx++] = new Item(allObjectBin.get(curObjectBin.getKey()), 1); // element, priority
		}		
		
		int page = 5; // Première page disponible pour les données de Game Mode
		
		while (items.length>0) {

			int address = 0xA000; // Position dans la page

			// les données sont réparties en pages en fonction de leur taille par un algorithme "sac à dos"
			Knapsack knapsack = new Knapsack(items, 0x4000); //Sac à dos de poids max 16Ko
			knapsack.display();
			
			Solution solution = knapsack.solve();
			solution.display();
			
			logger.info("Page : " + page);

			// Parcours de la solution
			for (Iterator<Item> iter = solution.items.listIterator(); iter.hasNext(); ) {
				Item currentItem = iter.next();
				currentItem.bin.fileIndex.page = page;
				currentItem.bin.fileIndex.address = address;
				address += currentItem.bin.bin.length;

				// construit la liste des éléments restants à organiser
				for (int i=0; i<items.length; i++) {
					if (items[i].bin == currentItem.bin) {
						Item[] newItems = new Item[items.length-1];
						for (int l=0; l<i; l++) {
							newItems[l]=items[l];
						}
						for (int j=i; j<items.length-1; j++) {
							newItems[j]=items[j+1];
						}
						items = newItems;
						break;
					}
				}
			}
			logger.info("Espace libre non alloué : " + (0xDFFF - address) + " octets");			
			page++;
			if (page > nbMaxPagesRAM) {
				logger.fatal("Pas assez d'espace disponible dans la RAM !");
			}			
		}		
		
		// Génération du code source
		// ---------------------------------------------------------------------------------------				

		for (Map.Entry<String, String[]> curGameMode : gameMode.entrySet()) {
			
			logger.info("Traitement du Game Mode : " + curGameMode.getKey());
			
			// Initialisation des fichiers source générés
			AsmSourceCode asmPalette = new AsmSourceCode(getIncludeFilePath(tag_Palette, curGameMode.getKey()));
			AsmSourceCode asmObjIndex = new AsmSourceCode(getIncludeFilePath(tag_ObjectIndex, curGameMode.getKey()));
			AsmSourceCode asmImgIndex = new AsmSourceCode(getIncludeFilePath(tag_ImageIndex, curGameMode.getKey()));
			AsmSourceCode asmAnimScript = new AsmSourceCode(getIncludeFilePath(tag_AnimationScript, curGameMode.getKey()));
			AsmSourceCode asmLoadAct = new AsmSourceCode(getIncludeFilePath(tag_LoadAct, curGameMode.getKey()));	

			asmImgIndex.add("ImgMeta_size equ 14");			
			asmLoadAct.add("LoadAct");
			
			
			// GAME MODE DATA - Construction des données de chargement disquette pour chaque Game Mode
			// ---------------------------------------------------------------------------------------
			
			gmeData.addLabel("gm_" + curGameMode.getKey());
			gmeData.addFdb(new String[] { "current_game_mode_data+"+gameModeDataSize.get(curGameMode.getKey())});		
			
			// Parcours des objets du Game Mode
			for (Map.Entry<String, String[]> curObject : gameModeObjectProperties.get(curGameMode.getKey()).entrySet()) {
				
				// Parcours des sprites de l'objet				
				for (Entry<String, String[]> sprite : objectSprite.get(curObject.getKey()).entrySet()) {
					extractSubSpriteFileIndex(allSprites.get(sprite.getKey()).subSprite, gmeData, sprite.getKey());
					extractSubSpriteFileIndex(allSprites.get(sprite.getKey()).subSpriteX, gmeData, sprite.getKey()+" X");
					extractSubSpriteFileIndex(allSprites.get(sprite.getKey()).subSpriteY, gmeData, sprite.getKey()+" Y");
					extractSubSpriteFileIndex(allSprites.get(sprite.getKey()).subSpriteXY, gmeData, sprite.getKey()+" XY");
					writeImgIndex(asmImgIndex, allSprites.get(sprite.getKey()));
				}
				
				// Code de l'objet
				
			}
			
			gmeData.addFcb(new String[] { "$FF" });			
			
			// MAIN ENGINE - Construction des données palette pour chaque Acte de Game Mode
			// ----------------------------------------------------------------------------
			
			for (Map.Entry<String, HashMap<String, String[]>> curAct : gameModeActProperties.get(curGameMode.getKey()).entrySet()) {
				if (curAct.getValue().containsKey("palette")) {
					logger.info("Traitement de la palette de l'acte : " + curAct.getKey());
					asmPalette.addLabel(curAct.getValue().get("palette")[0] + " * @globals");
					asmLoadAct.add("        ldd   #"+curAct.getValue().get("palette")[0]);
					asmLoadAct.add("        std   Ptr_palette");
					asmPalette.add(PaletteTO8.getPaletteData(curAct.getValue().get("palette")[1]));
					asmPalette.flush();
				}
			}

			asmLoadAct.flush();
			

			
//	        ANIMSCPT		
			
			// Ani_TitleScreen_LargeStar
			// fcb $01 ; frame duration
			// fdb Img_2_star
			// fdb Img_3_star
			// fdb Img_4_star
			// fdb Img_3_star
			// fdb Img_2_star
			// fcb _nextSubRoutine

			// Ani_TitleScreen_SmallStar
			// fcb $03 ; frame duration
			// fdb Img_1_star
			// fdb Img_2_star
			// fcb _resetAnim				
			
			
			
			
			
			
			
			
			
			
			// MAIN ENGINE - Construction de l'index des adresses de code objet pour chaque Game Mode
			// --------------------------------------------------------------------------------------
			
			// Les objets non présents dans le Game Mode sont renseignées à 0 dans la table d'adresse
			// Les ids objets doivent être une référence commune dans tout le programme
			asmObjIndex.addLabel("Obj_Index");
			for (Map.Entry<String, String[]> curObject : gameModeObjectProperties.get(curGameMode.getKey()).entrySet()) {
				asmObjIndex.addFcb(new String[] {String.format("$%1$02X", allObjectBin.get(curObject.getKey()).fileIndex.page), String.format("$%1$02X", allObjectBin.get(curObject.getKey()).fileIndex.address >> 8), String.format("$%1$02X", allObjectBin.get(curObject.getKey()).fileIndex.address & 0x00FF)});
			}
			asmObjIndex.flush();		
	
			// Ajout du tag pour identifier le game mode de démarrage
			if (curGameMode.getKey().contentEquals(gameModeBoot)) {
				gmeData.addLabel("gmboot * @globals");
			}

			gmeData.flush();
		}		
		
		logger.info("\nCompilation du code de Game Mode (contient GMENGINE et GMEDATA)");
		logger.info("**************************************************************************");			

		gameModeTmpFile = duplicateFile(engineAsmGameMode);
		compileRAW(gameModeTmpFile);
		engineAsmGameModeBytes = Files.readAllBytes(Paths.get(getBINFileName(gameModeTmpFile)));

		if (engineAsmGameModeBytes.length > 0x4000) {
			throw new Exception("Le fichier "+engineAsmGameMode+" est trop volumineux:"+engineAsmGameModeBytes.length+" octets (max:"+0x4000+")");
		}
		
		// Ecriture sur disquette
		fd.setIndex(0, 0, 2);		
		fd.write(engineAsmGameModeBytes);		
		
		return 0xA000 + engineAsmGameModeBytes.length;
	}

	private static void extractSubSpriteFileIndex(SubSprite sub, AsmSourceCode gmeData, String spriteTag) throws Exception {
		if (sub != null) {
			processFileIndex(sub.bckDraw, gmeData, spriteTag+" BckDraw");
			processFileIndex(sub.draw, gmeData, spriteTag+" Draw");
			processFileIndex(sub.erase, gmeData, spriteTag+" Erase");
		}
	}

	private static void processFileIndex(SubSpriteBin ssBin, AsmSourceCode gmeData, String spriteTag) throws Exception {
		if (ssBin != null && ssBin.fileIndex != null) {
			String[] line = new String[7];			
			line [0] = String.format("$%1$02X", (ssBin.fileIndex.drive << 7)+ssBin.fileIndex.track);
			line [1] = String.format("$%1$02X", ssBin.fileIndex.sector);
			line [2] = String.format("$%1$02X", ssBin.fileIndex.nbSector);
			line [3] = String.format("$%1$02X", ssBin.fileIndex.endOffset);
			line [4] = String.format("$%1$02X", ssBin.fileIndex.page);			
			line [5] = String.format("$%1$02X", ssBin.fileIndex.address >> 8);			
			line [6] = String.format("$%1$02X", ssBin.fileIndex.address & 0x00FF);			
			gmeData.addFcb(line);		
			gmeData.appendComment(spriteTag);
		}
	}
	
	private static void writeImgIndex(AsmSourceCode asmImgIndex, Sprite sprite) {
		asmImgIndex.addLabel(sprite.name);
		if (sprite.subSprite != null) {
			asmImgIndex.addFcb(getImgSubSpriteIndex(sprite.subSprite));
		}
		
		if (sprite.subSpriteX != null) {
			asmImgIndex.addFcb(getImgSubSpriteIndex(sprite.subSpriteX));
		}
		
		if (sprite.subSpriteY != null) {
			asmImgIndex.addFcb(getImgSubSpriteIndex(sprite.subSpriteY));
		}
		
		if (sprite.subSpriteXY != null) {
			asmImgIndex.addFcb(getImgSubSpriteIndex(sprite.subSpriteXY));
		}
	}
	
	private static String[] getImgSubSpriteIndex(SubSprite s) {
		String[] line = new String[14];
		if (s.bckDraw != null) {
			line [0] = String.format("$%1$02X", s.bckDraw.fileIndex.page);
			line [1] = String.format("$%1$02X", s.bckDraw.fileIndex.address >> 8);		
			line [2] = String.format("$%1$02X", s.bckDraw.fileIndex.address & 0xFF);		
		} else {
			line [0] = "$00";
			line [1] = "$00";		
			line [2] = "$00";	
		}
		
		if (s.draw != null) {
			line [3] = String.format("$%1$02X", s.draw.fileIndex.page);
			line [4] = String.format("$%1$02X", s.draw.fileIndex.address >> 8);		
			line [5] = String.format("$%1$02X", s.draw.fileIndex.address & 0xFF);
		} else {
			line [3] = "$00";
			line [4] = "$00";		
			line [5] = "$00";	
		}
		
		if (s.erase != null) {
			line [6] = String.format("$%1$02X", s.erase.fileIndex.page);
			line [7] = String.format("$%1$02X", s.erase.fileIndex.address >> 8);		
			line [8] = String.format("$%1$02X", s.erase.fileIndex.address & 0xFF);
		} else {
			line [6] = "$00";
			line [7] = "$00";		
			line [8] = "$00";	
		}
		
		line [9] = String.format("$%1$02X", s.erase.fileIndex.nbCell);
		line [10] = String.format("$%1$02X", s.erase.fileIndex.xOffset);
		line [11] = String.format("$%1$02X", s.erase.fileIndex.yOffset);
		line [12] = String.format("$%1$02X", s.erase.fileIndex.xSize);
		line [13] = String.format("$%1$02X", s.erase.fileIndex.ySize);
		return line;
	}

	private static void readProperties(String file) throws Exception {
		Properties prop = new Properties();
		try {
			InputStream input = new FileInputStream(file);
			prop.load(input);
		} catch (Exception e) {
			logger.fatal("Impossible de charger le fichier de configuration: "+file, e); 
		}

		// Engine ASM source code
		// ********************************************************************

		engineAsmBoot = prop.getProperty("engine.asm.boot");
		if (engineAsmBoot == null) {
			throw new Exception("Paramètre engine.asm.boot manquant dans le fichier "+file);
		}

		engineAsmGameMode = prop.getProperty("engine.asm.gameMode");
		if (engineAsmGameMode == null) {
			throw new Exception("Paramètre engine.asm.gameMode manquant dans le fichier "+file);
		}
		
		engineAsmGameModeEngine = prop.getProperty("engine.asm.gameModeEngine");
		if (engineAsmGameModeEngine == null) {
			throw new Exception("Paramètre engine.asm.gameModeEngine manquant dans le fichier "+file);
		}

		engineLoaderAsmIncludes = getPropertyList(prop, "engine.asm.includ");		

		// Game Definition
		// ********************************************************************		

		gameModeBoot = prop.getProperty("gameModeBoot");
		if (gameModeBoot == null) {
			throw new Exception("Paramètre gameModeBoot manquant dans le fichier "+file);
		}

		gameMode = getPropertyList(prop, "gameMode");
		if (gameMode == null) {
			throw new Exception("Paramètre gameMode manquant dans le fichier "+file);
		}

		// Build parameters
		// ********************************************************************				

		c6809 = prop.getProperty("builder.c6809");
		if (c6809 == null) {
			throw new Exception("Paramètre builder.c6809 manquant dans le fichier "+file);
		}

		exobin = prop.getProperty("builder.exobin");
		if (exobin == null) {
			throw new Exception("Paramètre builder.exobin manquant dans le fichier "+file);
		}

		if (prop.getProperty("builder.debug") == null) {
			throw new Exception("Paramètre builder.debug manquant dans le fichier "+file);
		}
		debug = (prop.getProperty("builder.debug").contentEquals("Y")?true:false);

		if (prop.getProperty("builder.logToConsole") == null) {
			throw new Exception("Paramètre builder.logToConsole manquant dans le fichier "+file);
		}
		logToConsole = (prop.getProperty("builder.logToConsole").contentEquals("Y")?true:false);

		outputDiskName = prop.getProperty("builder.diskName");
		if (outputDiskName == null) {
			throw new Exception("Paramètre builder.diskName manquant dans le fichier "+file);
		}

		generatedCodeDirName = prop.getProperty("builder.generatedCode");
		if (generatedCodeDirName == null) {
			throw new Exception("Paramètre builder.generatedCode manquant dans le fichier "+file);
		}
		binTmpFile = generatedCodeDirName + "/" + binTmpFile;

		if (prop.getProperty("builder.to8.memoryExtension") == null) {
			throw new Exception("Paramètre builder.to8.memoryExtension manquant dans le fichier "+file);
		}
		memoryExtension = (prop.getProperty("builder.to8.memoryExtension").contentEquals("Y")?true:false);
		if (memoryExtension) {
			nbMaxPagesRAM = 31;
		} else {
			nbMaxPagesRAM = 15;
		}

		if (prop.getProperty("builder.compilatedSprite.useCache") == null) {
			throw new Exception("Paramètre builder.compilatedSprite.useCache manquant dans le fichier "+file);
		}
		useCache = (prop.getProperty("builder.compilatedSprite.useCache").contentEquals("Y")?true:false);

		if (prop.getProperty("builder.compilatedSprite.maxTries") == null) {
			throw new Exception("Paramètre builder.compilatedSprite.maxTries manquant dans le fichier "+file);
		}
		maxTries = Integer.parseInt(prop.getProperty("builder.compilatedSprite.maxTries"));
	}

	private static void readGameModeProperties(Map.Entry<String,String[]> gameMode) throws Exception {
		Properties prop = new Properties();
		try {
			InputStream input = new FileInputStream(gameMode.getValue()[0]);
			prop.load(input);
		} catch (Exception e) {
			logger.fatal("Impossible de charger le fichier de configuration: "+gameMode.getValue()[0], e); 
		}

		// Main Engine
		// ********************************************************************
		
		engineAsmMainEngine = prop.getProperty("engine.asm.mainEngine");
		if (engineAsmMainEngine == null) {
			throw new Exception("Paramètre engine.asm.mainEngine manquant dans le fichier "+gameMode.getValue()[0]);
		}

		engineAsmIncludes.put(gameMode.getKey(), getPropertyList(prop, "engine.asm.includ"));		

		// Objects
		// ********************************************************************

		gameModeObjectProperties.put(gameMode.getKey(), getPropertyList(prop, "object"));

		// Act Sequence
		// ********************************************************************

		String[] gameModeActSequence = (prop.getProperty("gameModeActSequence")).split(";");
		if (gameModeActSequence == null) {
			throw new Exception("Paramètre gameModeActSequence manquant dans le fichier "+gameMode.getValue()[0]);
		}

		// Act Definition
		// ********************************************************************		

		HashMap<String, HashMap<String, String[]>> actProperties = new HashMap<String, HashMap<String, String[]>>();
		for (int i = 0; i < gameModeActSequence.length; i++) {
			actProperties.put(gameModeActSequence[i], getPropertyList(prop, gameModeActSequence[i]));
		}
		gameModeActProperties.put(gameMode.getKey(), actProperties);
	}

	private static void readObjectProperties(String objectName, String objectProperties) throws Exception {
		Properties prop = new Properties();
		try {
			InputStream input = new FileInputStream(objectProperties);
			prop.load(input);
		} catch (Exception e) {
			logger.fatal("Impossible de charger le fichier de configuration: "+objectProperties, e); 
		}

		
		// sprite
		// ********************************************************************

		String objCode = prop.getProperty("code");
		if (objCode == null) {
			throw new Exception("Paramètre code manquant dans le fichier "+objectProperties);
		}

		allObjectCode.put(objectName, objCode);		
		
		// sprite
		// ********************************************************************

		objectSprite.put(objectName, getPropertyList(prop, "sprite"));

		// animation
		// ********************************************************************

		objectAnimation.put(objectName, getPropertyList(prop, "animation"));
	}	
	
	/**
	 * Effectue la compilation du code assembleur
	 * 
	 * @param asmFile fichier contenant le code assembleur a compiler
	 * @return
	 */
	private static int compileLIN(String asmFile) {
		return compile(asmFile, "-bl", "");
	}

	private static int compileRAW(String asmFile) {
		return compile(asmFile, "-bd", "");
	}

	private static int compileHYB(String asmFile) {
		return compile(asmFile, "-bh", "");
	}
	
	private static int compileLIN(String asmFile, String object) {
		return compile(asmFile, "-bl", object);
	}

	private static int compileRAW(String asmFile, String object) {
		return compile(asmFile, "-bd", object);
	}

	private static int compileHYB(String asmFile, String object) {
		return compile(asmFile, "-bh", object);
	}	

	private static int compile(String asmFile, String option, String object) {
		try {
			logger.debug("# Process "+asmFile);

			// Purge des fichiers temporaires
			Files.deleteIfExists(Paths.get(binTmpFile));
			Files.deleteIfExists(Paths.get(lstTmpFile));

			// Gestion des fichiers include
			Path path = Paths.get(asmFile);
			String content = new String(Files.readAllBytes(path), charset);

			Path pathInc;

			Pattern pn = Pattern.compile("INCLUD\\s([0-9a-zA-Z]*)\\s");  
			Matcher m = pn.matcher(content);  

			// Recherche de tous les TAG INCLUD dans le fichier ASM
			while (m.find()) {
				System.out.println("Include: " + m.group(1));
				if (engineLoaderAsmIncludes.get(m.group(1)) != null) {
					System.out.println(engineLoaderAsmIncludes.get(m.group(1))[0]);
					pathInc = Paths.get(engineLoaderAsmIncludes.get(m.group(1))[0]);
					content += "\n\n(include)" + m.group(1) + "\n" + new String(Files.readAllBytes(pathInc), charset);
				} else if (engineAsmIncludes.get(object) != null && engineAsmIncludes.get(object).get(m.group(1)) != null) {
					System.out.println(engineAsmIncludes.get(object).get(m.group(1))[0]);
					pathInc = Paths.get(engineAsmIncludes.get(object).get(m.group(1))[0]);
					content += "\n\n(include)" + m.group(1) + "\n" + new String(Files.readAllBytes(pathInc), charset);
				} else {
					throw new Exception (m.group(1) + " not found in include declaration.");
				}
			}
			// Pour chaque TAG, ajout en fin de fichier a compiler du contenu du fichier inclus		
			Path pathTmp = Paths.get(generatedCodeDirName+"/"+path.getFileName().toString());
			Files.write(pathTmp, content.getBytes(charset));
			// ---------------------------------------------------------------------------

			// Lancement de la compilation du fichier contenant le code de boot
			logger.debug("# Compile "+pathTmp.toString());
			Process p = new ProcessBuilder(c6809, option, pathTmp.toString(), Paths.get(binTmpFile).toString()).start();
			BufferedReader br=new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;

			while((line=br.readLine())!=null){
				logger.debug(line);
			}

			// c6809.exe bugfix: retour du processus vaut 0 méme en cas d'erreur
			// de compilation, on lit le lst pour compter les erreurs
			p.waitFor();
			int result = C6809Util.countErrors(lstTmpFile);

			if (result == 0) {
				// Purge et remplacement de l'ancien fichier lst
				File lstFile = new File(lstTmpFile); 
				String basename = FileUtil.removeExtension(pathTmp.getFileName().toString());
				String destFileName = generatedCodeDirName+"/"+basename+".lst";
				Path lstFilePath = Paths.get(destFileName);
				Files.deleteIfExists(lstFilePath);
				File newLstFile = new File(destFileName);
				lstFile.renameTo(newLstFile);
				
				// Sauvegarde des variables globales
				String contentLst = new String(Files.readAllBytes(Paths.get(destFileName)), charset);
				pn = Pattern.compile("([0-9a-zA-Z_]*).*@globals.*") ;  
				m = pn.matcher(content);
				Pattern pn2;
				Matcher m2;

				// Recherche de tous les @globals dans le fichier ASM
				while (m.find()) {
					System.out.println("@globals: " + m.group(1));
					pn2 = Pattern.compile("(Label|Equ)\\s*([0-9a-fA-F]*)\\s"+m.group(1));
					m2 = pn2.matcher(contentLst);  
					if (m2.find() == false) {
						throw new Exception (m.group(1) + " not found in Symbols.");
					} else {
						System.out.println("value: " + m2.group(2));
						glb.addConstant(m.group(1), "$"+m2.group(2));
					}
				}
				glb.flush();

				// Purge et remplacement de l'ancien fichier bin
				File binFile = new File(binTmpFile); 
				basename = FileUtil.removeExtension(pathTmp.getFileName().toString());
				destFileName = generatedCodeDirName+"/"+basename+".BIN";
				Path binFilePath = Paths.get(destFileName);
				Files.deleteIfExists(binFilePath);
				File newBinFile = new File(destFileName);
				binFile.renameTo(newBinFile);

				logger.debug(destFileName + " cycles: " + C6809Util.countCycles(newLstFile.getAbsoluteFile().toString()) + " BIN size: " + newBinFile.length());
			} else {
				throw new Exception ("Erreur de compilation "+pathTmp.getFileName().toString());
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
	private static byte[] exomize(String binFile) {
		try {
			String basename = FileUtil.removeExtension(Paths.get(binFile).getFileName().toString());
			String destFileName = generatedCodeDirName+"/"+basename+".EXO";

			// Purge des fichiers temporaires
			Files.deleteIfExists(Paths.get(destFileName));

			// Lancement de la compilation du fichier contenant le code de boot
			logger.debug("**************** EXOMIZE "+binFile+" ****************");
			Process p = new ProcessBuilder(exobin, "", Paths.get(binFile).toString()).start();
			BufferedReader br=new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;

			while((line=br.readLine())!=null){
				logger.debug(line);
			}

			if (p.waitFor() != 0) {
				throw new Exception ("Erreur de compilation "+binFile);
			}
			return Files.readAllBytes(Paths.get(destFileName));

		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(e); 
			return null;
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
		String destFileName = generatedCodeDirName+"/"+basename+".asm";

		Path original = Paths.get(fileName);        
		Path copied = Paths.get(destFileName);
		Files.copy(original, copied, StandardCopyOption.REPLACE_EXISTING);
		return destFileName;
	}
	
	public static String duplicateFile(String fileName, String subDir) throws IOException {
		String basename = FileUtil.removeExtension(Paths.get(fileName).getFileName().toString());
		String destFileName = generatedCodeDirName+"/"+subDir+"/"+basename+".asm";

		// Creation du chemin si les répertoires sont manquants
		File file = new File (destFileName);
		file.getParentFile().mkdirs();
		
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
		HashMap<String, String[]> result = new HashMap<String, String[]>();
		Pattern pn = Pattern.compile("^" + name + "\\.(.*)$") ;  
		Matcher m = null;
		for (Entry<Object, Object> entry : properties.entrySet())
		{
			m = pn.matcher(((String)entry.getKey())) ;  
			if (m.find()) {
				result.put(m.group(1), ((String)entry.getValue()).split(";"));
			}
		}

		return result;
	}

	public static String getBINFileName (String name) {
		return generatedCodeDirName+"/"+FileUtil.removeExtension(Paths.get(name).getFileName().toString())+".BIN";
	}

	public static String getEXOFileName (String name) {
		return generatedCodeDirName+"/"+FileUtil.removeExtension(Paths.get(name).getFileName().toString())+".EXO";
	}
	
	public static Path getIncludeFilePath (String tag) throws Exception {	
		if (engineLoaderAsmIncludes.get(tag) == null) {
			throw new Exception (tag+" not found in include declaration.");
		}		
		return Paths.get(engineLoaderAsmIncludes.get(tag)[0]);
	}
	
	public static Path getIncludeFilePath (String tag, String gameMode) throws Exception {	
		if (engineAsmIncludes.get(gameMode).get(tag) == null) {
			throw new Exception (tag+" not found in include declaration of Game Mode: "+gameMode);
		}
		
		// Creation du chemin si les répertoires sont manquants
		File file = new File (engineAsmIncludes.get(gameMode).get(tag)[0]);
		file.getParentFile().mkdirs();
		
		return Paths.get(engineAsmIncludes.get(gameMode).get(tag)[0]);
	}	
	
}

// Traitement de l'image pour l'écran de démarrage
// ***********************************************

//				PngToBottomUpBinB16 initVideo = new PngToBottomUpBinB16(initVideoFile);
//				byte[] initVideoBIN = initVideo.getBIN();
//
//				fd.setIndex(0, 4, 1);
//				fd.write(initVideoBIN);

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
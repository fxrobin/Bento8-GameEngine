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
import java.nio.file.StandardOpenOption;
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
import fr.bento8.to8.image.PngToBottomUpBinB16;
import fr.bento8.to8.image.Sprite;
import fr.bento8.to8.image.SpriteSheet;
import fr.bento8.to8.util.ByteUtil;
import fr.bento8.to8.util.C6809Util;
import fr.bento8.to8.util.FileUtil;
import fr.bento8.to8.util.knapsack.Item;
import fr.bento8.to8.util.knapsack.Knapsack;
import fr.bento8.to8.util.knapsack.Solution;

public class BuildDisk
{
	private static final Logger logger = LogManager.getLogger("log");

	// Engine
	private static String engineAsmBoot;
	private static String engineAsmGameMode;
	private static String engineAsmGameModeEngine;	
	private static HashMap<String, String[]> engineAsmIncludes;

	// Game Mode
	private static String gameModeBoot;
	private static HashMap<String, String[]> gameMode;
	private static HashMap<String, HashMap<String, String[]>> GameModeObjectProperties = new HashMap<String, HashMap<String, String[]>>();
	private static HashMap<String, HashMap<String, HashMap<String, String[]>>> GameModeActProperties = new HashMap<String, HashMap<String, HashMap<String, String[]>>>();

	// Object
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
	public static boolean useCache;
	public  static int maxTries;

	private static String binTmpFile = "TMP.BIN";
	private static String lstTmpFile = "codes.lst";

	private static Charset charset = StandardCharsets.UTF_8;
	
	public static FdUtil fd;
	public static Globals glb;
	
	public static byte[] engineAsmGameModeBytes;	
	public static byte[] mainEXOBytes;
	public static byte[] bootLoaderBytes;

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
			logger.info("**************************************************************************\n");		

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
			glb = new Globals(engineAsmIncludes);

			logger.info("\nCompilation du Game Mode Engine et encodage du binaire (GMENGINE)");
			logger.info("**************************************************************************\n");			

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

			processGameModes();			
			
			logger.info("\nCompilation du code de Game Mode (contient GMENGINE et GMEDATA)");
			logger.info("**************************************************************************\n");			

			String gameModeTmpFile = duplicateFile(engineAsmGameMode);
			compileRAW(gameModeTmpFile);
			byte[] engineAsmGameModeBytes = Files.readAllBytes(Paths.get(getBINFileName(gameModeTmpFile)));

			if (engineAsmGameModeBytes.length > 0x4000) {
				throw new Exception("Le fichier "+engineAsmGameMode+" est trop volumineux:"+engineAsmGameModeBytes.length+" octets (max:"+0x4000+")");
			}
			int dernierBloc = 0xA000 + engineAsmGameModeBytes.length;

			logger.info("\nCompilation du code de boot");
			logger.info("**************************************************************************\n");			
			
			String bootTmpFile = duplicateFile(engineAsmBoot);
			glb.addConstant("boot_dernier_bloc", String.format("$%1$02X", dernierBloc >> 8)+"00"); // On tronque l'octet de poids faible
			compileRAW(bootTmpFile);

			// Traitement du binaire issu de la compilation et génération du secteur d'amorçage
			Bootloader bootLoader = new Bootloader();
			bootLoaderBytes = bootLoader.encodeBootLoader(getBINFileName(bootTmpFile));

			logger.info("\nGénération des images de disquettes");
			logger.info("**************************************************************************\n");

			// Ecriture sur disquette
			fd.setIndex(0, 0, 2);
			fd.write(engineAsmGameModeBytes);
			
			// TODO all game modes
			// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			fd.setIndex(0, 0, 3);
			fd.write(mainEXOBytes);	
			
			// boot
			fd.setIndex(0, 0, 1);
			fd.write(bootLoaderBytes);
			
			fd.save(outputDiskName);
			fd.saveToSd(outputDiskName);
			
			logger.info("\nFin du traitement.");

		} catch (Exception e) {
			logger.fatal("Erreur lors du build.", e);
		}
	}

	private static void processGameModes() throws Exception {
		
		logger.info("\nCompilation des données de Game Mode (GMEDATA)");
		logger.info("**************************************************************************\n");
		
		// Initialisation des fichiers source générés
		GameModeEngineData gmeData = new GameModeEngineData(engineAsmIncludes);
		
		// GLOBALS - Génération des identifiants d'objets pour l'ensemble des game modes (numérotation commune)
		logger.info("\nGénération des identifiants objets:");
		int objIndex = 1;
		for(Entry<String, HashMap<String, String[]>> entry : GameModeObjectProperties.entrySet()) {
			for (String key : entry.getValue().keySet()) {
				glb.addConstant("ObjID_"+key, Integer.toString(objIndex++));
				logger.info("ObjID_"+key+": "+Integer.toString(objIndex++));		
				readObjectProperties(key, entry.getValue().get(key)[0]);
			}
		}
		
		// Génération des sprites compilés pour l'ensemble des game modes
		
		// Map contenant l'ensemble des données pour chaque image (<SpriteTag, Sprite>)
		HashMap<String, Sprite> binImages = new HashMap<String, Sprite>();		
		AssemblyGenerator asm;
		
		// génération du sprite compilé
		String spriteFile;
		String[] flip;
		
		// Parcours de tous les objets du jeu
		for (Entry<String, HashMap<String, String[]>> object : objectSprite.entrySet()) {
			
			// Parcours des images de l'objet
			for (String spriteTag : object.getValue().keySet()) {
				
				spriteFile = object.getValue().get(spriteTag)[0];
				flip = object.getValue().get(spriteTag)[1].split(",");
				Sprite sprite = new Sprite();
				
				// Parcours des modes mirroir demandés pour chaque image
				for (String curFlip : flip) {
					logger.info("\nGénération du code ASM du sprite: " + spriteTag + " image:" + spriteFile + " flip:" + curFlip);
					asm = new AssemblyGenerator(new SpriteSheet(spriteTag, spriteFile, 1, curFlip), 0);
					
					// Sauvegarde du code généré pour le mode mirroir courant
					logger.info("Compilation de l'image");
					asm.compileCode("A000");
					
					logger.info("Exomize Draw code");
					switch (curFlip) {
					case "N":
						sprite.subSprite.binBckDraw = exomize(asm.getBckDrawBINFile());
						sprite.subSprite.binErase = exomize(asm.getEraseBINFile());
						// sprite.subSprite.binDraw = exomize(asm.getDrawBINFile());
						break;
					case "X":
						sprite.subSpriteX.binBckDraw = exomize(asm.getBckDrawBINFile());
						sprite.subSpriteX.binErase = exomize(asm.getEraseBINFile());
						// sprite.subSpriteX.binDraw = exomize(asm.getDrawBINFile());
						break;
					case "Y":
						sprite.subSpriteY.binBckDraw = exomize(asm.getBckDrawBINFile());
						sprite.subSpriteY.binErase = exomize(asm.getEraseBINFile());
						// sprite.subSpriteY.binDraw = exomize(asm.getDrawBINFile());
						break;
					case "XY":
						sprite.subSpriteXY.binBckDraw = exomize(asm.getBckDrawBINFile());
						sprite.subSpriteXY.binErase = exomize(asm.getEraseBINFile());
						// sprite.subSpriteXY.binDraw = exomize(asm.getDrawBINFile());
						break;
					}
				}

				// Sauvegarde de tous les modes mirroir demandés pour l'image en cours
				binImages.put(spriteTag, sprite);
			}
		}

		
		
		


		
		

		// Construction des données de chaque Game Mode
		for (Map.Entry<String, String[]> curGameMode : gameMode.entrySet()) {
			logger.info("Traitement du Game Mode : " + curGameMode.getKey());
			
			// MAIN
			// ****
			
			// Générer les fichiers ASM :
//          PALETTE
//	        OBJINDEX
//	        IMAGEIDX
//	        ANIMSCPT		
	        // et les ajouter à la liste des include

			//GameModeActProperties.get(curGameMode.getKey()).;
//			gmeData.addLabel("Pal_TitleScreen * @globals");
//			spriteSheets.get(animationPalette).getCodePalette(animationPaletteGamma);
			
			// * Données de palette
			// * ------------------
			// Pal_TitleScreen
			// fdb $0000
			// ...
			
			// * Adresse du code des objets (Obj_Index: ObjPtr_Sonic, ...)
			// * --------------------------
			// Obj_Index
			// fcb $05,$A0,$00 ; Objet $01 main code
			// fcb $05,$A5,$02 ; Objet $02 main code
			// ...

			// * Adresse des images de l'objet
			// * -----------------------------
			// ; page_bckdraw_routine, bckdraw_routine
			// ; page_draw_routine, draw_routine
			// ; page_erase_routine, erase_routine, nb_cell
			// ; x_offset, y_offset
			// ; x_size, y_size (must follow x_size)
			// ImgMeta_size fcb 14
			// Img_Emblem
			// fcb $07,$B0,$20,$07,$B0,$20,$08,$27,$32,$10,$10,$5,$5,$4
			// fcb $07,$B0,$20,$07,$B0,$20,$08,$27,$32,$10,$10,$5,$5,$4 (x_mirror)
			// fcb $07,$B0,$20,$07,$B0,$20,$08,$27,$32,$10,$10,$5,$5,$4 (y_mirror)
			// fcb $07,$B0,$20,$07,$B0,$20,$08,$27,$32,$10,$10,$5,$5,$4 (y_mirror, x_mirror)			
			// Img_EmblemFront
			// fcb $07,$B0,$20,$07,$B0,$20,$08,$27,$32,$10,$10,$5,$5,$4
			// Img_IslandLand
			// fcb $07,$B0,$20,$07,$B0,$20,$08,$27,$32,$10,$10,$5,$5,$4
			// Img_IslandWater
			// fcb $07,$B0,$20,$07,$B0,$20,$08,$27,$32,$10,$10,$5,$5,$4
			// ...			
			
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
			
			// Ajout du tag pour identifier le game mode de démarrage
			if (curGameMode.getKey().contentEquals(gameModeBoot)) {
				gmeData.addLabel("gmboot * @globals");
			}

			gmeData.addLabel("gm_" + curGameMode.getKey());
//	        fdb   $0000 * destination : valeur a calculer par le builder (current_game_mode_data + longueur des données ci dessous 1+((x+1)*7)) le 1+ est pour balise de fin ecrite dans le code
//			fcb   $00,$00,$3,$23,$01,$61,$00 * b: DRV/TRK, b: SEC, b: nb SEC, b: offset de fin, b: dest Page, w: dest Adresse			
			gmeData.addFcb(new String[] { "$FF" });
			
			// récupérer l'engine dans properties et le compiler
			
			logger.info("\nCompilation du code de Main Engine");
			logger.info("**************************************************************************\n");

//			String mainEngineTmpFile = duplicateFile(engineAsmMainEngine);
//
//			compileLIN(mainEngineTmpFile);
//			byte[] binBytes = Files.readAllBytes(Paths.get(getBINFileName(mainEngineTmpFile)));
//			int binBytesSize = binBytes.length-10;
//
//			if (binBytesSize > 16384) {
//				throw new Exception("Le fichier "+engineAsmMainEngine+" est trop volumineux:"+binBytesSize+" octets (max:16384)");
//			}
//			
//			exomize(getBINFileName(mainEngineTmpFile));
//			mainEXOBytes = Files.readAllBytes(Paths.get(getEXOFileName(mainEngineTmpFile)));
//			logger.info("Exomize : "+mainEXOBytes.length+" bytes");			
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

		engineAsmIncludes = getPropertyList(prop, "engine.asm.includ");		

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

		// Objects
		// ********************************************************************

		GameModeObjectProperties.put(gameMode.getKey(), getPropertyList(prop, "object"));

		// Act Sequence
		// ********************************************************************

		String[] gameModeActSequence = (prop.getProperty("gameModeActSequence")).split(";");
		if (gameModeActSequence == null) {
			throw new Exception("Paramètre gameModeActSequence manquant dans le fichier "+gameMode.getValue()[0]);
		}

		// Act Definition
		// ********************************************************************		

		HashMap<String, HashMap<String, String[]>> ActProperties = new HashMap<String, HashMap<String, String[]>>();
		for (int i = 0; i < gameModeActSequence.length; i++) {
			ActProperties.put(gameModeActSequence[i], getPropertyList(prop, gameModeActSequence[i]));
		}
		GameModeActProperties.put(gameMode.getKey(), ActProperties);
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
		return compile(asmFile, "-bl");
	}

	private static int compileRAW(String asmFile) {
		return compile(asmFile, "-bd");
	}

	private static int compileHYB(String asmFile) {
		return compile(asmFile, "-bh");
	}

	private static int compile(String asmFile, String option) {
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
				if (engineAsmIncludes.get(m.group(1)) == null) {
					throw new Exception (m.group(1) + " not found in include declaration.");
				} else {
					System.out.println(engineAsmIncludes.get(m.group(1))[0]);
					pathInc = Paths.get(engineAsmIncludes.get(m.group(1))[0]);
					content += "\n\n(include)" + m.group(1) + "\n" + new String(Files.readAllBytes(pathInc), charset);
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
}

//replaceTag(bootTmpFile, "<DERNIER_BLOC>", String.format("%1$02X", uReg >> 8));

// Traitement de l'image pour l'écran de démarrage
// ***********************************************

//				PngToBottomUpBinB16 initVideo = new PngToBottomUpBinB16(initVideoFile);
//				byte[] initVideoBIN = initVideo.getBIN();
//
//				fd.setIndex(0, 4, 1);
//				fd.write(initVideoBIN);

//				// Génération des sprites compilés et organisation en pages de 16Ko par l'algorithme du sac é dos
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
//				// Parcours de toutes les animations é la recherche des planches utilisées
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
//					// Création de l'item pour l'algo sac é dos
//					items[itemIdx++] = new Item(currentImage, 1, binaryLength); // id, priority, bytes
//
//					logger.debug(currentImage+" octets: "+binaryLength);
//					
//					// Une image compilée doit tenir sur une page de 16Ko pour pouvoir étre exécutée
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
//					// les données sont réparties en pages en fonction de leur taille par un algorithme "sac é dos"
//					Knapsack knapsack = new Knapsack(items, 16384); //Sac é dos de poids max 16Ko
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
//						logger.debug("**************** Compilation de l'image " + currentItem.name + " é l'adresse "+String.format("%1$04X",org+orgOffset)+"****************");
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
//						// Ecriture sur disquette du sprite compilé é l'adresse cible
//						fd.write(binary);
//
//						// construit la liste des éléments restants é organiser
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

//// Compilation du code principal
//compileLIN(mainFile);
//byte[] mainBINBytes = Files.readAllBytes(Paths.get(getBINFileName(mainFile)));
//int mainBINSize = mainBINBytes.length-10;
//
//if (mainBINSize > 15360) {
//	throw new Exception("Le fichier Main est trop volumineux:"+mainBINSize+" octets (max:15360 va jusqu'en 9F00, avec une pile de 256 octets 9F00-9FFF)");
//}
//
//exomize(getBINFileName(mainFile));
//byte[] mainEXOBytes = Files.readAllBytes(Paths.get(getEXOFileName(mainFile)));
//int mainEXOSize = mainEXOBytes.length;
//
//// Ecriture sur disquette
//fd.setIndex(0, 0, 2);
//fd.write(mainEXOBytes);
//
//// Complément du code exomizer avec paramétres d'init pour le décodage du MAIN
//
//int uReg = 40960 + mainEXOSize; //A000
//int yReg = 25344 + mainBINSize; //6300  
//
//String exomizerTmpFile = duplicateFile(exomizerFile);
//replaceTag(exomizerTmpFile, "<SOURCE>", String.format("%1$04X", uReg));
//replaceTag(exomizerTmpFile, "<DESTINATION>", String.format("%1$04X", yReg));
//
//// Compilation du code de décodage exomizer
//compileLIN(exomizerTmpFile);
//byte[] exoBytes = Files.readAllBytes(Paths.get(getBINFileName(exomizerTmpFile)));
//
//if (exoBytes.length-10 > 256) {
//	throw new Exception("Le fichier Exomizer ("+(exoBytes.length-10)+") est trop volumineux: "+(exoBytes.length-10)+" octets (max:256 destination 6100-61FF)");
//}
//
//// Ecriture sur disquette
//fd.nextSector();
//fd.write(exoBytes, 5, exoBytes.length-10); // On ne recopie pas le header et trailer




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
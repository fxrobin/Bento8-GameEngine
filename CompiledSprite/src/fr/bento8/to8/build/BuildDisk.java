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
	private static HashMap<String, String[]> engineAsmIncludes;

	// Game Mode
	private static String gameModeBoot;
	private static HashMap<String, String[]> gameMode;
	private static HashMap<String, HashMap<String, String[]>> GameModeObjectProperties = new HashMap<String, HashMap<String, String[]>>();
	private static HashMap<String, HashMap<String, HashMap<String, String[]>>> GameModeActProperties = new HashMap<String, HashMap<String, HashMap<String, String[]>>>();

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
	
	public static Globals glb;

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
		int face=0, track=0, sector=1;
		byte[] binary;

		try {

			// Initialisation
			// *****************************************************************

			// Chargement du fichier de configuration principal
			logger.info("Lecture du fichier de configuration: "+args[0]);
			readProperties(args[0]);

			// Chargement des fichiers de configuration secondaires
			for (Map.Entry<String,String[]> curGameMode : gameMode.entrySet()) {
				logger.info("Lecture du fichier de configuration "+curGameMode.getKey()+" : "+curGameMode.getValue()[0]);
				readGameModeProperties(curGameMode);
			}

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

			// Initialisation de l'image de disquette en sortie
			FdUtil fd = new FdUtil();

			// Gestion des variables globales
			glb = new Globals(engineAsmIncludes);

			// Compilation des includes binaires
			// *****************************************************************
			System.out.println("Compilation des includes binaires:");
			for (Map.Entry<String,String[]> engineAsmInclude : engineAsmIncludes.entrySet()) {
				if (engineAsmInclude.getValue().length > 1) {
					System.out.println(engineAsmInclude.getKey());
					String engineAsmIncludeTmpFile = duplicateFile(engineAsmInclude.getValue()[1]);
					compileRAW(engineAsmIncludeTmpFile);
					byte[] BINBytes = Files.readAllBytes(Paths.get(getBINFileName(engineAsmIncludeTmpFile)));
					String HEXValues = ByteUtil.bytesToHex(BINBytes);
					String content = "";
					for (int i = 0; i < HEXValues.length(); i += 2) {
						content += "\n        fcb   $" +  HEXValues.charAt(i) +  HEXValues.charAt(i+1);
					}
		            try {
		                Files.write(Paths.get(engineAsmIncludeTmpFile), content.getBytes());
		            } catch (IOException ioExceptionObj) {
		                System.out.println("Problème à l'écriture du fichier "+engineAsmIncludeTmpFile+": " + ioExceptionObj.getMessage());
		            }
				}
			}

			// Compilation du code de Game Mode Engine et des Game Modes
			// *****************************************************************

			String gameModeTmpFile = duplicateFile(engineAsmGameMode);

			processGameModes();		

			compileRAW(gameModeTmpFile);
			byte[] binBytes = Files.readAllBytes(Paths.get(getBINFileName(gameModeTmpFile)));
			int binBytesSize = binBytes.length;

			if (binBytesSize > 16384) {
				throw new Exception("Le fichier "+engineAsmGameMode+" est trop volumineux:"+binBytesSize+" octets (max:16384)");
			}
			int dernierBloc = 40960 + binBytesSize; //A000

			// Ecriture sur disquette
			fd.setIndex(0, 0, 2);
			fd.write(binBytes);

			// Compilation du code de boot
			// *****************************************************************

			String bootTmpFile = duplicateFile(engineAsmBoot);
			glb.addConstant("boot_dernier_bloc", String.format("$%1$02X", dernierBloc >> 8)+"00"); // On tronque l'octet de poids faible
			compileRAW(bootTmpFile);

			// Traitement du binaire issu de la compilation et génération du secteur d'amorçage
			Bootloader bootLoader = new Bootloader();
			byte[] bootLoaderBytes = bootLoader.encodeBootLoader(getBINFileName(bootTmpFile));

			// Ecriture sur disquette
			fd.setIndex(0, 0, 1);
			fd.write(bootLoaderBytes);

			// Génération des images de disquettes
			// *****************************************************************

			fd.save(outputDiskName);
			fd.saveToSd(outputDiskName);

		} catch (Exception e) {
			logger.fatal("Erreur lors de la lecture du fichier de configuration.", e);
		}
	}

	private static void processGameModes() throws Exception {
		// Initialisation des fichiers source générés
		GameModeEngineData gmeData = new GameModeEngineData(engineAsmIncludes);

		// Boot Game Mode
		int index = 0;
		logger.info("Traitement du Game Mode (Boot) : "+gameModeBoot);
		gmeData.addConstant("gm_"+gameModeBoot, String.format("$%1$02X", index));
		index += 2;

		// Other Game Modes
		for (Map.Entry<String,String[]> curGameMode : gameMode.entrySet()) {
			if (!curGameMode.getKey().contentEquals(gameModeBoot)) {
				logger.info("Traitement du Game Mode : "+curGameMode.getKey());
				gmeData.addConstant("gm_"+curGameMode.getKey(), String.format("$%1$02X", index));
				index += 2;
			}
		}

		gmeData.addLabel("current_game_mode");
		gmeData.addFcb(new String[] {"gm_"+gameModeBoot});
		// Il faut ajouter dans GameMode deux fonctions : changement de Game Mode et changement d'act
		// Pour faire l'appel il faudra pouvoir set la page mémoire et set le PC pour que l'execution branche au bon endroit 
		// Donc passer par la page 1 pour faire la transition


		// *******************************************************************************

		// CONSTANT
		// ********

		//* Reference des identifiants d'objets (ObjID_IntroStars, ...)
		//* -----------------------------------
		//TitleScreen_id equ $01

		//* Référence des mots reserves pour les scripts d'animation
		//* --------------------------------------------------------
		//_resetAnim              equ $FF
		//_goBackNFrames          equ $FE
		//_goToAnimation          equ $FD
		//_nextRoutine            equ $FC
		//_resetAnimAndSubRoutine equ $FB
		//_nextSubRoutine         equ $FA

		// MAIN
		// ****

		//* Adresse du code des objets (Obj_Index: ObjPtr_Sonic, ...)
		//* --------------------------
		//ObjectCodeRef
		//        fcb   $05,$A0,$00 ; Objet $01 main code
		//        fcb   $05,$A5,$02 ; Objet $02 main code
		//...

		//* Scripts d'animation
		//* -------------------
		//LargeStar
		//fcb   $01 ; frame duration
		//fdb   ImgrefStar_2
		//fdb   ImgrefStar_3
		//fdb   ImgrefStar_4
		//fdb   ImgrefStar_3
		//fdb   ImgrefStar_2
		//fcb   _nextSubRoutine

		//SmallStar
		//fcb   $03 ; frame duration
		//fdb   ImgrefStar_1
		//fdb   ImgrefStar_2
		//fcb   _resetAnim

		//* Adresse des images de l'objet
		//* -----------------------------

		//ImgrefEmblem        
		//        fcb   $07,$B0,$20,$08,$27,$32 ; compiled sprite draw routine (page,address) and erase routine (page,address)					
		//ImgrefEmblemFront    
		//        fcb   $07,$B0,$20,$08,$27,$32		
		//ImgrefIslandLand      
		//        fcb   $07,$B0,$20,$08,$27,$32		
		//ImgrefIslandWater     
		//        fcb   $07,$B0,$20,$08,$27,$32		
		//...
		
//		// Compilation du code de Game Mode Engine et des Game Modes
//		// *****************************************************************
//
//		String gameModeTmpFile = duplicateFile(engineAsmGameMode);
//
//		processGameModes();		
//
//		compileRAW(gameModeTmpFile);
//		byte[] mainBINBytes = Files.readAllBytes(Paths.get(getBINFileName(gameModeTmpFile)));
//		int mainBINSize = mainBINBytes.length;
//
//		if (mainBINSize > 16128) {
//			throw new Exception("Le fichier "+engineAsmGameMode+" est trop volumineux:"+mainBINSize+" octets (max:16128 va jusqu'en 9F00, avec une pile de 256 octets 9F00-9FFF)");
//		}
//		int dernierBloc = 40960 + mainBINSize; //A000
//
//		// Ecriture sur disquette
//		fd.setIndex(0, 0, 2);
//		fd.write(mainBINBytes);

		// *******************************************************************************

		// Game Modes Data
		for (Map.Entry<String,String[]> curGameMode : gameMode.entrySet()) {
			logger.info("Traitement du Game Mode : "+curGameMode.getKey());
			gmeData.addLabel("gm_data_"+curGameMode.getKey());

			// Boucle à implémenter
			// Donnees b: DRV/TRK, b: SEC, b: nb SEC, b: offset de fin, b: dest Page, w: dest Adresse
			gmeData.addFcb(new String[] {"$FF", "$FF", "$FF", "$FF", "$FF", "$FF", "$FF"});
		}
		gmeData.addLabel("gm_dataEnd");

		// Game Modes Data Array
		logger.info("Traitement du GameModesArray");
		gmeData.addLabel("GameModesArray");
		String entry = null;
		for (Map.Entry<String,String[]> curGameMode : gameMode.entrySet()) {
			if (entry != null) {
				gmeData.addFdb(new String[] {"gm_data_"+entry, "gm_data_AIZ-gm_data_"+entry});
			}
			entry=curGameMode.getKey();
		}
		gmeData.addFdb(new String[] {"gm_data_"+entry, "gm_dataEnd-gm_data_"+entry});	

		gmeData.flush();
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
			logger.debug("**************** Process "+asmFile+" ****************");

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
			logger.debug("**************** Compile "+pathTmp.toString()+" ****************");
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

				// Recherche de tous les TAG INCLUD dans le fichier ASM
				while (m.find()) {
					System.out.println("@globals: " + m.group(1));
					pn2 = Pattern.compile("Label\\s([0-9a-fA-F]*)\\s"+m.group(1));
					m2 = pn2.matcher(contentLst);  
					if (m2.find() == false) {
						throw new Exception (m.group(1) + " not found in Symbols.");
					} else {
						System.out.println("value: " + m2.group(1));
						glb.addConstant(m.group(1), "$"+m2.group(1));
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
	private static int exomize(String binFile) {
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
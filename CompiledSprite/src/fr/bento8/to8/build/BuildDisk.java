package fr.bento8.to8.build;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
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
import fr.bento8.to8.disk.DataIndex;
import fr.bento8.to8.disk.FdUtil;
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
	static final Logger logger = LogManager.getLogger("log");

	private static Game game;
	private static AsmSourceCode glb;
	private static HashMap<String, Object> allObjects = new HashMap<String, Object>();
	private static int gm_totalSize = 0; // Taille totale du binaire : Game Mode Manager + Game Mode Loader + Game Mode Data

	private static FdUtil fd = new FdUtil();
	
	private static int IMAGE_META_SIZE = 14;
	
	public static String binTmpFile = "TMP.BIN";
	public static String lstTmpFile = "codes.lst";

	/**
	 * Génère une image de disquette dans les formats .fd et .sd pour 
	 * l'ordinateur Thomson TO8.
	 * L'image de disquette contient un secteur d'amorçage et le code
	 * MainGameManager qui sera chargé en mémoire par le code d'amorçage.
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
			
			// load configuration and make some initializations
			loadGameConfiguration(args[0]);
			compileGameModeLoader();
			setObjectsIdAsGlobals();
			
			// generate compilated sprites and compute size of all asm code 
			compileMainEnginesFirstPass();
			compileSprites();
			compileObjectsFirstPass();
			computeGameModeManagerSize();
			
			// compute RAM destination for all asm code
			computeObjectsRamAddress();
			
			// compile all asm code
			compileObjects();
			compileMainEngines();
			
			// write to disk image 
			writeObjects();
			
			// compute disk index data and compile Game Mode Manager & Boot 
			compileAndWriteGameModeManager();
			compileAndWriteBoot();
			
			// output disk image
			writeDiskImage();
						
			// Play the game ... or debug ;-)
			
		} catch (Exception e) {
			logger.fatal("Erreur lors du build.", e);
		}
	}

	private static void loadGameConfiguration(String configFileName) throws Exception {
		logger.info("Load Game configuration: "+configFileName+" ...");
		game = new Game(configFileName);
		
		// Initialisation du logger
		if (game.debug) {
			Configurator.setAllLevels(LogManager.getRootLogger().getName(), Level.DEBUG);
		}

		LoggerContext context = LoggerContext.getContext(false);
		Configuration configuration = context.getConfiguration();
		LoggerConfig loggerConfig = configuration.getLoggerConfig(LogManager.getRootLogger().getName());

		if (!game.logToConsole) {
			loggerConfig.removeAppender("LogToConsole");
			context.updateLoggers();
		}			
		
		// Initialisation des variables globales
		glb = new AsmSourceCode(getIncludeFilePath(Tags.GLOBALS));		
	}
	
	private static void compileGameModeLoader() throws IOException {
		logger.info("Compile Game Mode Loader ...");

		String engineAsmIncludeTmpFile = duplicateFile(game.engineAsmGameModeEngine);
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
		
		Files.write(Paths.get(engineAsmIncludeTmpFile), content.getBytes());
	}
	
	private static void setObjectsIdAsGlobals() throws Exception {
		logger.info("Set Objects Id as Globals ...");
				
		// GLOBALS - Génération des identifiants d'objets pour l'ensemble des game modes (numérotation commune)
		// ----------------------------------------------------------------------------------------------------		
		int objIndex = 1;
		for(Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				if (!allObjects.containsKey(object.getKey())) { 
					allObjects.put(object.getKey(), object.getValue());
					glb.addConstant("ObjID_"+object.getKey(), Integer.toString(objIndex));
					logger.debug("\t\tObjID_"+object.getKey(), Integer.toString(objIndex));
					objIndex++;
				}
			}
		}
		glb.flush();
	}
	 
	private static void compileMainEnginesFirstPass() throws Exception {
		logger.info("Compile Main Engines (First Pass) ...");
		
		for(Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {	

			// Initialisation a vide des fichiers source générés
			AsmSourceCode asmObjIndex = new AsmSourceCode(getIncludeFilePath(Tags.OBJECT_INDEX, gameMode.getValue()));			
			asmObjIndex.addLabel("Obj_Index");
			asmObjIndex.flush();
			
			AsmSourceCode asmLoadAct = new AsmSourceCode(getIncludeFilePath(Tags.LOAD_ACT, gameMode.getValue()));			
			asmLoadAct.addLabel("LoadAct");
			asmLoadAct.flush();			
			
			// Compilation du Main Engine sans données
			String mainEngineTmpFile = duplicateFile(gameMode.getValue().engineAsmMainEngine, gameMode.getKey());

			compileLIN(mainEngineTmpFile, gameMode.getValue());
			byte[] binBytes = Files.readAllBytes(Paths.get(getBINFileName(mainEngineTmpFile)));

			if (binBytes.length - 10 > 0x4000) {
				throw new Exception("file " + gameMode.getValue().engineAsmMainEngine + " is too large:" + (binBytes.length - 10) + " bytes (max:"+0x4000+")");
			}
		}			
	}
	
	private static void compileSprites() throws Exception {
		logger.info("Compile Sprites ...");

		// GAME MODE DATA - Génération des sprites compilés pour chaque objet
		// ------------------------------------------------------------------
		AssemblyGenerator asm;

		// génération du sprite compilé
		SubSprite curSubSprite;

		// Parcours de tous les objets de chaque Game Mode
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {

				AsmSourceCode asmImgIndex = new AsmSourceCode(getIncludeFilePath(Tags.IMAGE_INDEX, gameMode.getValue(), object.getValue()));

				// Parcours des images de l'objet et compilation de l'image
				for (Entry<String, String[]> spriteProperties : object.getValue().spritesProperties.entrySet()) {

					Sprite sprite = new Sprite(spriteProperties.getKey());
					sprite.spriteFile = spriteProperties.getValue()[0];
					sprite.flip = spriteProperties.getValue()[1].split(",");
					sprite.type = spriteProperties.getValue()[2].split(",");

					// Parcours des modes mirroir demandés pour chaque image
					for (String curFlip : sprite.flip) {
						logger.debug("\t"+gameMode.getValue()+"/"+object.getValue()+" Compile sprite: " + sprite.name + " image:" + sprite.spriteFile + " flip:" + curFlip);
						asm = new AssemblyGenerator(new SpriteSheet(sprite.name, sprite.spriteFile, 1, curFlip), 0);
						asmImgIndex.addLabel(sprite.name);

						// Sauvegarde du code généré pour le mode mirroir courant
						curSubSprite = new SubSprite(sprite);
						curSubSprite.setName(curFlip);
						for (String curType : sprite.type) {
							if (curType.equals("B")) {
								logger.info("\t\t- BackupBackground/Draw/Erase");
								asm.compileCode("A000");

								logger.info("Exomize ...");
								curSubSprite.bckDraw = new SubSpriteBin(curSubSprite);
								curSubSprite.bckDraw.setName("bckDraw");
								curSubSprite.bckDraw.bin = exomize(asm.getBckDrawBINFile());
								curSubSprite.bckDraw.fileIndex = new DataIndex();
								object.getValue().subSpritesBin.add(curSubSprite.bckDraw);

								curSubSprite.erase = new SubSpriteBin(curSubSprite);
								curSubSprite.erase.setName("erase");
								curSubSprite.erase.bin = exomize(asm.getEraseBINFile());
								curSubSprite.erase.fileIndex = new DataIndex();
								object.getValue().subSpritesBin.add(curSubSprite.erase);
							}

							if (curType.equals("D")) {
								logger.info("\t\t- Draw");
								// asm.compileDraw("A000");

								logger.info("Exomize ...");
								curSubSprite.draw = new SubSpriteBin(curSubSprite);
								curSubSprite.draw.setName("draw");
								curSubSprite.draw.bin = exomize(asm.getDrawBINFile());
								curSubSprite.draw.fileIndex = new DataIndex();
								object.getValue().subSpritesBin.add(curSubSprite.draw);
							}
						}

						sprite.setSubSprite(curFlip, curSubSprite);
						asmImgIndex.addFcb(new String[IMAGE_META_SIZE]);
						object.getValue().spritesRefSize += IMAGE_META_SIZE;

					}

					// Sauvegarde de tous les modes mirroir demandés pour l'image en cours
					object.getValue().sprites.put(sprite.name, sprite);
				}
				asmImgIndex.flush();

				// Génération des scripts d'animation
				AsmSourceCode asmAnimScript = new AsmSourceCode(
						getIncludeFilePath(Tags.ANIMATION_SCRIPT, gameMode.getValue(), object.getValue()));

				for (Entry<String, String[]> animationProperties : object.getValue().animationsProperties.entrySet()) {
					asmAnimScript.addLabel(animationProperties.getKey());
					int i = 0;
					asmAnimScript.addFcb(new String[i]);
					object.getValue().animationsRefSize += 1;
					for (i = 1; i < animationProperties.getValue().length - 1; i++) {
						asmAnimScript.addFdb(new String[] { animationProperties.getValue()[i] });
						object.getValue().animationsRefSize += 2;
					}
					asmAnimScript.addFcb(new String[i]);
					object.getValue().animationsRefSize += 1;
				}
				asmAnimScript.flush();
			}
		}
	}
	
	private static void compileObjectsFirstPass() throws Exception {
		logger.info("Compile Objects (First Pass) ...");

		// GAME MODE DATA - Compilation du code de chaque objet pour déterminer sa taille
		// ------------------------------------------------------------------------------

		for (Entry<String, Object> object : allObjects.entrySet()) {
			ObjectBin objectCode = new ObjectBin();
			String objectCodeTmpFile = duplicateFile(object.getValue().codeFileName, object.getKey());

			compileLIN(objectCodeTmpFile);
			objectCode.bin = Files.readAllBytes(Paths.get(getBINFileName(objectCodeTmpFile)));
			objectCode.size = objectCode.bin.length-10;
			
			if (objectCode.size > 0x4000) {
				throw new Exception("file "+objectCodeTmpFile+" is too large:"+objectCode.size+" bytes (max:"+0x4000+")");
			}
			
			object.getValue().code = objectCode;
		}			
	}
	
	private static void computeGameModeManagerSize() throws Exception {
		logger.info("Compute Game Mode Manager size ...");
		
		// Parcours des objets de tous les Game Mode pour calculer la taille de Game Mode Data
		int cur_gmd_size, gmd_size = 0;
		for(Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			cur_gmd_size = 0;
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				cur_gmd_size += 7; // Code de l'object
				cur_gmd_size += 7 * object.getValue().subSpritesBin.size(); // SubSprites

			}
			cur_gmd_size += 3; // Entete +2 et Balise de fin +1
			gmd_size += cur_gmd_size;
			gameMode.getValue().dataSize = cur_gmd_size;
		}

		// GAME MODE - compilation pour connaitre la taille Game Mode Manager + Game Mode Loader sans les DATA
		// ---------------------------------------------------------------------------------------------------
		
		// Nécessite d'avoir un fichier gmeData vide mais présent
		new AsmSourceCode(getIncludeFilePath(Tags.GME_DATA));
		
		String gameModeTmpFile = duplicateFile(game.engineAsmGameMode);
		compileRAW(gameModeTmpFile);
		game.engineAsmGameModeBytes = Files.readAllBytes(Paths.get(getBINFileName(gameModeTmpFile)));
		gm_totalSize = game.engineAsmGameModeBytes.length + gmd_size;

		if (gm_totalSize > 0x4000) {
			throw new Exception("Le fichier "+game.engineAsmGameMode+" est trop volumineux:"+gm_totalSize+" octets (max:"+0x4000+")");
		}				
	}
	
	private static void computeObjectsRamAddress() {
		logger.info("Compute Objects RAM Address ...");

		// GAME MODE DATA - Répartition des données en RAM
		// -----------------------------------------------

		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			logger.debug("Game Mode : " + gameMode.getValue().name);
			int nbGameModeItems = 0;
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				nbGameModeItems++; // Object Code
				nbGameModeItems += object.getValue().subSpritesBin.size(); // Sprites
			}
			
			// Initialise un item pour chaque élément a écrire en RAM
			Item[] items = new Item[nbGameModeItems];
			int itemIdx = 0;

			// Images & Code Objet
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				for (SubSpriteBin subSpriteBin : object.getValue().subSpritesBin) {
					items[itemIdx++] = new Item(subSpriteBin, 1); // element, priority
				}
				items[itemIdx++] = new Item(object.getValue().code, 1); // element, priority
			}

			int page = 5; // Première page disponible pour les données de Game Mode

			while (items.length > 0) {

				int address = 0xA000; // Position dans la page

				// les données sont réparties en pages en fonction de leur taille par un
				// algorithme "sac à dos"
				Knapsack knapsack = new Knapsack(items, 0x4000); // Sac à dos de poids max 16Ko
				knapsack.display();

				Solution solution = knapsack.solve();
				solution.display();

				logger.debug("Page : " + page);

				// Parcours de la solution
				for (Iterator<Item> iter = solution.items.listIterator(); iter.hasNext();) {
					Item currentItem = iter.next();
					currentItem.bin.fileIndex.page = page;
					currentItem.bin.fileIndex.address = address;
					address += currentItem.bin.bin.length;

					// construit la liste des éléments restants à organiser
					for (int i = 0; i < items.length; i++) {
						if (items[i].bin == currentItem.bin) {
							Item[] newItems = new Item[items.length - 1];
							for (int l = 0; l < i; l++) {
								newItems[l] = items[l];
							}
							for (int j = i; j < items.length - 1; j++) {
								newItems[j] = items[j + 1];
							}
							items = newItems;
							break;
						}
					}
				}
				logger.debug("Non allocated space : " + (0xDFFF - address) + " octets");
				page++;
				if (page > game.nbMaxPagesRAM) {
					logger.fatal("No more space Left on RAM !");
				}
			}

			// Game Mode Main Engine
			gameMode.getValue().fileIndex.page = 1;
			gameMode.getValue().fileIndex.address = 0x6100;
		}
	}
	
	private static void compileObjects() throws Exception {
		logger.info("Compile Objects ...");

		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {

				// Génération des index Images
				AsmSourceCode asmImgIndex = new AsmSourceCode(getIncludeFilePath(Tags.IMAGE_INDEX, gameMode.getValue(), object.getValue()));
				
				for (Entry<String, Sprite> sprite : object.getValue().sprites.entrySet()) {
					writeImgIndex(asmImgIndex, sprite.getValue());

					// Génération des index de scripts d'animation
					AsmSourceCode asmAnimScript = new AsmSourceCode(getIncludeFilePath(Tags.ANIMATION_SCRIPT, gameMode.getValue(), object.getValue()));

					for (Entry<String, String[]> animationProperties : object.getValue().animationsProperties.entrySet()) {
						asmAnimScript.addLabel(animationProperties.getKey());
						int i = 0;
						asmAnimScript.addFcb(new String[i]);
						object.getValue().animationsRefSize += 1;
						for (i = 1; i < animationProperties.getValue().length - 1; i++) {
							asmAnimScript.addFdb(new String[] { animationProperties.getValue()[i] });
							object.getValue().animationsRefSize += 2;
						}
						asmAnimScript.addFcb(new String[i]);
						object.getValue().animationsRefSize += 1;
					}
					asmAnimScript.flush();
				}
			}
		}
	}
	
	private static void compileMainEngines() {
		logger.info("Compile Main Engines ...");
		
		// Génération du code source
		// ---------------------------------------------------------------------------------------				

		for(Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			
			logger.info("Traitement du Game Mode : " + gameMode.getKey());
			
			// MAIN ENGINE - Construction de l'index des adresses de code objet pour chaque Game Mode
			// --------------------------------------------------------------------------------------
			
			// Les objets non présents dans le Game Mode sont renseignées à 0 dans la table d'adresse
			// Les ids objets doivent être une référence commune dans tout le programme
			AsmSourceCode asmObjIndex = new AsmSourceCode(getIncludeFilePath(Tags.OBJECT_INDEX, gameMode.getValue()));			
			asmObjIndex.addLabel("Obj_Index");
			for (Map.Entry<String, String[]> curObject : gameModeObjectProperties.get(curGameMode.getKey()).entrySet()) {
				asmObjIndex.addFcb(new String[] {String.format("$%1$02X", allObjectsBin.get(curObject.getKey()).fileIndex.page), String.format("$%1$02X", allObjectsBin.get(curObject.getKey()).fileIndex.address >> 8), String.format("$%1$02X", allObjectsBin.get(curObject.getKey()).fileIndex.address & 0x00FF)});
			}
			asmObjIndex.flush();		
	
			// Ajout du tag pour identifier le game mode de démarrage
			if (curGameMode.getKey().contentEquals(game.gameModeBoot)) {
				gmeData.addLabel("gmboot * @globals");
			}

			gmeData.flush();			
			
			// Initialisation des fichiers source générés
			AsmSourceCode asmPalette = new AsmSourceCode(getIncludeFilePath(Tags.PALETTE, gameMode.getValue()));
			AsmSourceCode asmImgIndex = new AsmSourceCode(getIncludeFilePath(Tags.IMAGE_INDEX, gameMode.getValue()));
			AsmSourceCode asmAnimScript = new AsmSourceCode(getIncludeFilePath(Tags.ANIMATION_SCRIPT, gameMode.getValue()));
			AsmSourceCode asmLoadAct = new AsmSourceCode(getIncludeFilePath(Tags.LOAD_ACT, gameMode.getValue()));	

			asmImgIndex.add("ImgMeta_size equ "+IMAGE_META_SIZE);			
			asmLoadAct.add("LoadAct");
			
			

			
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
		}
	}
	
	private static void writeObjects() {
		logger.info("Write Objects ...");
		
		// Toutes les images ont été compilées, compressées, on connait maintenant la taille des données
		// Game Mode Data, on réserve l'espace sur la disquette
		
		fd.setIndex(0, 0, 2);
		fd.setIndex(fd.getIndex() + gm_totalSize);
		
		// GAME MODE DATA - Ecriture sur disquette des images de sprite
		// ------------------------------------------------------------
		for (Entry<String, Sprite> sprite : allSprites.entrySet()) {
			sprite.getValue().setAllFileIndex(fd);
		}
		
		// GAME MODE DATA - Ecriture sur disquette du code des objets
		// ----------------------------------------------------------
		for (Map.Entry<String, Object> object : allObjects.entrySet()) {
			object.getValue().code.setFileIndex(fd);
		}		
		
		// GAME MODE DATA - Ecriture sur disquette des Main Engines
		// --------------------------------------------------------
		for(Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {	
			gameMode.getValue().code.setFileIndex(fd);
		}			
	}
	
	private static void compileAndWriteGameModeManager() {
		logger.info("Compile and Write Game Mode Manager ...");
		
		// GAME MODE DATA - Construction des données de chargement disquette pour chaque Game Mode
		// ---------------------------------------------------------------------------------------
		
		gmeData.addLabel("gm_" + gameMode.getKey());
		gmeData.addFdb(new String[] { "current_game_mode_data+"+gameModeDataSize.get(gameMode.getKey())});		
		
		// Parcours des objets du Game Mode
		for (Map.Entry<String, String[]> curObject : gameModeObjectProperties.get(gameMode.getKey()).entrySet()) {
			
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
		
		logger.info("\nCompilation du code de Game Mode (contient GMENGINE et GMEDATA)");
		logger.info("**************************************************************************");			

		gameModeTmpFile = duplicateFile(game.engineAsmGameMode);
		compileRAW(gameModeTmpFile);
		game.engineAsmGameModeBytes = Files.readAllBytes(Paths.get(getBINFileName(gameModeTmpFile)));

		if (game.engineAsmGameModeBytes.length > 0x4000) {
			throw new Exception("Le fichier "+game.engineAsmGameMode+" est trop volumineux:"+game.engineAsmGameModeBytes.length+" octets (max:"+0x4000+")");
		}
		
		// Ecriture sur disquette
		fd.setIndex(0, 0, 2);		
		fd.write(game.engineAsmGameModeBytes);		
			
	}
	
	private static void compileAndWriteBoot() throws IOException {
		logger.info("Compile boot ...");
		
		String bootTmpFile = duplicateFile(game.engineAsmBoot);
		glb.addConstant("boot_dernier_bloc", String.format("$%1$02X", (0xA000 + game.engineAsmGameModeBytes.length) >> 8)+"00"); // On tronque l'octet de poids faible
		glb.flush();
		compileRAW(bootTmpFile);

		// Traitement du binaire issu de la compilation et génération du secteur d'amorçage
		Bootloader bootLoader = new Bootloader();
		
		// Ecriture disquette du boot
		fd.setIndex(0, 0, 1);
		fd.write(bootLoader.encodeBootLoader(getBINFileName(bootTmpFile)));
	}
	
	private static void writeDiskImage() {
		logger.info("Write Disk Image to output file ...");
		
		fd.save(game.outputDiskName);
		fd.saveToSd(game.outputDiskName);
		
		logger.info("Play the game ... or debug ;-)");
	}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
		String[] line = new String[IMAGE_META_SIZE];
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

	/**
	 * Effectue la compilation du code assembleur
	 * 
	 * @param asmFile fichier contenant le code assembleur a compiler
	 * @return
	 */
	private static int compileLIN(String asmFile) {
		return compile(asmFile, "-bl", null);
	}

	private static int compileRAW(String asmFile) {
		return compile(asmFile, "-bd", null);
	}

	private static int compileHYB(String asmFile) {
		return compile(asmFile, "-bh", null);
	}
	
	private static int compileLIN(String asmFile, AsmInclude obj) {
		return compile(asmFile, "-bl", obj);
	}

	private static int compileRAW(String asmFile, AsmInclude obj) {
		return compile(asmFile, "-bd", obj);
	}

	private static int compileHYB(String asmFile, AsmInclude obj) {
		return compile(asmFile, "-bh", obj);
	}	

	private static int compile(String asmFile, String option, AsmInclude obj) {
		try {
			logger.debug("\t# Process "+asmFile);

			// Purge des fichiers temporaires
			Files.deleteIfExists(Paths.get(binTmpFile));
			Files.deleteIfExists(Paths.get(lstTmpFile));

			// Gestion des fichiers include
			Path path = Paths.get(asmFile);
			String content = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

			Path pathInc;

			Pattern pn = Pattern.compile("INCLUD\\s([0-9a-zA-Z]*)\\s");  
			Matcher m = pn.matcher(content);  

			// Recherche de tous les TAG INCLUD dans le fichier ASM
			while (m.find()) {
				if (game.engineLoaderAsmIncludes.get(m.group(1)) != null) {
					logger.debug("\tInclude " + m.group(1)+": "+game.engineLoaderAsmIncludes.get(m.group(1))[0]);
					pathInc = Paths.get(game.engineLoaderAsmIncludes.get(m.group(1))[0]);
					content += "\n\n(include)" + m.group(1) + "\n" + new String(Files.readAllBytes(pathInc), StandardCharsets.UTF_8);
				} else if (obj != null && obj.asmIncludes != null && obj.asmIncludes.get(m.group(1)) != null) {
					logger.debug("\tInclude " + m.group(1) + ": " + obj.asmIncludes.get(m.group(1)));
					pathInc = Paths.get(obj.asmIncludes.get(m.group(1)));
					content += "\n\n(include)" + m.group(1) + "\n" + new String(Files.readAllBytes(pathInc), StandardCharsets.UTF_8);
				} else {
					throw new Exception (m.group(1) + " not found in include declaration.");
				}
			}
			// Pour chaque TAG, ajout en fin de fichier a compiler du contenu du fichier inclus		
			Path pathTmp = Paths.get(game.generatedCodeDirName+"/"+path.getFileName().toString());
			Files.write(pathTmp, content.getBytes(StandardCharsets.UTF_8));
			// ---------------------------------------------------------------------------

			// Lancement de la compilation du fichier contenant le code de boot
			logger.debug("\t# Compile "+pathTmp.toString());
			Process p = new ProcessBuilder(game.c6809, option, pathTmp.toString(), Paths.get(binTmpFile).toString()).start();
			BufferedReader br=new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;

			while((line=br.readLine())!=null){
				logger.debug("\t"+line);
			}

			// c6809.exe bugfix: retour du processus vaut 0 méme en cas d'erreur
			// de compilation, on lit le lst pour compter les erreurs
			p.waitFor();
			int result = C6809Util.countErrors(lstTmpFile);

			if (result == 0) {
				// Purge et remplacement de l'ancien fichier lst
				File lstFile = new File(lstTmpFile); 
				String basename = FileUtil.removeExtension(pathTmp.getFileName().toString());
				String destFileName = game.generatedCodeDirName+"/"+basename+".lst";
				Path lstFilePath = Paths.get(destFileName);
				Files.deleteIfExists(lstFilePath);
				File newLstFile = new File(destFileName);
				lstFile.renameTo(newLstFile);
				
				// Sauvegarde des variables globales
				String contentLst = new String(Files.readAllBytes(Paths.get(destFileName)), StandardCharsets.UTF_8);
				pn = Pattern.compile("([0-9a-zA-Z_]*).*@globals.*") ;  
				m = pn.matcher(content);
				Pattern pn2;
				Matcher m2;

				// Recherche de tous les @globals dans le fichier ASM
				while (m.find()) {
					pn2 = Pattern.compile("(Label|Equ)\\s*([0-9a-fA-F]*)\\s"+m.group(1));
					m2 = pn2.matcher(contentLst);  
					if (m2.find() == false) {
						throw new Exception (m.group(1) + " not found in Symbols.");
					} else {
						logger.debug("\t@globals: " + m.group(1)+" value: " + m2.group(2));
						glb.addConstant(m.group(1), "$"+m2.group(2));
					}
				}
				glb.flush();

				// Purge et remplacement de l'ancien fichier bin
				File binFile = new File(binTmpFile); 
				basename = FileUtil.removeExtension(pathTmp.getFileName().toString());
				destFileName = game.generatedCodeDirName+"/"+basename+".BIN";
				Path binFilePath = Paths.get(destFileName);
				Files.deleteIfExists(binFilePath);
				File newBinFile = new File(destFileName);
				binFile.renameTo(newBinFile);

				logger.debug("\t"+destFileName + " cycles: " + C6809Util.countCycles(newLstFile.getAbsoluteFile().toString()) + " BIN size: " + newBinFile.length());
			} else {
				throw new Exception ("Error "+pathTmp.getFileName().toString());
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
			String destFileName = game.generatedCodeDirName+"/"+basename+".EXO";

			// Purge des fichiers temporaires
			Files.deleteIfExists(Paths.get(destFileName));

			// Lancement de la compilation du fichier contenant le code de boot
			logger.debug("**************** EXOMIZE "+binFile+" ****************");
			Process p = new ProcessBuilder(Game.exobin, "", Paths.get(binFile).toString()).start();
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

	public static String duplicateFile(String fileName) throws IOException {
		String basename = FileUtil.removeExtension(Paths.get(fileName).getFileName().toString());
		String destFileName = game.generatedCodeDirName+"/"+basename+".asm";

		Path original = Paths.get(fileName);        
		Path copied = Paths.get(destFileName);
		Files.copy(original, copied, StandardCopyOption.REPLACE_EXISTING);
		return destFileName;
	}
	
	public static String duplicateFile(String fileName, String subDir) throws IOException {
		String basename = FileUtil.removeExtension(Paths.get(fileName).getFileName().toString());
		String destFileName = game.generatedCodeDirName+"/"+subDir+"/"+basename+".asm";

		// Creation du chemin si les répertoires sont manquants
		File file = new File (destFileName);
		file.getParentFile().mkdirs();
		
		Path original = Paths.get(fileName);        
		Path copied = Paths.get(destFileName);
		Files.copy(original, copied, StandardCopyOption.REPLACE_EXISTING);
		return destFileName;
	}	

	public static String getBINFileName (String name) {
		return game.generatedCodeDirName+"/"+FileUtil.removeExtension(Paths.get(name).getFileName().toString())+".BIN";
	}

	public static String getEXOFileName (String name) {
		return game.generatedCodeDirName+"/"+FileUtil.removeExtension(Paths.get(name).getFileName().toString())+".EXO";
	}
	
	public static Path getIncludeFilePath (String tag) throws Exception {	
		if (game.engineLoaderAsmIncludes.get(tag) == null) {
			throw new Exception (tag+" not found in include declaration.");
		}		
		return Paths.get(game.engineLoaderAsmIncludes.get(tag)[0]);
	}
	
	public static Path getIncludeFilePath (String tag, AsmInclude obj) throws Exception {	
		if (obj.asmIncludes.get(tag) == null) {
			throw new Exception (tag+" not found in include declaration : "+obj);
		}
		
		// Creation du chemin si les répertoires sont manquants
		File file = new File (game.generatedCodeDirName+"/"+obj.name+"/"+obj.asmIncludes.get(tag));
		file.getParentFile().mkdirs();
		
		return Paths.get(game.generatedCodeDirName+"/"+obj.name+"/"+obj.asmIncludes.get(tag));
	}
	
	public static Path getIncludeFilePath (String tag, AsmInclude parent, AsmInclude obj) throws Exception {	
		if (obj.asmIncludes.get(tag) == null) {
			throw new Exception (tag+" not found in include declaration : "+obj);
		}
		
		// Creation du chemin si les répertoires sont manquants
		File file = new File (game.generatedCodeDirName+"/"+parent.name+"/"+obj.name+"/"+obj.asmIncludes.get(tag));
		file.getParentFile().mkdirs();
		
		return Paths.get(game.generatedCodeDirName+"/"+parent.name+"/"+obj.name+"/"+obj.asmIncludes.get(tag));
	}			
}

// Traitement de l'image pour l'écran de démarrage
// ***********************************************

//				PngToBottomUpBinB16 initVideo = new PngToBottomUpBinB16(initVideoFile);
//				byte[] initVideoBIN = initVideo.getBIN();
//
//				fd.setIndex(0, 4, 1);
//				fd.write(initVideoBIN);

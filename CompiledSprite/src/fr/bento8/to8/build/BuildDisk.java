package fr.bento8.to8.build;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
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

import fr.bento8.to8.audio.Sound;
import fr.bento8.to8.audio.SoundBin;
import fr.bento8.to8.boot.Bootloader;
import fr.bento8.to8.compiledSprite.backupDrawErase.AssemblyGenerator;
import fr.bento8.to8.compiledSprite.draw.SimpleAssemblyGenerator;
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
			
			// load object sounds
			processSounds();
			
			// generate compilated sprites and compute size of all asm code 
			compileSprites();
			compileMainEnginesFirstPass();			
			compileObjectsFirstPass();
			computeGameModeManagerSize();
			
			// compute RAM destination for all asm code
			computeObjectsRamAddress();
			
			// compile all asm code
			compileMainEngines();
			compileObjects();
			
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
		glb = new AsmSourceCode(getIncludeFilePath(Tags.GLOBALS, game));	
	}
	
	private static void compileGameModeLoader() throws IOException {
		logger.info("Compile Game Mode Loader ...");

		String engineAsmIncludeTmpFile = duplicateFile(game.engineAsmGameModeLoader);
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
					object.getValue().id = objIndex;
					logger.debug("\t\tObjID_"+object.getKey()+" "+Integer.toString(objIndex));
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
			asmObjIndex.addLabel("Obj_Index_Page");
			asmObjIndex.addLabel("Obj_Index_Address");
			asmObjIndex.flush();		
			
			AsmSourceCode asmLoadAct = new AsmSourceCode(getIncludeFilePath(Tags.LOAD_ACT, gameMode.getValue()));
			asmLoadAct.add("LoadAct");
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
	
	private static void processSounds() throws Exception {
		logger.info("Process Sounds ...");

		// GAME MODE DATA - Chargement des données audio
		// ---------------------------------------------
		
		// Parcours de tous les objets de chaque Game Mode
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			AsmSourceCode asmSndIndex = new AsmSourceCode(getIncludeFilePath(Tags.SOUND_INDEX, gameMode.getValue()));
			
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {

				// Parcours des données audio de l'objet
				for (Entry<String, String[]> soundsProperties : object.getValue().soundsProperties.entrySet()) {

					Sound sound = new Sound(soundsProperties.getKey());
					sound.soundFile = soundsProperties.getValue()[0];
					sound.setAllBinaries(sound.soundFile);
					object.getValue().sounds.add(sound);
					
					asmSndIndex.addLabel(sound.name);		
					for (int i=0; i < sound.sb.size(); i++) {
						asmSndIndex.addFcb(new String[] {"$00", "$00", "$00", "$00", "$00"});
					}
					asmSndIndex.addFcb(new String[] {"$FF"});
				}
			}
			asmSndIndex.flush();	
		}
	}
	
	private static void compileSprites() throws Exception {
		logger.info("Compile Sprites ...");

		// GAME MODE DATA - Génération des sprites compilés pour chaque objet
		// ------------------------------------------------------------------
		AssemblyGenerator asm;
		SimpleAssemblyGenerator sasm;

		// génération du sprite compilé
		SubSprite curSubSprite;
		
		// Parcours de tous les objets de chaque Game Mode
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {

			AsmSourceCode asmImgIndex = new AsmSourceCode(getIncludeFilePath(Tags.IMAGE_INDEX, gameMode.getValue()));
			AsmSourceCode asmAnimScript = new AsmSourceCode(getIncludeFilePath(Tags.ANIMATION_SCRIPT, gameMode.getValue()));			
			
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {

				// Parcours des images de l'objet et compilation de l'image
				for (Entry<String, String[]> spriteProperties : object.getValue().spritesProperties.entrySet()) {

					Sprite sprite = new Sprite(spriteProperties.getKey());
					sprite.spriteFile = spriteProperties.getValue()[0];
					String[] spriteVariants = spriteProperties.getValue()[1].split(",");

					// Parcours des différents rendus demandés pour chaque image
					for (String cur_variant : spriteVariants) {
						logger.debug("\t"+gameMode.getValue()+"/"+object.getValue()+" Compile sprite: " + sprite.name + " image:" + sprite.spriteFile + " variant:" + cur_variant);

						// Sauvegarde du code généré pour la variante
						curSubSprite = new SubSprite(sprite);
						curSubSprite.setName(cur_variant);
						if (cur_variant.contains("B")) {
							logger.debug("\t\t- BackupBackground/Draw/Erase");
							asm = new AssemblyGenerator(new SpriteSheet(sprite.name, sprite.spriteFile, 1, cur_variant),
									Game.generatedCodeDirName + "/" + object.getValue().name, 0);
							asm.compileCode("A000");
							// La valeur 64 doit être ajustée dans MainEngine.asm si modifiée TODO : rendre paramétrable
							// 16 octets supplémentaires pour IRQ 12 octets du bckp registres et 4 pour les appels sous programmes
							// A rendre paramétrable aussi
							curSubSprite.nb_cell = (asm.getEraseDataSize() + 16 + 64 - 1) / 64;
							curSubSprite.x1_offset = asm.getX1_offset();
							curSubSprite.y1_offset = asm.getY1_offset();
							curSubSprite.x_size = asm.getX_size();
							curSubSprite.y_size = asm.getY_size();

							logger.debug("Exomize ...");
							curSubSprite.draw = new SubSpriteBin(curSubSprite);
							curSubSprite.draw.setName("bckDraw");
							curSubSprite.draw.bin = exomize(asm.getBckDrawBINFile());
							curSubSprite.draw.fileIndex = new DataIndex();
							curSubSprite.draw.uncompressedSize = asm.getDSize();
							object.getValue().subSpritesBin.add(curSubSprite.draw);

							curSubSprite.erase = new SubSpriteBin(curSubSprite);
							curSubSprite.erase.setName("erase");
							curSubSprite.erase.bin = exomize(asm.getEraseBINFile());
							curSubSprite.erase.fileIndex = new DataIndex();
							curSubSprite.erase.uncompressedSize = asm.getESize();
							object.getValue().subSpritesBin.add(curSubSprite.erase);
						}

						if (cur_variant.contains("D")) {
							logger.debug("\t\t- Draw");
							sasm = new SimpleAssemblyGenerator(
									new SpriteSheet(sprite.name, sprite.spriteFile, 1, cur_variant),
									Game.generatedCodeDirName + "/" + object.getValue().name, 0);
							sasm.compileCode("A000");
							curSubSprite.nb_cell = 0;
							curSubSprite.x1_offset = sasm.getX1_offset();
							curSubSprite.y1_offset = sasm.getY1_offset();
							curSubSprite.x_size = sasm.getX_size();
							curSubSprite.y_size = sasm.getY_size();

							logger.debug("Exomize ...");
							curSubSprite.draw = new SubSpriteBin(curSubSprite);
							curSubSprite.draw.setName("draw");
							curSubSprite.draw.bin = exomize(sasm.getDrawBINFile());
							curSubSprite.draw.fileIndex = new DataIndex();
							curSubSprite.draw.uncompressedSize = sasm.getDSize();
							object.getValue().subSpritesBin.add(curSubSprite.draw);
						}

						sprite.subSprites.put(cur_variant, curSubSprite);
					}

					// Sauvegarde de tous les rendus demandés pour l'image en cours
					object.getValue().sprites.put(sprite.name, sprite);
					writeImgIndex(asmImgIndex, sprite);
				}

				for (Entry<String, String[]> animationProperties : object.getValue().animationsProperties.entrySet()) {
					int i = 0;
					asmAnimScript.addFcb(new String[] {"00"});
					asmAnimScript.addLabel(animationProperties.getKey()+" *@globals");					
					for (i = 1; i < animationProperties.getValue().length - 1; i++) {
						asmAnimScript.addFdb(new String[] { animationProperties.getValue()[i] });
					}
					asmAnimScript.addFcb(new String[] {"00"});
				}
			}
			
			asmImgIndex.flush();				
			asmAnimScript.flush();			
		}
	}
	
	private static void compileObjectsFirstPass() throws Exception {
		logger.info("Compile Objects (First Pass) ...");

		// GAME MODE DATA - Compilation du code de chaque objet pour déterminer sa taille
		// ------------------------------------------------------------------------------

		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				ObjectBin objectCode = new ObjectBin();
				String objectCodeTmpFile = duplicateFile(object.getValue().codeFileName, gameMode.getKey()+"/"+object.getKey());

				compileLIN(objectCodeTmpFile, object.getValue());
				objectCode.bin = Files.readAllBytes(Paths.get(getBINFileName(objectCodeTmpFile)));
				objectCode.uncompressedSize = objectCode.bin.length-10;
			
				if (objectCode.uncompressedSize > 0x4000) {
					throw new Exception("file "+objectCodeTmpFile+" is too large:"+objectCode.uncompressedSize+" bytes (max:"+0x4000+")");
				}

				object.getValue().code = objectCode;
				object.getValue().code.fileIndex = new DataIndex();
			}
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
				for (Sound sound : object.getValue().sounds) { // Sounds
					cur_gmd_size += 7 * sound.sb.size();
				}
			}
			cur_gmd_size += 10; // Entete +2, Balise de fin +1, Main engine +7
			gmd_size += cur_gmd_size;
			gameMode.getValue().dataSize = cur_gmd_size;
		}

		// GAME MODE - compilation pour connaitre la taille Game Mode Manager + Game Mode Loader sans les DATA
		// ---------------------------------------------------------------------------------------------------
		
		// Nécessite d'avoir un fichier gmeData vide mais présent
		new AsmSourceCode(getIncludeFilePath(Tags.GMDATA, game));
		
		String gameModeTmpFile = duplicateFile(game.engineAsmGameModeManager);
		compileRAW(gameModeTmpFile);
		game.engineAsmGameModeManagerBytes = Files.readAllBytes(Paths.get(getBINFileName(gameModeTmpFile)));
		gm_totalSize = game.engineAsmGameModeManagerBytes.length + gmd_size;

		if (gm_totalSize > 0x4000) {
			throw new Exception("Le fichier "+game.engineAsmGameModeManager+" est trop volumineux:"+gm_totalSize+" octets (max:"+0x4000+")");
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
				for (Sound sound : object.getValue().sounds) {
						nbGameModeItems += sound.sb.size();
				}	
			}
			
			// Initialise un item pour chaque élément a écrire en RAM
			Item[] items = new Item[nbGameModeItems];
			int itemIdx = 0;

			// Images & Code Objet
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				for (SubSpriteBin subSpriteBin : object.getValue().subSpritesBin) {
					items[itemIdx++] = new Item(subSpriteBin, 1); // element, priority
				}
				for (Sound sound : object.getValue().sounds) {
					for (SoundBin soundBin : sound.sb) {
						items[itemIdx++] = new Item(soundBin, 1); // element, priority
					}
				}				
				items[itemIdx++] = new Item(object.getValue().code, 1); // element, priority
			}

			int page = 5; // Première page disponible pour les données de Game Mode

			while (items.length > 0) {

				int address = 0xA000; // Position dans la page

				// les données sont réparties en pages en fonction de leur taille par un
				// algorithme "sac à dos"
				Knapsack knapsack = new Knapsack(items, 0x4000); // Sac à dos de poids max 16Ko

				Solution solution = knapsack.solve();
				logger.debug("*** Find solution for page : " + page);

				// Parcours de la solution
				for (Iterator<Item> iter = solution.items.listIterator(); iter.hasNext();) {
					Item currentItem = iter.next();
					currentItem.bin.fileIndex.page = page;
					currentItem.bin.fileIndex.address = address;
					address += currentItem.bin.uncompressedSize;
					currentItem.bin.fileIndex.endAddress = address;					

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
				logger.debug("*** Non allocated space on page "+page+" : " + (0xE000 - address) + " octets");
				page++;
				if (page > game.nbMaxPagesRAM) {
					logger.fatal("No more space Left on RAM !");
				}
			}
		}
	}
	
	private static void compileObjects() throws Exception {
		logger.info("Compile Objects ...");

		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				
				// Compilation du code Objet
				String objectCodeTmpFile = duplicateFile(object.getValue().codeFileName, gameMode.getKey()+"/"+object.getKey());

				compileLIN(objectCodeTmpFile, object.getValue());
				byte[] bin = Files.readAllBytes(Paths.get(getBINFileName(objectCodeTmpFile)));
				object.getValue().code.uncompressedSize = bin.length-10;
				
				if (object.getValue().code.uncompressedSize > 0x4000) {
					throw new Exception("file "+objectCodeTmpFile+" is too large:"+object.getValue().code.uncompressedSize+" bytes (max:"+0x4000+")");
				}
				
				exomize(getBINFileName(objectCodeTmpFile));
				object.getValue().code.bin = Files.readAllBytes(Paths.get(getEXOFileName(objectCodeTmpFile)));
			}
		}
	}
	
	private static void compileMainEngines() throws Exception {
		logger.info("Compile Main Engines ...");
		
		for(Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			logger.debug("Game Mode : " + gameMode.getKey());
			
			// MAIN ENGINE - Construction de l'index des adresses de code objet pour chaque Game Mode
			// --------------------------------------------------------------------------------------
			
			// Les objets non présents dans le Game Mode sont renseignées à 0 dans la table d'adresse
			// Les ids objets doivent être une référence commune dans tout le programme
			AsmSourceCode asmObjIndex = new AsmSourceCode(getIncludeFilePath(Tags.OBJECT_INDEX, gameMode.getValue()));			

			String[][] objIndexPage = new String[256][];
			String[][] objIndex = new String[256][];			
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				objIndexPage[allObjects.get(object.getValue().name).id] = new String[] {String.format("$%1$02X", object.getValue().code.fileIndex.page)};
				objIndex[allObjects.get(object.getValue().name).id] = new String[] {String.format("$%1$02X", object.getValue().code.fileIndex.address >> 8),
   						String.format("$%1$02X", object.getValue().code.fileIndex.address & 0x00FF)};
				
			}
			
			asmObjIndex.addLabel("Obj_Index_Page");			
			for (int i = 0; i < 256; i++) {
				if (objIndexPage[i] == null) {
					objIndexPage[i] = new String[] {"$00"};
				}
				asmObjIndex.addFcb(objIndexPage[i]);
			}
			
			asmObjIndex.addLabel("Obj_Index_Address");
			for (int i = 0; i < 256; i++) {
				if (objIndex[i] == null) {
					objIndex[i] = new String[] {"$00", "$00"};
				}
				asmObjIndex.addFcb(objIndex[i]);
			}
			
			asmObjIndex.flush();		

			// MAIN ENGINE - Dynamic code
			// --------------------------------------------------------------------------------------			
			String mainEngineTmpFile = duplicateFile(gameMode.getValue().engineAsmMainEngine, gameMode.getKey());
			String content = "\n";
			
			// MAIN ENGINE - Palettes
			// --------------------------------------------------------------------------------------			
			AsmSourceCode asmPalette = new AsmSourceCode(getIncludeFilePath(Tags.PALETTE, gameMode.getValue()));
			
			for (Entry<String, Palette> palette : gameMode.getValue().palettes.entrySet()) {
				asmPalette.addLabel(palette.getValue().name + " * @globals");
				asmPalette.add(PaletteTO8.getPaletteData(palette.getValue().fileName));
				asmPalette.flush();
			}
			
			// MAIN ENGINE - Code d'initialisation de l'Acte
			// --------------------------------------------------------------------------------------
			AsmSourceCode asmLoadAct = new AsmSourceCode(getIncludeFilePath(Tags.LOAD_ACT, gameMode.getValue()));
			asmLoadAct.add("LoadAct");
			
			if (gameMode.getValue().actBoot != null) {
				Act act = gameMode.getValue().acts.get(gameMode.getValue().actBoot);

				if (act != null) {
					if (act.bgColorIndex != null) {
						asmLoadAct.add("        ldx   #"+String.format("$%1$01X%1$01X%1$01X%1$01X", Integer.parseInt(act.bgColorIndex))+"                   * set Background solid color");
						asmLoadAct.add("        ldb   #$62                     * load page 2");						
						asmLoadAct.add("        stb   $E7E6                    * in cartridge space ($0000-$3FFF)");
						asmLoadAct.add("        jsr   ClearCartMem");
					}					

					if (act.screenBorder != null) {
						asmLoadAct.add("        lda   $E7DD                    * set border color");
						asmLoadAct.add("        anda  #$F0");
						asmLoadAct.add("        adda  #"+String.format("$%1$02X", Integer.parseInt(act.screenBorder))+"                     * color ref");
						asmLoadAct.add("        sta   $E7DD");
						asmLoadAct.add("        anda  #$0F");
						asmLoadAct.add("        adda  #$80");
						asmLoadAct.add("        sta   screen_border_color+1    * maj WaitVBL");
					}

					if (act.bgColorIndex != null) {
						asmLoadAct.add("        jsr   WaitVBL");						
						asmLoadAct.add("        ldx   #"+String.format("$%1$01X%1$01X%1$01X%1$01X", Integer.parseInt(act.bgColorIndex))+"                   * set Background solid color");
						asmLoadAct.add("        ldb   #$63                     * load page 3");						
						asmLoadAct.add("        stb   $E7E6                    * in cardtridge space ($0000-$3FFF)");
						asmLoadAct.add("        jsr   ClearCartMem");						

						content += "        INCLUD CLRCARTM\n";
					}

					if (act.bgFileName != null) {
						asmLoadAct.add("        ldu   #$0000");
						asmLoadAct.add("        jsr   CopyImageToCart");

						content += "        INCLUD CPYIMG\n";
					}
					
					if (act.paletteName != null) {
						asmLoadAct.add("        ldd   #" + act.paletteName);
						asmLoadAct.add("        std   Ptr_palette");
						asmLoadAct.add("        jsr   UpdatePalette");

						content += "        INCLUD PALETTE\n";
						content += "        INCLUD UPDTPAL\n";
					}
				}
			}
			
			asmLoadAct.add("        rts");
			asmLoadAct.flush();			
			
			AsmSourceCode asmImgIndex = new AsmSourceCode(getIncludeFilePath(Tags.IMAGE_INDEX, gameMode.getValue()));			
			AsmSourceCode asmAnimScript = new AsmSourceCode(getIncludeFilePath(Tags.ANIMATION_SCRIPT, gameMode.getValue()));	
			AsmSourceCode asmSndIndex = new AsmSourceCode(getIncludeFilePath(Tags.SOUND_INDEX, gameMode.getValue()));
			
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {

				// MAIN ENGINE - Génération des index Images
				// --------------------------------------------------------------------------------------
				for (Entry<String, Sprite> sprite : object.getValue().sprites.entrySet()) {
					writeImgIndex(asmImgIndex, sprite.getValue());
				}

				// MAIN ENGINE - Génération des index de scripts d'animation
				// --------------------------------------------------------------------------------------
				for (Entry<String, String[]> animationProperties : object.getValue().animationsProperties.entrySet()) {
					int i = 0;
					asmAnimScript.addFcb(new String[] { animationProperties.getValue()[i] });
					asmAnimScript.addLabel(animationProperties.getKey()+" *@globals");
					for (i = 1; i < animationProperties.getValue().length - 1; i++) {
						asmAnimScript.addFdb(new String[] { animationProperties.getValue()[i] });
					}
					asmAnimScript.addFcb(new String[] { animationProperties.getValue()[i] });
				}
				
				// MAIN ENGINE - Génération des index Audio
				// --------------------------------------------------------------------------------------
				for (Sound sound : object.getValue().sounds) {
					writeSndIndex(asmSndIndex, sound);
				}				
			}
			asmImgIndex.flush();
			asmAnimScript.flush();	
			asmSndIndex.flush();
			
			// MAIN ENGINE - Compilation des Main Engines
			// --------------------------------------------------------------------------------------			
			Files.write(Paths.get(mainEngineTmpFile), content.getBytes(StandardCharsets.ISO_8859_1), StandardOpenOption.APPEND);
			
			compileLIN(mainEngineTmpFile, gameMode.getValue());
			byte[] binBytes = Files.readAllBytes(Paths.get(getBINFileName(mainEngineTmpFile)));

			if (binBytes.length - 10 > 0x4000) {
				throw new Exception("file " + gameMode.getValue().engineAsmMainEngine + " is too large:" + (binBytes.length - 10) + " bytes (max:"+0x4000+")");
			}
			
			exomize(getBINFileName(mainEngineTmpFile));
			gameMode.getValue().code = new ObjectBin();
			gameMode.getValue().code.bin = Files.readAllBytes(Paths.get(getEXOFileName(mainEngineTmpFile)));
			gameMode.getValue().code.fileIndex = new DataIndex();
			gameMode.getValue().code.fileIndex.page = 1;
			gameMode.getValue().code.fileIndex.address = 0x6100;			
			gameMode.getValue().code.fileIndex.endAddress = 0x6100 + binBytes.length - 10;
		}
	}
	
	private static void writeObjects() {
		logger.info("Write Objects ...");
		
		// Toutes les images ont été compilées, compressées, on connait maintenant la
		// taille des données Game Mode Data, on réserve l'espace sur la disquette

		fd.setIndex(0, 0, 2);
		fd.setIndex(fd.getIndex() + gm_totalSize);

		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {

				// GAME MODE DATA - Ecriture sur disquette des images de sprite
				// ------------------------------------------------------------
				for (Entry<String, Sprite> sprite : object.getValue().sprites.entrySet()) {
					sprite.getValue().setAllFileIndex(fd);
				}
				
				// GAME MODE DATA - Ecriture sur disquette des données audio
				// ---------------------------------------------------------
				for (Sound sound : object.getValue().sounds) {
					sound.setAllFileIndex(fd);
				}				

				// GAME MODE DATA - Ecriture sur disquette du code des objets
				// ----------------------------------------------------------
				object.getValue().code.setFileIndex(fd);

				// GAME MODE DATA - Ecriture sur disquette des Main Engines
				// --------------------------------------------------------
				gameMode.getValue().code.setFileIndex(fd);
			}
		}
	}
	
	private static void compileAndWriteGameModeManager() throws Exception {
		logger.info("Compile and Write Game Mode Manager ...");

		// GAME MODE DATA - Construction des données de chargement disquette pour chaque Game Mode
		// ---------------------------------------------------------------------------------------
		AsmSourceCode gmeData = new AsmSourceCode(getIncludeFilePath(Tags.GMDATA, game));
		gmeData.addCommentLine("structure: sector, nb sector, drive (bit 7) track (bit 6-0), end offset, ram dest page, ram dest end addr. hb, ram dest end addr. lb");
		
		// Parcours des objets du Game Mode
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			
			gmeData.addLabel("gm_" + gameMode.getKey());
			gmeData.addFdb(new String[] { "current_game_mode_data+"+(gameMode.getValue().dataSize-2+6+1)}); // -2 index, +6 balise FF (lecture par groupe de 7 octets), +1 balise FF ajoutée par le GameModeManager au runtime	
			
			// Ajout du tag pour identifier le game mode de démarrage
			if (gameMode.getKey().contentEquals(game.gameModeBoot)) {
				gmeData.addLabel("gmboot * @globals");
			}
			
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				for (Entry<String, Sprite> sprite : object.getValue().sprites.entrySet()) {
					for (Entry<String, SubSprite> subSprite : sprite.getValue().subSprites.entrySet()) {
						extractSubSpriteFileIndex(subSprite.getValue(), gmeData, sprite.getKey()+" "+subSprite.getValue().name);
					}
				}
				
				for (Sound sound : object.getValue().sounds) {
					for (SoundBin sb : sound.sb) {
						gmeData.addFcb(new String[] {
						String.format("$%1$02X", sb.fileIndex.sector),
						String.format("$%1$02X", sb.fileIndex.nbSector-1),
						String.format("$%1$02X", (sb.fileIndex.drive << 7)+sb.fileIndex.track),				
						String.format("$%1$02X", -sb.fileIndex.endOffset & 0xFF),
						String.format("$%1$02X", sb.fileIndex.page),	
						String.format("$%1$02X", sb.fileIndex.endAddress >> 8),			
						String.format("$%1$02X", sb.fileIndex.endAddress & 0x00FF)});			
						gmeData.appendComment(sound.name + sound.sb.indexOf(sb) + " Sound");						
					}
				}
				
				// Code de l'objet
				gmeData.addFcb(new String[] {
				String.format("$%1$02X", object.getValue().code.fileIndex.sector),
				String.format("$%1$02X", object.getValue().code.fileIndex.nbSector-1),
				String.format("$%1$02X", (object.getValue().code.fileIndex.drive << 7)+object.getValue().code.fileIndex.track),				
				String.format("$%1$02X", -object.getValue().code.fileIndex.endOffset & 0xFF),
				String.format("$%1$02X", object.getValue().code.fileIndex.page),	
				String.format("$%1$02X", object.getValue().code.fileIndex.endAddress >> 8),			
				String.format("$%1$02X", object.getValue().code.fileIndex.endAddress & 0x00FF)});			
				gmeData.appendComment(object.getValue().name+ " Object code");
			}
			
			// Code main engine
			gmeData.addFcb(new String[] {
			String.format("$%1$02X", gameMode.getValue().code.fileIndex.sector),
			String.format("$%1$02X", gameMode.getValue().code.fileIndex.nbSector-1),
			String.format("$%1$02X", (gameMode.getValue().code.fileIndex.drive << 7)+gameMode.getValue().code.fileIndex.track),			
			String.format("$%1$02X", -gameMode.getValue().code.fileIndex.endOffset & 0xFF),
			String.format("$%1$02X", gameMode.getValue().code.fileIndex.page),	
			String.format("$%1$02X", gameMode.getValue().code.fileIndex.endAddress >> 8),			
			String.format("$%1$02X", gameMode.getValue().code.fileIndex.endAddress & 0x00FF)});			
			gmeData.appendComment(gameMode.getValue().name+ " Main Engine code");			
		}
		
		gmeData.addFcb(new String[] { "$FF" });		
		gmeData.flush();
		
		// GAME MODE DATA - Compilation du Game Mode Manager
		// -------------------------------------------------		

		String gameModeManagerTmpFile = duplicateFile(game.engineAsmGameModeManager);
		compileRAW(gameModeManagerTmpFile);
		game.engineAsmGameModeManagerBytes = Files.readAllBytes(Paths.get(getBINFileName(gameModeManagerTmpFile)));

		if (game.engineAsmGameModeManagerBytes.length > 0x4000) {
			throw new Exception("Le fichier "+game.engineAsmGameModeManager+" est trop volumineux:"+game.engineAsmGameModeManagerBytes.length+" octets (max:"+0x4000+")");
		}
		
		// Ecriture sur disquette
		fd.setIndex(0, 0, 2);		
		fd.write(game.engineAsmGameModeManagerBytes);		
			
	}
	
	private static void compileAndWriteBoot() throws IOException {
		logger.info("Compile boot ...");
		
		String bootTmpFile = duplicateFile(game.engineAsmBoot);
		glb.addConstant("boot_dernier_bloc", String.format("$%1$02X", (0xA000 + game.engineAsmGameModeManagerBytes.length) >> 8)+"00"); // On tronque l'octet de poids faible
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

	
	//* Sound PCM
	//Pcm_TitleScreen
	//        fcb   $00,$00,$00,$00,$00 * page, adresse debut, adresse fin
	//        fcb   $00,$00,$00,$00,$00 * page, adresse debut, adresse fin
	//        fcb   $00,$00,$00,$00,$00 * page, adresse debut, adresse fin
	//        fcb   $FF                 * end flag    
	
	// + enregistrer le binaire dans les pages RAM en complétant le vide laissé dans chaque page !
	
	private static void extractSubSpriteFileIndex(SubSprite sub, AsmSourceCode gmeData, String spriteTag) throws Exception {
		if (sub != null) {
			processFileIndex(sub.draw, gmeData, spriteTag+" Draw");
			processFileIndex(sub.erase, gmeData, spriteTag+" Erase");
		}
	}

	private static void processFileIndex(SubSpriteBin ssBin, AsmSourceCode gmeData, String spriteTag) throws Exception {
		if (ssBin != null && ssBin.fileIndex != null) {
			String[] line = new String[7];			
			line [0] = String.format("$%1$02X", ssBin.fileIndex.sector);
			line [1] = String.format("$%1$02X", ssBin.fileIndex.nbSector-1);
			line [2] = String.format("$%1$02X", (ssBin.fileIndex.drive << 7)+ssBin.fileIndex.track);			
			line [3] = String.format("$%1$02X", -ssBin.fileIndex.endOffset & 0xFF);
			line [4] = String.format("$%1$02X", ssBin.fileIndex.page);			
			line [5] = String.format("$%1$02X", ssBin.fileIndex.endAddress >> 8);			
			line [6] = String.format("$%1$02X", ssBin.fileIndex.endAddress & 0x00FF);			
			gmeData.addFcb(line);		
			gmeData.appendComment(spriteTag);
		}
	}
	
	private static void writeImgIndex(AsmSourceCode asmImgIndex, Sprite sprite) {
		
		// Sorry for this code ... should be a better way of doing that
		// Note : index to image sub set is limited to an offset of +127
		// this version go up to +102 so it's fine
		
		List<String> line = new ArrayList<String>();
		int imageSet_header = 6, imageSubSet_header = 6;
		int x_size = 0;
		int y_size = 0;
		int n_offset = 0;
		int n_x1 = 0;
		int n_y1 = 0;
		int x_offset = 0;
		int x_x1 = 0;
		int x_y1 = 0;		
		int y_offset = 0;
		int y_x1 = 0;
		int y_y1 = 0;		
		int xy_offset = 0;
		int xy_x1 = 0;
		int xy_y1 = 0;		
		int nb0_offset = 0;
		int nd0_offset = 0;
		int nb1_offset = 0;
		int nd1_offset = 0;
		int xb0_offset = 0;
		int xd0_offset = 0;
		int xb1_offset = 0;
		int xd1_offset = 0;
		int yb0_offset = 0;
		int yd0_offset = 0;
		int yb1_offset = 0;
		int yd1_offset = 0;
		int xyb0_offset = 0;
		int xyd0_offset = 0;
		int xyb1_offset = 0;
		int xyd1_offset = 0;		
		
		asmImgIndex.addLabel(sprite.name+" *@globals");		
		
		if (sprite.subSprites.containsKey("NB0") || sprite.subSprites.containsKey("ND0") || sprite.subSprites.containsKey("NB1") || sprite.subSprites.containsKey("ND1")) {
			n_offset = imageSet_header;			
		}

		if (sprite.subSprites.containsKey("NB0")) {
			nb0_offset = imageSubSet_header;
			n_x1 = sprite.subSprites.get("NB0").x1_offset;
			n_y1 = sprite.subSprites.get("NB0").y1_offset;
		}
		
		if (sprite.subSprites.containsKey("ND0")) {
			nd0_offset = (nb0_offset>0?7:0) + imageSubSet_header;
			n_x1 = sprite.subSprites.get("ND0").x1_offset;	
			n_y1 = sprite.subSprites.get("ND0").y1_offset;
		}

		if (sprite.subSprites.containsKey("NB1")) {
			nb1_offset = (nd0_offset>0?3:0) + (nb0_offset>0?7:0) + imageSubSet_header;
			n_x1 = sprite.subSprites.get("NB1").x1_offset;
			n_y1 = sprite.subSprites.get("NB1").y1_offset;
		}
		
		if (sprite.subSprites.containsKey("ND1")) {
			nd1_offset = (nb1_offset>0?7:0) + (nd0_offset>0?3:0) + (nb0_offset>0?7:0) + imageSubSet_header;
			n_x1 = sprite.subSprites.get("ND1").x1_offset;
			n_y1 = sprite.subSprites.get("ND1").y1_offset;
		}		
		
		if (sprite.subSprites.containsKey("XB0") || sprite.subSprites.containsKey("XD0") || sprite.subSprites.containsKey("XB1") || sprite.subSprites.containsKey("XD1")) {
			x_offset = (nd1_offset>0?3:0) + (nb1_offset>0?7:0) + (nd0_offset>0?3:0) + (nb0_offset>0?7:0) + (n_offset>0?n_offset+imageSubSet_header:imageSet_header);			
		}		
		
		if (sprite.subSprites.containsKey("XB0")) {
			xb0_offset = imageSubSet_header;
			x_x1 = sprite.subSprites.get("XB0").x1_offset;
			x_y1 = sprite.subSprites.get("XB0").y1_offset;
		}
		
		if (sprite.subSprites.containsKey("XD0")) {
			xd0_offset = (xb0_offset>0?7:0) + imageSubSet_header;
			x_x1 = sprite.subSprites.get("XD0").x1_offset;
			x_y1 = sprite.subSprites.get("XD0").y1_offset;			
		}

		if (sprite.subSprites.containsKey("XB1")) {
			xb1_offset = (xd0_offset>0?3:0) + (xb0_offset>0?7:0) + imageSubSet_header;
			x_x1 = sprite.subSprites.get("XB1").x1_offset;
			x_y1 = sprite.subSprites.get("XB1").y1_offset;			
		}
		
		if (sprite.subSprites.containsKey("XD1")) {
			xd1_offset = (xb1_offset>0?7:0) + (xd0_offset>0?3:0) + (xb0_offset>0?7:0) + imageSubSet_header;
			x_x1 = sprite.subSprites.get("XD1").x1_offset;
			x_y1 = sprite.subSprites.get("XD1").y1_offset;			
		}		
		
		if (sprite.subSprites.containsKey("YB0") || sprite.subSprites.containsKey("YD0") || sprite.subSprites.containsKey("YB1") || sprite.subSprites.containsKey("YD1")) {
			y_offset = (xd1_offset>0?3:0) + (xb1_offset>0?7:0) + (xd0_offset>0?3:0) + (xb0_offset>0?7:0) + (x_offset>0?x_offset+imageSubSet_header:imageSet_header);			
		}		
		
		if (sprite.subSprites.containsKey("YB0")) {
			yb0_offset = imageSubSet_header;
			y_x1 = sprite.subSprites.get("YB0").x1_offset;
			y_y1 = sprite.subSprites.get("YB0").y1_offset;
		}
		
		if (sprite.subSprites.containsKey("YD0")) {
			yd0_offset = (yb0_offset>0?7:0) + imageSubSet_header;
			y_x1 = sprite.subSprites.get("YD0").x1_offset;
			y_y1 = sprite.subSprites.get("YD0").y1_offset;			
		}

		if (sprite.subSprites.containsKey("YB1")) {
			yb1_offset = (yd0_offset>0?3:0) + (yb0_offset>0?7:0) + imageSubSet_header;
			y_x1 = sprite.subSprites.get("YB1").x1_offset;
			y_y1 = sprite.subSprites.get("YB1").y1_offset;			
		}
		
		if (sprite.subSprites.containsKey("YD1")) {
			yd1_offset = (yb1_offset>0?7:0) + (yd0_offset>0?3:0) + (yb0_offset>0?7:0) + imageSubSet_header;
			y_x1 = sprite.subSprites.get("YD1").x1_offset;
			y_y1 = sprite.subSprites.get("YD1").y1_offset;
		}
		
		if (sprite.subSprites.containsKey("XYB0") || sprite.subSprites.containsKey("XYD0") || sprite.subSprites.containsKey("XYB1") || sprite.subSprites.containsKey("XYD1")) {
			xy_offset = (yd1_offset>0?3:0) + (yb1_offset>0?7:0) + (yd0_offset>0?3:0) + (yb0_offset>0?7:0) + (y_offset>0?y_offset+imageSubSet_header:imageSet_header);			
		}		
		
		if (sprite.subSprites.containsKey("XYB0")) {
			xyb0_offset = imageSubSet_header;
			xy_x1 = sprite.subSprites.get("XYB0").x1_offset;
			xy_y1 = sprite.subSprites.get("XYB0").y1_offset;
		}
		
		if (sprite.subSprites.containsKey("XYD0")) {
			xyd0_offset = (xyb0_offset>0?7:0) + imageSubSet_header;
			xy_x1 = sprite.subSprites.get("XYD0").x1_offset;
			xy_y1 = sprite.subSprites.get("XYD0").y1_offset;			
		}

		if (sprite.subSprites.containsKey("XYB1")) {
			xyb1_offset = (xyd0_offset>0?3:0) + (xyb0_offset>0?7:0) + imageSubSet_header;
			xy_x1 = sprite.subSprites.get("XYB1").x1_offset;
			xy_y1 = sprite.subSprites.get("XYB1").y1_offset;
		}
		
		if (sprite.subSprites.containsKey("XYD1")) {
			xyd1_offset = (xyb1_offset>0?7:0) + (xyd0_offset>0?3:0) + (xyb0_offset>0?7:0) + imageSubSet_header;
			xy_x1 = sprite.subSprites.get("XYD1").x1_offset;
			xy_y1 = sprite.subSprites.get("XYD1").y1_offset;
		}		
		
		for (Entry<String, SubSprite> subSprite : sprite.subSprites.entrySet()) {
			x_size = subSprite.getValue().x_size;
			y_size = subSprite.getValue().y_size;
			break;
		}
		
		line.add(String.format("$%1$02X", n_offset)); // unsigned value
		line.add(String.format("$%1$02X", x_offset)); // unsigned value
		line.add(String.format("$%1$02X", y_offset)); // unsigned value
		line.add(String.format("$%1$02X", xy_offset)); // unsigned value		
		line.add(String.format("$%1$02X", x_size)); // unsigned value
		line.add(String.format("$%1$02X", y_size)); // unsigned value
		
		if (nb0_offset+nd0_offset+nb1_offset+nd1_offset>0) {
			line.add(String.format("$%1$02X", nb0_offset)); // unsigned value
			line.add(String.format("$%1$02X", nd0_offset)); // unsigned value
			line.add(String.format("$%1$02X", nb1_offset)); // unsigned value
			line.add(String.format("$%1$02X", nd1_offset)); // unsigned value
			line.add(String.format("$%1$02X", n_x1 & 0xFF)); // signed value		
			line.add(String.format("$%1$02X", n_y1 & 0xFF)); // signed value			
			if (sprite.subSprites.containsKey("NB0")) {
				getImgSubSpriteIndex(sprite.subSprites.get("NB0"), line);
			}

			if (sprite.subSprites.containsKey("ND0")) {
				getImgSubSpriteIndex(sprite.subSprites.get("ND0"), line);
			}

			if (sprite.subSprites.containsKey("NB1")) {
				getImgSubSpriteIndex(sprite.subSprites.get("NB1"), line);
			}

			if (sprite.subSprites.containsKey("ND1")) {
				getImgSubSpriteIndex(sprite.subSprites.get("ND1"), line);
			}
		}
		
		if (xb0_offset+xd0_offset+xb1_offset+xd1_offset>0) {
			line.add(String.format("$%1$02X", xb0_offset)); // unsigned value
			line.add(String.format("$%1$02X", xd0_offset)); // unsigned value
			line.add(String.format("$%1$02X", xb1_offset)); // unsigned value
			line.add(String.format("$%1$02X", xd1_offset)); // unsigned value
			line.add(String.format("$%1$02X", x_x1 & 0xFF)); // signed value		
			line.add(String.format("$%1$02X", x_y1 & 0xFF)); // signed value			
			if (sprite.subSprites.containsKey("XB0")) {
				getImgSubSpriteIndex(sprite.subSprites.get("XB0"), line);
			}

			if (sprite.subSprites.containsKey("XD0")) {
				getImgSubSpriteIndex(sprite.subSprites.get("XD0"), line);
			}

			if (sprite.subSprites.containsKey("XB1")) {
				getImgSubSpriteIndex(sprite.subSprites.get("XB1"), line);
			}

			if (sprite.subSprites.containsKey("XD1")) {
				getImgSubSpriteIndex(sprite.subSprites.get("XD1"), line);
			}
		}
		
		if (yb0_offset+yd0_offset+yb1_offset+yd1_offset>0) {
			line.add(String.format("$%1$02X", yb0_offset)); // unsigned value
			line.add(String.format("$%1$02X", yd0_offset)); // unsigned value
			line.add(String.format("$%1$02X", yb1_offset)); // unsigned value
			line.add(String.format("$%1$02X", yd1_offset)); // unsigned value
			line.add(String.format("$%1$02X", y_x1 & 0xFF)); // signed value		
			line.add(String.format("$%1$02X", y_y1 & 0xFF)); // signed value			
			if (sprite.subSprites.containsKey("YB0")) {
				getImgSubSpriteIndex(sprite.subSprites.get("YB0"), line);
			}

			if (sprite.subSprites.containsKey("YD0")) {
				getImgSubSpriteIndex(sprite.subSprites.get("YD0"), line);
			}

			if (sprite.subSprites.containsKey("YB1")) {
				getImgSubSpriteIndex(sprite.subSprites.get("YB1"), line);
			}

			if (sprite.subSprites.containsKey("YD1")) {
				getImgSubSpriteIndex(sprite.subSprites.get("YD1"), line);
			}
		}
		
		if (xyb0_offset+xyd0_offset+xyb1_offset+xyd1_offset>0) {
			line.add(String.format("$%1$02X", xyb0_offset)); // unsigned value
			line.add(String.format("$%1$02X", xyd0_offset)); // unsigned value
			line.add(String.format("$%1$02X", xyb1_offset)); // unsigned value
			line.add(String.format("$%1$02X", xyd1_offset)); // unsigned value
			line.add(String.format("$%1$02X", xy_x1 & 0xFF)); // signed value		
			line.add(String.format("$%1$02X", xy_y1 & 0xFF)); // signed value			
			if (sprite.subSprites.containsKey("XYB0")) {
				getImgSubSpriteIndex(sprite.subSprites.get("XYB0"), line);
			}

			if (sprite.subSprites.containsKey("XYD0")) {
				getImgSubSpriteIndex(sprite.subSprites.get("XYD0"), line);
			}

			if (sprite.subSprites.containsKey("XYB1")) {
				getImgSubSpriteIndex(sprite.subSprites.get("XYB1"), line);
			}

			if (sprite.subSprites.containsKey("XYD1")) {
				getImgSubSpriteIndex(sprite.subSprites.get("XYD1"), line);
			}
		}		
		
		asmImgIndex.addFcb(line.toArray(new String[0]));
	}
	
	private static void getImgSubSpriteIndex(SubSprite s, List<String> line) {
		line.add(String.format("$%1$02X", s.draw.fileIndex.page));
		line.add(String.format("$%1$02X", s.draw.fileIndex.address >> 8));		
		line.add(String.format("$%1$02X", s.draw.fileIndex.address & 0xFF));
		
		if (s.erase != null) {
			line.add(String.format("$%1$02X", s.erase.fileIndex.page));
			line.add(String.format("$%1$02X", s.erase.fileIndex.address >> 8));		
			line.add(String.format("$%1$02X", s.erase.fileIndex.address & 0xFF));
			line.add(String.format("$%1$02X", s.nb_cell)); // unsigned value
		}
	}
	
	private static void writeSndIndex(AsmSourceCode asmSndIndex, Sound sound) {
		asmSndIndex.addLabel(sound.name + " *@globals");
		for (SoundBin sb : sound.sb) {
			String[] line = new String[5];
			line[0] = String.format("$%1$02X", sb.fileIndex.page);
			line[1] = String.format("$%1$02X", sb.fileIndex.address >> 8);
			line[2] = String.format("$%1$02X", sb.fileIndex.address & 0x00FF);
			line[3] = String.format("$%1$02X", sb.fileIndex.endAddress >> 8);
			line[4] = String.format("$%1$02X", sb.fileIndex.endAddress & 0x00FF);
			asmSndIndex.addFcb(line);
		}
		asmSndIndex.addFcb(new String[] {"$FF"});
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

	private static int compile(String asmFile, String option, AsmInclude includes) {
		try {
			logger.debug("\t# Process "+asmFile);

			// Purge des fichiers temporaires
			Files.deleteIfExists(Paths.get(binTmpFile));
			Files.deleteIfExists(Paths.get(lstTmpFile));

			// Gestion des fichiers include
			Path path = Paths.get(asmFile);
			String content = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

			Pattern pn = Pattern.compile("INCLUD\\s([0-9a-zA-Z]*)\\s");  
			Matcher m = pn.matcher(content); 	
			Pattern pn2;
			Matcher m2;
			
			// Recherche de tous les TAG INCLUD dans le fichier ASM
			while (m.find()) {
				content = processInclude(m, includes, content);
				content = processInclude(m, game, content);
			}
			
			// Ajout des equ @IgnoreUndefined
			pn = Pattern.compile("#([0-9a-zA-Z_]*)\\s\\*@IgnoreUndefined");  
			m = pn.matcher(content); 			
			while (m.find()) {
				pn2 = Pattern.compile("(?m)^"+m.group(1));
				m2 = pn2.matcher(content);  
				if (m2.find() == false) {					
					content += "\n" + m.group(1) + " equ 0";
				}
			}	
			
    		// Pour chaque TAG, en fin de fichier a compiler, ajout du contenu du fichier inclus		
			Files.write(path, content.getBytes(StandardCharsets.UTF_8));
			// ---------------------------------------------------------------------------

			// Lancement de la compilation du fichier contenant le code de boot
			logger.debug("\t# Compile "+path.toString());
			Process p = new ProcessBuilder(Game.c6809, option, path.toString(), Paths.get(binTmpFile).toString()).start();
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
				String fullname = FileUtil.removeExtension(asmFile);
				String destFileName = fullname+".lst";
				Path lstFilePath = Paths.get(destFileName);
				Files.deleteIfExists(lstFilePath);
				File newLstFile = new File(destFileName);
				lstFile.renameTo(newLstFile);
				
				// Sauvegarde des variables globales
				String contentLst = new String(Files.readAllBytes(Paths.get(destFileName)), StandardCharsets.UTF_8);
				pn = Pattern.compile("([0-9a-zA-Z_]*).*@globals.*") ;  
				m = pn.matcher(content);

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
				destFileName = fullname+".BIN";
				Path binFilePath = Paths.get(destFileName);
				Files.deleteIfExists(binFilePath);
				File newBinFile = new File(destFileName);
				binFile.renameTo(newBinFile);

				logger.debug("\t"+destFileName + " cycles: " + C6809Util.countCycles(newLstFile.getAbsoluteFile().toString()) + " BIN size: " + newBinFile.length());
			} else {
				throw new Exception ("Error "+asmFile);
			}

			return result;

		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(e); 
			return -1;
		}
	}

	private static String processInclude(Matcher m, AsmInclude obj, String content) throws Exception {

		if (obj != null && obj.asmIncludes != null && obj.asmIncludes.get(m.group(1)) != null) {
			logger.debug("\t"+obj.name+" Include " + m.group(1) + ": " + obj.asmIncludes.get(m.group(1)));
			File f = new File(obj.asmIncludes.get(m.group(1)));
			if (f.exists() && !f.isDirectory()) {
				Path pathInc = Paths.get(obj.asmIncludes.get(m.group(1)));
				content += "\n\n(include)" + m.group(1) + "\n"
						+ new String(Files.readAllBytes(pathInc), StandardCharsets.UTF_8);
			} else {
				logger.debug(m.group(1) + " not found in "+obj.name+" include declaration.");
			}

		}
		return content;
	}
	
	/**
	 * Effectue la compression du code assembleur
	 * 
	 * @param binFile fichier contenant le code assembleur a compiler
	 * @return
	 */
	public static byte[] exomize(String binFile) {
		try {
			String basename = FileUtil.removeExtension(binFile);
			String destFileName = basename+".EXO";

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
				throw new Exception ("Erreur de compression "+binFile);
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
		return FileUtil.removeExtension(name)+".BIN";
	}

	public static String getEXOFileName (String name) {
		return FileUtil.removeExtension(name)+".EXO";
	}
	
	public static Path getIncludeFilePath (String tag, AsmInclude includes) throws Exception {	
		if (includes.asmIncludes.get(tag) == null) {
			throw new Exception (tag+" not found in "+includes.name+" include declaration.");
		}
		
		// Creation du chemin si les répertoires sont manquants
		File file = new File (includes.asmIncludes.get(tag));
		file.getParentFile().mkdirs();
		
		return Paths.get(includes.asmIncludes.get(tag));
	}		
}

// Traitement de l'image pour l'écran de démarrage
// ***********************************************

//				PngToBottomUpBinB16 initVideo = new PngToBottomUpBinB16(initVideoFile);
//				byte[] initVideoBIN = initVideo.getBIN();
//
//				fd.setIndex(0, 4, 1);
//				fd.write(initVideoBIN);

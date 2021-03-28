package fr.bento8.to8.build;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map.Entry;
import java.util.stream.Collectors;
import java.util.stream.Stream;

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
import fr.bento8.to8.image.Animation;
import fr.bento8.to8.image.PaletteTO8;
import fr.bento8.to8.image.Sprite;
import fr.bento8.to8.image.SpriteSheet;
import fr.bento8.to8.image.SubSprite;
import fr.bento8.to8.image.SubSpriteBin;
import fr.bento8.to8.util.ByteUtil;
import fr.bento8.to8.util.FileUtil;
import fr.bento8.to8.util.LWASMUtil;
import fr.bento8.to8.util.knapsack.Item;
import fr.bento8.to8.util.knapsack.Knapsack;
import fr.bento8.to8.util.knapsack.Solution;

public class BuildDisk
{
	static final Logger logger = LogManager.getLogger("log");

	private static Game game;
	private static HashMap<String, Object> allObjects = new HashMap<String, Object>();
	private static int gm_totalSize = 0; // Taille totale du binaire : Game Mode Manager + Game Mode Loader + Game Mode Data

	private static FdUtil fd = new FdUtil();
	public static AsmSourceCode glb;
	
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
			
			// globals at game level
			glb = new AsmSourceCode(BuildDisk.createFile(FileNames.GLOBALS, ""));
			
			compileRAMLoader();
			setObjectsIdAsGlobals();
			
			// generate assets and get size of compilated sprites and sounds
			// get size of objects code
			processSounds();			
			compileSprites();
			computeObjectCodeSize();
			
			// compute RAM destination for all assets and objects code
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
	}
	
	private static void compileRAMLoader() throws IOException {
		logger.info("Compile Game Mode Loader ...");

		String ramLoader = duplicateFile(game.engineAsmRAMLoader);
		compileRAW(ramLoader);
		Path binFile = Paths.get(getBINFileName(ramLoader));
		byte[] BINBytes = Files.readAllBytes(binFile);
		byte[] InvBINBytes = new byte[BINBytes.length];
        int j = 0;
        
		// Inversion des données par bloc de 7 octets (simplifie la copie par pul/psh au runtime)
		for (int i = BINBytes.length-7; i >= 0; i -= 7) {
			InvBINBytes[j++] = BINBytes[i];			                          
			InvBINBytes[j++] = BINBytes[i+1];
			InvBINBytes[j++] = BINBytes[i+2];
			InvBINBytes[j++] = BINBytes[i+3];
			InvBINBytes[j++] = BINBytes[i+4];
			InvBINBytes[j++] = BINBytes[i+5];
			InvBINBytes[j++] = BINBytes[i+6];
		}
		
		Files.write(binFile, InvBINBytes);
	}
	
	private static void setObjectsIdAsGlobals() throws Exception {
		logger.info("Set Objects Id as Globals ...");
				
		// GLOBALS - Génération des identifiants d'objets pour l'ensemble des game modes (numérotation commune)
		// ----------------------------------------------------------------------------------------------------		
		int objIndex;
		for(Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			
			objIndex = 1;
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				if (!allObjects.containsKey(object.getKey())) { 
					allObjects.put(object.getKey(), object.getValue());
					gameMode.getValue().glb.addConstant("ObjID_"+object.getKey(), Integer.toString(objIndex));
					object.getValue().id = objIndex;
					logger.debug("\t\tObjID_"+object.getKey()+" "+Integer.toString(objIndex));
					objIndex++;
				}
			}
			gameMode.getValue().glb.flush();
		}
	}
	 
	private static void processSounds() throws Exception {
		logger.info("Process Sounds ...");

		// GAME MODE DATA - Chargement des données audio
		// ---------------------------------------------

		// Parcours de tous les objets de chaque Game Mode
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {

			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {

				// Parcours des données audio de l'objet
				for (Entry<String, String[]> soundsProperties : object.getValue().soundsProperties.entrySet()) {

					Sound sound = new Sound(soundsProperties.getKey());
					sound.soundFile = soundsProperties.getValue()[0];
					sound.setAllBinaries(sound.soundFile);
					object.getValue().sounds.add(sound);
				}
			}
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
							SpriteSheet ss = new SpriteSheet(sprite.name, sprite.spriteFile, 1, cur_variant);
							asm = new AssemblyGenerator(ss, Game.generatedCodeDirName + "/" + object.getValue().name, 0);
							asm.compileCode("A000");
							// La valeur 64 doit être ajustée dans MainEngine.asm si modifiée TODO : rendre paramétrable
							// 16 octets supplémentaires pour IRQ 12 octets du bckp registres et 4 pour les appels sous programmes
							// A rendre paramétrable aussi
							curSubSprite.nb_cell = (asm.getEraseDataSize() + 16 + 64 - 1) / 64;
							curSubSprite.x1_offset = asm.getX1_offset();
							curSubSprite.y1_offset = asm.getY1_offset();
							curSubSprite.x_size = asm.getX_size();
							curSubSprite.y_size = asm.getY_size();
							curSubSprite.center_offset = ss.center_offset;

							logger.debug("Exomize ...");
							curSubSprite.draw = new SubSpriteBin(curSubSprite);
							curSubSprite.draw.setName(cur_variant);
							curSubSprite.draw.bin = Files.readAllBytes(Paths.get(asm.getBckDrawBINFile()));
							curSubSprite.draw.fileIndex = new DataIndex();
							curSubSprite.draw.uncompressedSize = asm.getDSize();
							object.getValue().subSpritesBin.add(curSubSprite.draw);

							curSubSprite.erase = new SubSpriteBin(curSubSprite);
							curSubSprite.erase.setName(cur_variant+" E");
							curSubSprite.erase.bin = Files.readAllBytes(Paths.get(asm.getEraseBINFile()));
							curSubSprite.erase.fileIndex = new DataIndex();
							curSubSprite.erase.uncompressedSize = asm.getESize();
							object.getValue().subSpritesBin.add(curSubSprite.erase);
						}

						if (cur_variant.contains("D")) {
							logger.debug("\t\t- Draw");
							SpriteSheet ss = new SpriteSheet(sprite.name, sprite.spriteFile, 1, cur_variant);
							sasm = new SimpleAssemblyGenerator(ss, Game.generatedCodeDirName + "/" + object.getValue().name, 0);
							sasm.compileCode("A000");
							curSubSprite.nb_cell = 0;
							curSubSprite.x1_offset = sasm.getX1_offset();
							curSubSprite.y1_offset = sasm.getY1_offset();
							curSubSprite.x_size = sasm.getX_size();
							curSubSprite.y_size = sasm.getY_size();
							curSubSprite.center_offset = ss.center_offset;							

							logger.debug("Exomize ...");
							curSubSprite.draw = new SubSpriteBin(curSubSprite);
							curSubSprite.draw.setName(cur_variant);
							curSubSprite.draw.bin = Files.readAllBytes(Paths.get(sasm.getDrawBINFile()));
							curSubSprite.draw.fileIndex = new DataIndex();
							curSubSprite.draw.uncompressedSize = sasm.getDSize();
							object.getValue().subSpritesBin.add(curSubSprite.draw);
						}

						sprite.subSprites.put(cur_variant, curSubSprite);
					}

					// Sauvegarde de tous les rendus demandés pour l'image en cours
					object.getValue().sprites.put(sprite.name, sprite);
					object.getValue().imageSet.uncompressedSize += getImgIndexSize(sprite);
				}
				
				object.getValue().animation.uncompressedSize += getAniIndexSize(object.getValue());
			}		
		}
	}
	
	private static void computeObjectCodeSize() throws Exception {
		logger.info("Compute Objects code size ...");

		// GAME MODE DATA - Compilation du code de chaque objet pour déterminer sa taille
		// ------------------------------------------------------------------------------

		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				ObjectBin objectCode = new ObjectBin();
				String objectCodeTmpFile = duplicateFilePrependSection(object.getValue().codeFileName, gameMode.getKey()+"/"+object.getKey(), "object");

				objectCode.uncompressedSize = getBINSize(objectCodeTmpFile);
				logger.info(objectCodeTmpFile + ": " + objectCode.uncompressedSize + " octets");
			
				if (objectCode.uncompressedSize > 0x4000) {
					throw new Exception("file "+objectCodeTmpFile+" is too large:"+objectCode.uncompressedSize+" bytes (max:"+0x4000+")");
				}

				object.getValue().code = objectCode;
				object.getValue().code.fileIndex = new DataIndex();
			}
		}
	}
	
	private static void computeObjectsRamAddress() {
		logger.info("Compute Objects RAM Address ...");

		// GAME MODE DATA - Répartition des données en RAM
		// -----------------------------------------------

		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			logger.debug("Game Mode : " + gameMode.getValue().name);
			
			// Compte le nombre d'objets a traiter
			int nbGameModeItems = 0;
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				nbGameModeItems += object.getValue().subSpritesBin.size(); // Sprites
				
				if (object.getValue().subSpritesBin.size() > 0)
					nbGameModeItems++;                                     // ImageSet Index
				
				if (!object.getValue().animationsProperties.isEmpty())
					nbGameModeItems++;                                     // Animation Index
				
				for (Sound sound : object.getValue().sounds) {
						nbGameModeItems += sound.sb.size();                // Sounds
				}
				
				nbGameModeItems++;                                         // Object Code				
			}
			
			// Initialise un item pour chaque élément a écrire en RAM
			Item[] items = new Item[nbGameModeItems];
			int itemIdx = 0;

			// Initialisation des items
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				
				for (SubSpriteBin subSpriteBin : object.getValue().subSpritesBin) {
					items[itemIdx++] = new Item(subSpriteBin, 1);                // Sprites
				}

				if (object.getValue().subSpritesBin.size() > 0)
					items[itemIdx++] = new Item(object.getValue().imageSet, 1);  // ImageSet Index
				
				if (!object.getValue().animationsProperties.isEmpty())
					items[itemIdx++] = new Item(object.getValue().animation, 1); // Animation Index				
				
				for (Sound sound : object.getValue().sounds) {
					for (SoundBin soundBin : sound.sb) {
						items[itemIdx++] = new Item(soundBin, 1);                // Sounds
					}
				}
				
				items[itemIdx++] = new Item(object.getValue().code, 1);          // Object Code
			}

			int page = 5; // Première page disponible pour les données de Game Mode

			while (items.length > 0) {

				int address = 0x0000; // Position dans la page

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
		
		// TODO: Créer un nouvel objet Page
		// Parcourir les items, les recompiler à leur org de destination
		// concaterner les binaires et les splitter en deux parties
		// exomizer les deux parties et les enregistrer dans l'objet page
		
		// TODO : Executer deux fois cette méthode
		// Une premiere fois pour le fd/sd en traitant tous les objets (instancier une liste de Page)
		// Une seconde fois pour la T.2, on ne traite que les objets flagués RAM (instancier une seconde liste de Page), seuls les codes objets peuvent être flagués RAM
		
		// TODO : Executer une troisieme fois cette méthode sur les objets non flagués RAM
		// instancier une troisieme liste de Page
		// La limite en nb de pages est maintenant basée sur nb pages T.2 et nb pages déjà prises pour la RAM (en mode exomize)
		
		// Le check taille disquette ou T.2 est fait plus tard lors de l'écriture sur média cible
	}
	
	private static void compileObjects() throws Exception {
		logger.info("Compile Objects ...");

		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				
				// Compilation du code Objet
				String objectCodeTmpFile = duplicateFile(object.getValue().codeFileName, gameMode.getKey()+"/"+object.getKey());

				compileLIN(objectCodeTmpFile);
				byte[] bin = Files.readAllBytes(Paths.get(getBINFileName(objectCodeTmpFile)));
				object.getValue().code.uncompressedSize = bin.length-10;
				
				if (object.getValue().code.uncompressedSize > 0x4000) {
					throw new Exception("file "+objectCodeTmpFile+" is too large:"+object.getValue().code.uncompressedSize+" bytes (max:"+0x4000+")");
				}
				
				object.getValue().code.bin = Files.readAllBytes(Paths.get(getBINFileName(objectCodeTmpFile)));
			}
		}
	}
	
	private static void compileMainEngines() throws Exception {
		logger.info("Compile Main Engines ...");
		
		for(Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			logger.debug("Game Mode : " + gameMode.getKey());
			
			// MAIN ENGINE - Dynamic data
			// --------------------------------------------------------------------------------------	
			AsmSourceCode asmBuilder = new AsmSourceCode(createFile(FileNames.MAIN_GENCODE, gameMode.getValue().name));		

			String[][] objIndexPage = new String[gameMode.getValue().objects.entrySet().size()+1][];
			String[][] objIndex = new String[gameMode.getValue().objects.entrySet().size()+1][];			
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				objIndexPage[allObjects.get(object.getValue().name).id] = new String[] {String.format("$%1$02X", object.getValue().code.fileIndex.page)};
				objIndex[allObjects.get(object.getValue().name).id] = new String[] {String.format("$%1$02X", object.getValue().code.fileIndex.address >> 8), String.format("$%1$02X", object.getValue().code.fileIndex.address & 0x00FF)};
			}
			
			asmBuilder.addLabel("Obj_Index_Page");			
			for (int i = 0; i < objIndexPage.length; i++) {
				if (objIndexPage[i] == null) {
					objIndexPage[i] = new String[] {"$00"};
				}
				asmBuilder.addFcb(objIndexPage[i]);
			}
			
			asmBuilder.addLabel("Obj_Index_Address");
			for (int i = 0; i < objIndex.length; i++) {
				if (objIndex[i] == null) {
					objIndex[i] = new String[] {"$00", "$00"};
				}
				asmBuilder.addFcb(objIndex[i]);
			}
			
			String mainEngineTmpFile = duplicateFile(gameMode.getValue().engineAsmMainEngine, gameMode.getKey());
			
			// MAIN ENGINE - Palettes
			// --------------------------------------------------------------------------------------			
			for (Entry<String, Palette> palette : gameMode.getValue().palettes.entrySet()) {
				asmBuilder.addLabel(palette.getValue().name + " * @globals");
				asmBuilder.add(PaletteTO8.getPaletteData(palette.getValue().fileName));
			}
			
			// MAIN ENGINE - Code d'initialisation de l'Acte
			// --------------------------------------------------------------------------------------
			asmBuilder.add("LoadAct");
			
			if (gameMode.getValue().actBoot != null) {
				Act act = gameMode.getValue().acts.get(gameMode.getValue().actBoot);

				if (act != null) {
					if (act.bgColorIndex != null) {
						asmBuilder.add("        ldx   #"+String.format("$%1$01X%1$01X%1$01X%1$01X", Integer.parseInt(act.bgColorIndex))+"                   * set Background solid color");
						asmBuilder.add("        ldb   #$62                     * load page 2");						
						asmBuilder.add("        stb   $E7E6                    * in cartridge space ($0000-$3FFF)");
						asmBuilder.add("        jsr   ClearCartMem");
					}					

					if (act.screenBorder != null) {
						asmBuilder.add("        lda   $E7DD                    * set border color");
						asmBuilder.add("        anda  #$F0");
						asmBuilder.add("        adda  #"+String.format("$%1$02X", Integer.parseInt(act.screenBorder))+"                     * color ref");
						asmBuilder.add("        sta   $E7DD");
						asmBuilder.add("        anda  #$0F");
						asmBuilder.add("        adda  #$80");
						asmBuilder.add("        sta   screen_border_color+1    * maj WaitVBL");
					}

					if (act.bgColorIndex != null) {
						asmBuilder.add("        jsr   WaitVBL");						
						asmBuilder.add("        ldx   #"+String.format("$%1$01X%1$01X%1$01X%1$01X", Integer.parseInt(act.bgColorIndex))+"                   * set Background solid color");
						asmBuilder.add("        ldb   #$63                     * load page 3");						
						asmBuilder.add("        stb   $E7E6                    * in cardtridge space ($0000-$3FFF)");
						asmBuilder.add("        jsr   ClearCartMem");						
					}

					if (act.bgFileName != null) {
						asmBuilder.add("        ldu   #$0000");
						asmBuilder.add("        jsr   CopyImageToCart");
					}
					
					if (act.paletteName != null) {
						asmBuilder.add("        ldd   #" + act.paletteName);
						asmBuilder.add("        std   Cur_palette");
						asmBuilder.add("        clr   Refresh_palette");
					}
				}
			}
			
			asmBuilder.add("        rts");
			
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {

				// MAIN ENGINE - Génération des index Images
				// --------------------------------------------------------------------------------------
				AsmSourceCode asmImgIndex = new AsmSourceCode(createFile(object.getValue().imageSet.fileName, object.getValue().name));
				for (Entry<String, Sprite> sprite : object.getValue().sprites.entrySet()) {
					writeImgIndex(asmImgIndex, sprite.getValue());
				}

				// MAIN ENGINE - Génération des index de scripts d'animation
				// --------------------------------------------------------------------------------------
				AsmSourceCode asmAniIndex = new AsmSourceCode(createFile(object.getValue().animation.fileName, object.getValue().name));
				writeAniIndex(asmAniIndex, object.getValue());
			
				// MAIN ENGINE - Génération des index Audio
				// --------------------------------------------------------------------------------------
				for (Sound sound : object.getValue().sounds) {
					writeSndIndex(asmBuilder, sound);
				}			
			}
			asmBuilder.flush();
			
			// MAIN ENGINE - Compilation des Main Engines
			// --------------------------------------------------------------------------------------			
			compileLIN(mainEngineTmpFile);
			byte[] binBytes = Files.readAllBytes(Paths.get(getBINFileName(mainEngineTmpFile)));

			if (binBytes.length - 10 > 0x4000) {
				throw new Exception("file " + gameMode.getValue().engineAsmMainEngine + " is too large:" + (binBytes.length - 10) + " bytes (max:"+0x4000+")");
			}
			
			gameMode.getValue().code = new ObjectBin();
			gameMode.getValue().code.bin = Files.readAllBytes(Paths.get(getBINFileName(mainEngineTmpFile)));
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
		AsmSourceCode fileIndex = new AsmSourceCode(createFile(FileNames.FILE_INDEX));
		fileIndex.addCommentLine("structure: sector, nb sector, drive (bit 7) track (bit 6-0), end offset, ram dest page, ram dest end addr. hb, ram dest end addr. lb");
		
		// Parcours des objets du Game Mode
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			
			fileIndex.addLabel("gm_" + gameMode.getKey());
			fileIndex.addFdb(new String[] { "current_game_mode_data+"+(gameMode.getValue().dataSize-2+6+1)}); // -2 index, +6 balise FF (lecture par groupe de 7 octets), +1 balise FF ajoutée par le GameModeManager au runtime	
			
			// Ajout du tag pour identifier le game mode de démarrage
			if (gameMode.getKey().contentEquals(game.gameModeBoot)) {
				fileIndex.addLabel("gmboot * @globals");
			}
			
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				for (Entry<String, Sprite> sprite : object.getValue().sprites.entrySet()) {
					for (Entry<String, SubSprite> subSprite : sprite.getValue().subSprites.entrySet()) {
						extractSubSpriteFileIndex(subSprite.getValue(), fileIndex, sprite.getKey()+" "+subSprite.getValue().name);
					}
				}
				
				for (Sound sound : object.getValue().sounds) {
					for (SoundBin sb : sound.sb) {
						fileIndex.addFcb(new String[] {
						String.format("$%1$02X", sb.fileIndex.sector),
						String.format("$%1$02X", sb.fileIndex.nbSector-1),
						String.format("$%1$02X", (sb.fileIndex.drive << 7)+sb.fileIndex.track),				
						String.format("$%1$02X", -sb.fileIndex.endOffset & 0xFF),
						String.format("$%1$02X", sb.fileIndex.page),	
						String.format("$%1$02X", sb.fileIndex.endAddress >> 8),			
						String.format("$%1$02X", sb.fileIndex.endAddress & 0x00FF)});			
						fileIndex.appendComment(sound.name + sound.sb.indexOf(sb) + " Sound");						
					}
				}
				
				// Code de l'objet
				fileIndex.addFcb(new String[] {
				String.format("$%1$02X", object.getValue().code.fileIndex.sector),
				String.format("$%1$02X", object.getValue().code.fileIndex.nbSector-1),
				String.format("$%1$02X", (object.getValue().code.fileIndex.drive << 7)+object.getValue().code.fileIndex.track),				
				String.format("$%1$02X", -object.getValue().code.fileIndex.endOffset & 0xFF),
				String.format("$%1$02X", object.getValue().code.fileIndex.page),	
				String.format("$%1$02X", object.getValue().code.fileIndex.endAddress >> 8),			
				String.format("$%1$02X", object.getValue().code.fileIndex.endAddress & 0x00FF)});			
				fileIndex.appendComment(object.getValue().name+ " Object code");
			}
			
			// Code main engine
			fileIndex.addFcb(new String[] {
			String.format("$%1$02X", gameMode.getValue().code.fileIndex.sector),
			String.format("$%1$02X", gameMode.getValue().code.fileIndex.nbSector-1),
			String.format("$%1$02X", (gameMode.getValue().code.fileIndex.drive << 7)+gameMode.getValue().code.fileIndex.track),			
			String.format("$%1$02X", -gameMode.getValue().code.fileIndex.endOffset & 0xFF),
			String.format("$%1$02X", gameMode.getValue().code.fileIndex.page),	
			String.format("$%1$02X", gameMode.getValue().code.fileIndex.endAddress >> 8),			
			String.format("$%1$02X", gameMode.getValue().code.fileIndex.endAddress & 0x00FF)});			
			fileIndex.appendComment(gameMode.getValue().name+ " Main Engine code");			
		}
		
		fileIndex.addFcb(new String[] { "$FF" });		
		fileIndex.flush();
		
		// GAME MODE DATA - Compilation du Game Mode Manager
		// -------------------------------------------------		

		String gameModeManagerTmpFile = duplicateFile(game.engineAsmRAMLoaderManager);
		compileRAW(gameModeManagerTmpFile);
		game.engineAsmGameModeManagerBytes = Files.readAllBytes(Paths.get(getBINFileName(gameModeManagerTmpFile)));

		if (game.engineAsmGameModeManagerBytes.length > 0x4000) {
			throw new Exception("Le fichier "+game.engineAsmRAMLoaderManager+" est trop volumineux:"+game.engineAsmGameModeManagerBytes.length+" octets (max:"+0x4000+")");
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
	
	private static int getAniIndexSize(Object object) {
		return writeAniIndex(null, object);
	}	
	
	private static int writeAniIndex(AsmSourceCode asm, Object object) {
		int size = 0;
		for (Entry<String, String[]> animationProperties : object.animationsProperties.entrySet()) {
			int i = 0;

			if (asm != null) {
				asm.addLabel(animationProperties.getKey() + " ");
				asm.addFcb(new String[] { animationProperties.getValue()[i] });
			}
			size++;

			for (i = 1; i < animationProperties.getValue().length; i++) {

					if (Animation.tagSize.get(animationProperties.getValue()[i]) == null) {
						if (asm != null)
							asm.addFdb(new String[] { animationProperties.getValue()[i] });
						size += 2;
					} else {
						switch (Animation.tagSize.get(animationProperties.getValue()[i])) {
						case 1:
							if (asm != null)
								asm.addFcb(new String[] { animationProperties.getValue()[i] });
							size += 1;
							break;
						case 2:
							if (asm != null) {
								asm.addFcb(new String[] { animationProperties.getValue()[i++] });
								asm.addFcb(new String[] { animationProperties.getValue()[i] });								
							}
							size += 2;
							break;
						case 3:
							if (asm != null) {
								asm.addFcb(new String[] { animationProperties.getValue()[i++] });
								asm.addFdb(new String[] { animationProperties.getValue()[i] });								
							}
							size += 3;
							break;
						}
					}
			}
		}
		if (asm != null)		
			asm.flush();
		return size;
	}
	
	
	private static int getImgIndexSize(Sprite sprite) {
		return writeImgIndex(null, sprite);
	}
	
	private static int writeImgIndex(AsmSourceCode asm, Sprite sprite) {
		
		// Sorry for this code ... should be a better way of doing that
		// Note : index to image sub set is limited to an offset of +127
		// this version go up to +102 so it's fine
		
		List<String> line = new ArrayList<String>();
		int imageSet_header = 7, imageSubSet_header = 6;
		int x_size = 0;
		int y_size = 0;
		int center_offset = 0;
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
		
		if (asm != null)
			asm.addLabel(sprite.name+" ");		
		
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
			center_offset = subSprite.getValue().center_offset;
			break;
		}
		
		line.add(String.format("$%1$02X", n_offset)); // unsigned value
		line.add(String.format("$%1$02X", x_offset)); // unsigned value
		line.add(String.format("$%1$02X", y_offset)); // unsigned value
		line.add(String.format("$%1$02X", xy_offset)); // unsigned value		
		line.add(String.format("$%1$02X", x_size)); // unsigned value
		line.add(String.format("$%1$02X", y_size)); // unsigned value
		line.add(String.format("$%1$02X", center_offset)); // unsigned value
		
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
		
		String[] result = line.toArray(new String[0]);
		if (asm != null) {
			asm.addFcb(result);
			asm.flush();
		}
		return result[0].length()/3;
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
		asmSndIndex.addLabel(sound.name + " ");
		for (SoundBin sb : sound.sb) {
			String[] line = new String[5];
			line[0] = String.format("$%1$02X", sb.fileIndex.page);
			line[1] = String.format("$%1$02X", sb.fileIndex.address >> 8);
			line[2] = String.format("$%1$02X", sb.fileIndex.address & 0x00FF);
			line[3] = String.format("$%1$02X", sb.fileIndex.endAddress >> 8);
			line[4] = String.format("$%1$02X", sb.fileIndex.endAddress & 0x00FF);
			asmSndIndex.addFcb(line);
		}
		asmSndIndex.addFcb(new String[] {"$00"});
	}

	/**
	 * Effectue la compilation du code assembleur
	 * 
	 * @param asmFile fichier contenant le code assembleur a compiler
	 * @return
	 */

	private static int compileRAW(String asmFile) {
		return compile(asmFile, "--raw");
	}	

	private static int compileLIN(String asmFile) {
		return compile(asmFile, "--decb");
	}

	private static int compile(String asmFile, String option) {
		try {
			Path path = Paths.get(asmFile);
			String asmFileName = FileUtil.removeExtension(asmFile);
			String binFile = asmFileName + ".bin";
			String lstFile = asmFileName + ".lst";
			String glbFile = asmFileName + ".glb";			

			logger.debug("\t# Compile "+path.toString());
			Process p = new ProcessBuilder(Game.lwasm, path.toString(), "--output=" + binFile, "--list=" + lstFile, "--6809", "--pragma=undefextern,autobranchlength", "--symbol-dump=" + glbFile, option).start();
			BufferedReader br=new BufferedReader(new InputStreamReader(p.getErrorStream()));
			String line;

			while((line=br.readLine())!=null){
				logger.debug("\t"+line);
			}

			int result = p.waitFor();
			if (result != 0) {
				throw new Exception ("Error "+asmFile);
			}

			return result;

		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(e); 
			return -1;
		}
	}
	
	private static int getBINSize(String asmFile) {
		try {
			Path path = Paths.get(asmFile);
			String asmFileName = FileUtil.removeExtension(asmFile);
			String binFile = asmFileName + ".bin";
			String lstFile = asmFileName + ".lst";
			
			logger.debug("\t# Compile "+path.toString());
			Process p = new ProcessBuilder(Game.lwasm, path.toString(), "--output=" + binFile, "--list=" + lstFile, "--6809", "--pragma=undefextern,autobranchlength,undefextern", "--obj").start();
			BufferedReader br=new BufferedReader(new InputStreamReader(p.getErrorStream()));
			String line;

			while((line=br.readLine())!=null){
				logger.debug("\t"+line);
			}

			int result = p.waitFor();
			if (result != 0) {
				throw new Exception ("Error "+asmFile);
			}
			
			return LWASMUtil.countSize(lstFile);

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
	public static byte[] exomize(String binFile) {
		try {
			String basename = FileUtil.removeExtension(binFile);
			String destFileName = basename+".EXO";

			// Purge des fichiers temporaires
			Files.deleteIfExists(Paths.get(destFileName));

			logger.debug("**************** EXOMIZE "+binFile+" ****************");
			ProcessBuilder pb = new ProcessBuilder(Game.exobin, Paths.get(binFile).toString());
			pb.redirectErrorStream(true);
			Process p = pb.start();
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
		String destFileName = Game.generatedCodeDirName+"/"+basename+".asm";

		Path original = Paths.get(fileName);        
		Path copied = Paths.get(destFileName);
		Files.copy(original, copied, StandardCopyOption.REPLACE_EXISTING);
		return destFileName;
	}
	
	public static String duplicateFile(String fileName, String subDir) throws IOException {
		String basename = FileUtil.removeExtension(Paths.get(fileName).getFileName().toString());
		String destFileName = Game.generatedCodeDirName+"/"+subDir+"/"+basename+".asm";

		// Creation du chemin si les répertoires sont manquants
		File file = new File (destFileName);
		file.getParentFile().mkdirs();
		
		Path original = Paths.get(fileName);        
		Path copied = Paths.get(destFileName);
		Files.copy(original, copied, StandardCopyOption.REPLACE_EXISTING);
		return destFileName;
	}	
	
	public static String duplicateFilePrependSection(String fileName, String subDir, String section) throws IOException {
		String basename = FileUtil.removeExtension(Paths.get(fileName).getFileName().toString());
		String destFileName = Game.generatedCodeDirName+"/"+subDir+"/"+basename+".asm";

		// Creation du chemin si les répertoires sont manquants
		File file = new File (destFileName);
		file.getParentFile().mkdirs();
		
		List<String> result = new ArrayList<>();
		result.add(" section " + section + "\n");
	    try (Stream<String> lines = Files.lines(Paths.get(fileName))) {
	        result.addAll(lines.collect(Collectors.toList()));
	    }
		
	    Files.write(Paths.get(destFileName), result);
		
		return destFileName;
	}		
	
	public static String duplicateFilePrependOrg(String fileName, String subDir, String org) throws IOException {
		String basename = FileUtil.removeExtension(Paths.get(fileName).getFileName().toString());
		String destFileName = Game.generatedCodeDirName+"/"+subDir+"/"+basename+".asm";

		// Creation du chemin si les répertoires sont manquants
		File file = new File (destFileName);
		file.getParentFile().mkdirs();
		
		List<String> result = new ArrayList<>();
		result.add(" org $" + org + "\n");
	    try (Stream<String> lines = Files.lines(Paths.get(fileName))) {
	        result.addAll(lines.collect(Collectors.toList()));
	    }
		
	    Files.write(Paths.get(destFileName), result);
		
		return destFileName;
	}		

	public static String getBINFileName (String name) {
		return FileUtil.removeExtension(name)+".bin";
	}

	public static String getEXOFileName (String name) {
		return FileUtil.removeExtension(name)+".exo";
	}
	
	public static Path createFile (String fileName) throws Exception {
		return createFile (fileName, "");
	}
	
	public static Path createFile (String fileName, String subDir) throws Exception {	
		
		String newFileName = Game.generatedCodeDirName + subDir + "/" + fileName;
		
		// Creation du chemin si les répertoires sont manquants
		File file = new File (newFileName);
		file.getParentFile().mkdirs();
		
		return Paths.get(newFileName);
	}		
}

// Traitement d'une image plein écran
// **********************************

//				PngToBottomUpBinB16 initVideo = new PngToBottomUpBinB16(initVideoFile);
//				byte[] initVideoBIN = initVideo.getBIN();


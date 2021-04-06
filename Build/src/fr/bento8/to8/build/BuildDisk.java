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
import fr.bento8.to8.ram.RamImage;
import fr.bento8.to8.util.FileUtil;
import fr.bento8.to8.util.LWASMUtil;
import fr.bento8.to8.util.knapsack.Item;
import fr.bento8.to8.util.knapsack.Knapsack;
import fr.bento8.to8.util.knapsack.Solution;

public class BuildDisk
{
	static final Logger logger = LogManager.getLogger("log");

	private static Game game;
	public static HashMap<String, GameModeCommon> allGameModeCommons = new HashMap<String, GameModeCommon>();
	private static int gm_totalSize = 0; // Taille totale du binaire : Game Mode Manager + Game Mode Loader + Game Mode Data

	private static FdUtil fd = new FdUtil();
	
	public static String FLOPPY_DISK = "FLoppy Disk";
	public static String MEGAROM_T2 = "MEGAROM T.2";
	public static String RAM = "RAM";
	
	public static boolean abortFloppyDisk = false;
	public static boolean abortT2 = false;
	
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
	 * @throws Throwable 
	 */
	
	public static void main(String[] args) throws Throwable
	{
		try {
			
			loadGameConfiguration(args[0]);
			
			compileRAMLoader();
			generateObjectIDs();
			processSounds();			
			generateSprites();
			compileMainEngines();						
			compileObjects();
			
			computeRamAddress(); // TODO ROM placement
			generateImgAniIndex(); // TODO ROM data update 
			compileMainEngines(); // OK
			
			writeObjects(); // TODO
			compileAndWriteBoot(); // TODO
			writeDiskImage(); // TODO
			
		} catch (Exception e) {
			logger.fatal("Build error.", e);
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
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
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private static void compileRAMLoader() throws IOException {
		logger.info("Compile RAM Loader ...");

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
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static void generateObjectIDs() throws Exception {
		logger.info("Set Objects Id as Globals ...");
				
		// GLOBALS - Génération des identifiants d'objets pour l'ensemble des game modes
		// - identifiants des objets communs, ils sont identiques pour un même Game Mode Common
		// - identifiants des objets de Game Mode (Un id d'un même objet peut être différent selon le game Mode)
		// L'id objet est utilisé comme index pour accéder à l'adresse du code de l'objet au runtime
		// ----------------------------------------------------------------------------------------------------		
		int objIndex;
		for(Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			
			objIndex = 1;
			logger.debug("\tGame Mode: "+gameMode.getKey());
			
			// Game Mode Common
			for (GameModeCommon common : gameMode.getValue().gameModeCommon) {
				if (common != null) {
					for (Entry<String, Object> object : common.objects.entrySet()) {
						objIndex = generateObjectIDs(gameMode.getValue(), object.getValue(), objIndex);
					}
				}
			}
			
			// Objets du Game Mode
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				objIndex = generateObjectIDs(gameMode.getValue(), object.getValue(), objIndex);

			}
			gameMode.getValue().glb.flush();
		}
	}
	
	private static int generateObjectIDs(GameMode gameMode, Object object, int objIndex) throws Exception {
		// Sauvegarde de l'id objet pour ce Game Mode
		gameMode.objectsId.put(object, objIndex);
		
		// Génération de la constante ASM
		gameMode.glb.addConstant("ObjID_"+object.name, Integer.toString(objIndex));
		
		logger.debug("\t\tObjID_"+object.name+" "+Integer.toString(objIndex));
		return ++objIndex; 
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	 
	private static void processSounds() throws Exception {
		logger.info("Process Sounds ...");

		// GAME MODE DATA - Chargement des données audio
		// ---------------------------------------------

		// Parcours de tous les objets de chaque Game Mode
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			logger.debug("\tGame Mode: "+gameMode.getKey());

			// Game Mode Common
			for (GameModeCommon common : gameMode.getValue().gameModeCommon) {
				if (common != null) {
					for (Entry<String, Object> object : common.objects.entrySet()) {
						processSounds(gameMode.getValue(), object.getValue());
					}
				}
			}			
			
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				processSounds(gameMode.getValue(), object.getValue());
			}
		}
	}
	
	private static void processSounds(GameMode gameMode, Object object) throws Exception {
		// Parcours des données audio de l'objet
		for (Entry<String, String[]> soundsProperties : object.soundsProperties.entrySet()) {

			logger.debug("\t\tSound: "+soundsProperties.getKey());
			
			Sound sound = new Sound(soundsProperties.getKey());
			sound.soundFile = soundsProperties.getValue()[0];
			
			sound.setAllBinaries(sound.soundFile, (soundsProperties.getValue().length > 1 && soundsProperties.getValue()[1].equalsIgnoreCase(BuildDisk.RAM)));
			object.sounds.add(sound);
		}
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private static void generateSprites() throws Exception {
		logger.info("Generate Sprites ...");

		// GAME MODE DATA - Génération des sprites compilés pour chaque objet
		// ------------------------------------------------------------------
		
		// Parcours de tous les objets de chaque Game Mode
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			// Game Mode Common
			for (GameModeCommon common : gameMode.getValue().gameModeCommon) {
				if (common != null) {
					for (Entry<String, Object> object : common.objects.entrySet()) {
						generateSprites(gameMode.getValue(), object.getValue());
					}
				}
			}
			
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				generateSprites(gameMode.getValue(), object.getValue());
			}		
		}
	}
	
	private static void generateSprites(GameMode gameMode, Object object) throws Exception {
		AssemblyGenerator asm;
		SimpleAssemblyGenerator sasm;

		// génération du sprite compilé
		SubSprite curSubSprite;		
		
		// Parcours des images de l'objet et compilation de l'image
		AsmSourceCode asmImgIndex = new AsmSourceCode(createFile(object.imageSet.fileName, object.name));
		for (Entry<String, String[]> spriteProperties : object.spritesProperties.entrySet()) {

			Sprite sprite = new Sprite(spriteProperties.getKey());
			sprite.spriteFile = spriteProperties.getValue()[0];
			String[] spriteVariants = spriteProperties.getValue()[1].split(",");
			if (spriteProperties.getValue().length > 2 && spriteProperties.getValue()[2].equalsIgnoreCase(BuildDisk.RAM))
				sprite.inRAM = true;					

			// Parcours des différents rendus demandés pour chaque image
			for (String cur_variant : spriteVariants) {
				logger.debug("\t"+gameMode.name+"/"+object.name+" Compile sprite: " + sprite.name + " image:" + sprite.spriteFile + " variant:" + cur_variant);

				// Sauvegarde du code généré pour la variante
				curSubSprite = new SubSprite(sprite);
				curSubSprite.setName(cur_variant);
				
				if (cur_variant.contains("B")) {
					logger.debug("\t\t- BackupBackground/Draw/Erase");
					SpriteSheet ss = new SpriteSheet(sprite.name, sprite.spriteFile, 1, cur_variant);
					asm = new AssemblyGenerator(ss, Game.generatedCodeDirName + object.name, 0);
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

					curSubSprite.draw = new SubSpriteBin(curSubSprite);
					curSubSprite.draw.setName(cur_variant);
					curSubSprite.draw.bin = Files.readAllBytes(Paths.get(asm.getBckDrawBINFile()));
					curSubSprite.draw.dataIndex = new DataIndex();
					curSubSprite.draw.uncompressedSize = asm.getDSize();
					curSubSprite.draw.inRAM = sprite.inRAM;
					object.subSpritesBin.add(curSubSprite.draw);

					curSubSprite.erase = new SubSpriteBin(curSubSprite);
					curSubSprite.erase.setName(cur_variant+" E");
					curSubSprite.erase.bin = Files.readAllBytes(Paths.get(asm.getEraseBINFile()));
					curSubSprite.erase.dataIndex = new DataIndex();
					curSubSprite.erase.uncompressedSize = asm.getESize();
					curSubSprite.erase.inRAM = sprite.inRAM;							
					object.subSpritesBin.add(curSubSprite.erase);
				}

				if (cur_variant.contains("D")) {
					logger.debug("\t\t- Draw");
					SpriteSheet ss = new SpriteSheet(sprite.name, sprite.spriteFile, 1, cur_variant);
					sasm = new SimpleAssemblyGenerator(ss, Game.generatedCodeDirName + object.name, 0);
					sasm.compileCode("A000");
					curSubSprite.nb_cell = 0;
					curSubSprite.x1_offset = sasm.getX1_offset();
					curSubSprite.y1_offset = sasm.getY1_offset();
					curSubSprite.x_size = sasm.getX_size();
					curSubSprite.y_size = sasm.getY_size();
					curSubSprite.center_offset = ss.center_offset;							

					curSubSprite.draw = new SubSpriteBin(curSubSprite);
					curSubSprite.draw.setName(cur_variant);
					curSubSprite.draw.bin = Files.readAllBytes(Paths.get(sasm.getDrawBINFile()));
					curSubSprite.draw.dataIndex = new DataIndex();
					curSubSprite.draw.uncompressedSize = sasm.getDSize();
					curSubSprite.draw.inRAM = sprite.inRAM;							
					object.subSpritesBin.add(curSubSprite.draw);
				}

				sprite.subSprites.put(cur_variant, curSubSprite);
			}

			// Sauvegarde de tous les rendus demandés pour l'image en cours
			object.sprites.put(sprite.name, sprite);
			object.imageSet.uncompressedSize += writeImgIndex(asmImgIndex, sprite);
		}
		AsmSourceCode asmAniIndex = new AsmSourceCode(createFile(object.animation.fileName, object.name));
		object.animation.uncompressedSize += writeAniIndex(asmAniIndex, object);
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private static void compileMainEngines() throws Throwable {
		logger.info("Compile Main Engines ...");
		
		for(Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			logger.debug("\tGame Mode : " + gameMode.getKey());
			
			String mainEngineTmpFile = duplicateFile(gameMode.getValue().engineAsmMainEngine, gameMode.getKey());
			AsmSourceCode asmBuilder = new AsmSourceCode(createFile(FileNames.MAIN_GENCODE, gameMode.getValue().name));			
			
			writePalIndex(asmBuilder, gameMode.getValue());
			writeObjIndex(asmBuilder, gameMode.getValue());
			writeSndIndex(asmBuilder, gameMode.getValue());
			writeImgPgIndex(asmBuilder, gameMode.getValue());
			writeAniPgIndex(asmBuilder, gameMode.getValue());			
			writeLoadActIndex(asmBuilder, gameMode.getValue());
			
			compileRAW(mainEngineTmpFile);
			byte[] binBytes = Files.readAllBytes(Paths.get(getBINFileName(mainEngineTmpFile)));

			if (binBytes.length > RamImage.PAGE_SIZE) {
				throw new Exception("file " + gameMode.getValue().engineAsmMainEngine + " is too large:" + binBytes.length + " bytes (max:"+RamImage.PAGE_SIZE+")");
			}
			
			gameMode.getValue().code = new ObjectBin();
			gameMode.getValue().code.bin = Files.readAllBytes(Paths.get(getBINFileName(mainEngineTmpFile)));
			gameMode.getValue().code.dataIndex = new DataIndex();
			gameMode.getValue().code.dataIndex.page = 1;
			gameMode.getValue().code.dataIndex.address = 0x6100;
			gameMode.getValue().ramFD.setData(gameMode.getValue().code.dataIndex.page, 0x0100, gameMode.getValue().code.bin);
			gameMode.getValue().ramT2.setData(gameMode.getValue().code.dataIndex.page, 0x0100, gameMode.getValue().code.bin);
		}
	}	
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static void writePalIndex(AsmSourceCode asmBuilder, GameMode gameMode) throws Throwable {
		for (Entry<String, Palette> palette : gameMode.palettes.entrySet()) {
			asmBuilder.addLabel(palette.getValue().name);
			asmBuilder.add(PaletteTO8.getPaletteData(palette.getValue().fileName));
		}
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static void writeLoadActIndex(AsmSourceCode asmBuilder, GameMode gameMode) throws Throwable {
		asmBuilder.add("LoadAct");
		
		if (gameMode.actBoot != null) {
			Act act = gameMode.acts.get(gameMode.actBoot);

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
		asmBuilder.flush();
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static void compileObjects() throws Exception {
		logger.info("Compile Objects ...");

		// Parcours de tous les objets de chaque Game Mode
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			
			logger.info("\t"+gameMode.getKey()+":");
			
			// Game Mode Common
			for (GameModeCommon common : gameMode.getValue().gameModeCommon) {
				if (common != null) {
					for (Entry<String, Object> object : common.objects.entrySet()) {
						compileObject(gameMode.getKey(), object.getValue(), 0);
					}
				}
			}
			
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				compileObject(gameMode.getKey(), object.getValue(), 0);
			}		
		}		
	}	
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static byte[] compileObject(String GMName, Object object, int org) throws Exception {
		logger.info("\t\t"+object.name+" at "+String.format("$%1$04X", org));

		String prepend;
		
		prepend = "\torg   $" + org + "\n";
		prepend = "\topt   c,ct\n";
		
		prepend += "\tINCLUDE \"" + Game.generatedCodeDirName + GMName + "/" + FileNames.MAIN_GENCODEGLB+"\"\n";
		prepend += "\tINCLUDE \"" + Game.generatedCodeDirName + GMName + "/" + FileNames.GLOBALS+"\"\n";
		
		if (object.sprites.size() > 0) {
			prepend += "\tINCLUDE \"" + Game.generatedCodeDirName + object.name + "/" + object.imageSet.fileName + "\"\n";
			prepend += "\tINCLUDE \"" + Game.generatedCodeDirName + object.name + "/" + object.animation.fileName + "\"\n";
		}
		
		// Compilation du code Objet
		String objectCodeTmpFile = duplicateFilePrepend(object.codeFileName, GMName + "/" + object.name, prepend);

		compileRAW(objectCodeTmpFile);
		byte[] bin = Files.readAllBytes(Paths.get(getBINFileName(objectCodeTmpFile)));
		object.code.uncompressedSize = bin.length;

		if (object.code.uncompressedSize > RamImage.PAGE_SIZE) {
			throw new Exception("file " + objectCodeTmpFile + " is too large:" + object.code.uncompressedSize + " bytes (max:" + RamImage.PAGE_SIZE + ")");
		}

		object.code.bin = Files.readAllBytes(Paths.get(getBINFileName(objectCodeTmpFile)));
		return object.code.bin;
	}		

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private static void computeRamAddress() throws Exception {
		
		logger.debug("computeRamAddress ...");
		
		// La taille des index fichier du RAMLoader dépend du nombre de pages utilisées par chaque Game Loader
		// première passe de sac a dos pour determiner le nombre de pages necessaires pour chaque Game Mode
		int initStartPage = 4;		
		int startPage;
		
		int fileIndexSize_FD = 0;
		int fileIndexSize_T2 = 0;		
		
		// Au runtime on a le game mode courant (celui chargé en RAM) et le prochain game Mode
		// Au moment du chargement une comparaison est effectuée entre chaque ligne de l'index fichier
		// si ligne identique : pas de chargement de la ligne (a faire jusqu'a la fin de l'index)
		// Necessite de trier les lignes d'index fichier pour pouvoir faire une comparaison sans tout parcourir
		// et de positionner les communs en début d'index
		
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			logger.debug("\tGame Mode : " + gameMode.getValue().name);
		
			gameMode.getValue().ramFD.page = initStartPage;

			// Calcul de la taille d'index fichier pour les Communs du game Mode (Disquette)
			for (GameModeCommon common : gameMode.getValue().gameModeCommon) {
				if (common != null) {
					if (!abortFloppyDisk) {
						logger.debug("\t\tCommon : " + common.name);
						common.items = getRAMItems(common.objects, FLOPPY_DISK);
						startPage = gameMode.getValue().ramFD.page;
						computeItemsRamAddress(common.name, common.items, gameMode.getValue().ramFD, false);
						fileIndexSize_FD += (gameMode.getValue().ramFD.page - startPage + 1);
						
						if (gameMode.getValue().ramFD.isOutOfMemory())
							abortFloppyDisk = true;
					}
				}
			}
			
			// Calcul de la taille d'index fichier pour le Game Mode (Disquette)
			if (!abortFloppyDisk) {
				gameMode.getValue().items = getRAMItems(gameMode.getValue().objects, FLOPPY_DISK);
				
				startPage = gameMode.getValue().ramFD.page;				
				computeItemsRamAddress(gameMode.getKey(), gameMode.getValue().items, gameMode.getValue().ramFD, false);
				fileIndexSize_FD += (gameMode.getValue().ramFD.page - startPage + 1);
				
				if (gameMode.getValue().ramFD.isOutOfMemory())
					abortFloppyDisk = true;
			}
			
			gameMode.getValue().ramT2.page = initStartPage;
			
			// Calcul de la taille d'index fichier pour les Communs du game Mode (T.2)
			for (GameModeCommon common : gameMode.getValue().gameModeCommon) {
				if (common != null) {
					if (!abortT2) {
						logger.debug("\t\tCommon : " + common.name);
						common.items = getRAMItems(common.objects, MEGAROM_T2);
						
						startPage = gameMode.getValue().ramT2.page;						
						computeItemsRamAddress(common.name, common.items, gameMode.getValue().ramT2, false);
						fileIndexSize_FD += (gameMode.getValue().ramT2.page - startPage + 1);
												
						if (gameMode.getValue().ramT2.isOutOfMemory())
							abortFloppyDisk = true;
					}
				}
			}			
			
			// Calcul de la taille d'index fichier pour le Game Mode (T.2)
			if (!abortT2) {
				gameMode.getValue().items = getRAMItems(gameMode.getValue().objects, MEGAROM_T2);
				
				startPage = gameMode.getValue().ramT2.page;				
				computeItemsRamAddress(gameMode.getKey(), gameMode.getValue().items, gameMode.getValue().ramT2, false);
				fileIndexSize_FD += (gameMode.getValue().ramT2.page - startPage + 1);
								
				if (gameMode.getValue().ramT2.isOutOfMemory())
					abortT2 = true;
			}
		}

		if (abortFloppyDisk && abortT2)
			logger.fatal("Not enough RAM !");
		
		// calcul de la taille des index fichier de RAMLoader/RAMLoaderManager
		// nb total de pages utiles * 2 (demi-pages) * 7 (taille du bloc de données)
		fileIndexSize_FD *= 14;
		fileIndexSize_T2 *= 14;  
		
		// Positionnement des adresses de départ du code en RAM
		int initStartAddressFD = compileAndWriteRAMLoaderManager(FLOPPY_DISK); // TODO: Code a modifier pour nouvel index fichier
		int initStartAddressT2 = compileAndWriteRAMLoaderManager(MEGAROM_T2); // TODO: Code a modifier pour nouvel index fichier
		
		logger.debug("compute ram position ... ");
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			
			logger.debug("\tGame Mode : " + gameMode.getValue().name);

			if (!abortFloppyDisk) {
				gameMode.getValue().ramFD.page = initStartPage;
				gameMode.getValue().ramFD.endAddress[gameMode.getValue().ramFD.page] = initStartAddressFD;

				for (GameModeCommon common : gameMode.getValue().gameModeCommon) {
					if (common != null) {
						logger.debug("\t\tCommon : " + common.name);
						startPage = gameMode.getValue().ramFD.page;
						computeItemsRamAddress(common.name, common.items, gameMode.getValue().ramFD, true);
						fileIndexSize_FD += (gameMode.getValue().ramFD.page - startPage + 1);
					}
				}

				startPage = gameMode.getValue().ramFD.page;
				computeItemsRamAddress(gameMode.getKey(), gameMode.getValue().items, gameMode.getValue().ramFD, true);
				fileIndexSize_FD += (gameMode.getValue().ramFD.page - startPage + 1);
			}
			
			if (!abortT2) {
				gameMode.getValue().ramT2.page = initStartPage;
				gameMode.getValue().ramT2.endAddress[gameMode.getValue().ramT2.page] = initStartAddressT2;

				for (GameModeCommon common : gameMode.getValue().gameModeCommon) {
					if (common != null) {
						logger.debug("\t\tCommon : " + common.name);
						startPage = gameMode.getValue().ramT2.page;
						computeItemsRamAddress(common.name, common.items, gameMode.getValue().ramT2, true);
						fileIndexSize_T2 += (gameMode.getValue().ramT2.page - startPage + 1);
					}
				}

				startPage = gameMode.getValue().ramT2.page;
				computeItemsRamAddress(gameMode.getKey(), gameMode.getValue().items, gameMode.getValue().ramT2, true);
				fileIndexSize_T2 += (gameMode.getValue().ramT2.page - startPage + 1);
			}
		}
		
		// split et exomize des pages
		
		
		// TODO : générer les pages pour les objets non flagués RAM pour T.2
		// La limite en nb de pages est maintenant basée sur nb pages T.2 et nb pages déjà prises pour la RAM
		// Le check taille disquette est fait plus tard lors de l'écriture sur média cible	
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static Item[] getRAMItems(HashMap<String, Object> objects, String mode) {
		logger.debug("\t\tCompute RAM Items for " + mode + " ...");

		// GAME MODE DATA - Répartition des données en RAM
		// -----------------------------------------------

		// mode FLOPPY : Toutes les données sont chargées en RAM
		// mode T.2 : Seul code/sprite/animation/sound des objets qui ont le flag RAM
		// sont chargés en RAM
		// Deux raison pour charger des données en RAM avec la T.2 :
		// - dans le cas d'un code avec auto modification, ou présence de données
		// - dans le cas ou l'on souhaite gagner de la place sur la T.2
		// les données sont alors compressées sur T.2 et décompressées en RAM au runtime

		// Gestion d'un game mode "commun" (un seul par Game Mode)
		// Au runtime, si le commun nécessaire au nouveau Game Mode est déjà présent, on
		// ne le recharge pas.

		// Compte le nombre d'objets a traiter
		int nbGameModeItems = 0;
		for (Entry<String, Object> object : objects.entrySet()) {

			// Sprites
			for (SubSpriteBin subSprite : object.getValue().subSpritesBin)
				if (mode.contentEquals(FLOPPY_DISK) || (mode.contentEquals(MEGAROM_T2) && subSprite.inRAM))
					nbGameModeItems += 1;

			// ImageSet Index
			if (object.getValue().subSpritesBin.size() > 0
					&& (mode.contentEquals(FLOPPY_DISK) || (mode.contentEquals(MEGAROM_T2) && object.getValue().imageSetInRAM)))
				nbGameModeItems++;

			// Animation Index
			if (!object.getValue().animationsProperties.isEmpty()
					&& (mode.contentEquals(FLOPPY_DISK) || (mode.contentEquals(MEGAROM_T2) && object.getValue().animationInRAM)))
				nbGameModeItems++;

			// Sounds
			for (Sound sound : object.getValue().sounds)
				for (SoundBin soundBIN : sound.sb)
					if (mode.contentEquals(FLOPPY_DISK) || (mode.contentEquals(MEGAROM_T2) && soundBIN.inRAM))
						nbGameModeItems += 1;

			// Object Code
			if (mode.contentEquals(FLOPPY_DISK) || (mode.contentEquals(MEGAROM_T2) && object.getValue().codeInRAM))
				nbGameModeItems++;
		}

		// Initialise un item pour chaque élément a écrire en RAM
		Item[] items = new Item[nbGameModeItems];
		int itemIdx = 0;

		// Initialisation des items
		for (Entry<String, Object> object : objects.entrySet()) {

			// Sprites
			for (SubSpriteBin subSprite : object.getValue().subSpritesBin)
				if (mode.contentEquals(FLOPPY_DISK) || (mode.contentEquals(MEGAROM_T2) && subSprite.inRAM))
					items[itemIdx++] = new Item(subSprite, 1);

			// ImageSet Index
			if (object.getValue().subSpritesBin.size() > 0
					&& (mode.contentEquals(FLOPPY_DISK) || (mode.contentEquals(MEGAROM_T2) && object.getValue().imageSetInRAM)))
				items[itemIdx++] = new Item(object.getValue().imageSet, 1);

			// Animation Index
			if (!object.getValue().animationsProperties.isEmpty()
					&& (mode.contentEquals(FLOPPY_DISK) || (mode.contentEquals(MEGAROM_T2) && object.getValue().animationInRAM)))
				items[itemIdx++] = new Item(object.getValue().animation, 1);

			// Sounds
			for (Sound sound : object.getValue().sounds)
				for (SoundBin soundBIN : sound.sb)
					if (mode.contentEquals(FLOPPY_DISK) || (mode.contentEquals(MEGAROM_T2) && soundBIN.inRAM))
						items[itemIdx++] = new Item(soundBIN, 1);

			// Object Code
			if (mode.contentEquals(FLOPPY_DISK) || (mode.contentEquals(MEGAROM_T2) && object.getValue().codeInRAM)) {
				Item obj = new Item(object.getValue().code, 1);
				obj.absolute = true;
				items[itemIdx++] = obj;	
			}
		}

		return items;
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static void computeItemsRamAddress(String GMName, Item[] items, RamImage rImg, boolean writeIndex) throws Exception {
		boolean firstLoop = true;
		
		while (items.length > 0) {

			if (!firstLoop) {
				rImg.page++;
				rImg.startAddress[rImg.page] = 0x0000; // La page est montée dans l'espace cartouche
			}
			firstLoop = false;
			
			// les données sont réparties en pages en fonction de leur taille par un
			// algorithme "sac à dos"
			Knapsack knapsack = new Knapsack(items, RamImage.PAGE_SIZE-rImg.startAddress[rImg.page]); // Sac à dos de poids max 16Ko

			Solution solution = knapsack.solve();
			logger.debug("\t\tFind solution for page : " + rImg.page);

			// Parcours de la solution
			for (Iterator<Item> iter = solution.items.listIterator(); iter.hasNext();) {

				Item currentItem = iter.next();

				if (writeIndex) {
					currentItem.bin.dataIndex.page = rImg.page;					
					currentItem.bin.dataIndex.address = rImg.endAddress[rImg.page];
					
					if (currentItem.absolute)
						currentItem.bin.bin = compileObject(GMName, ((ObjectBin)currentItem.bin).parent, rImg.endAddress[rImg.page]);
					
					rImg.setDataAtCurPos(currentItem.bin.bin);
					currentItem.bin.dataIndex.endAddress = rImg.endAddress[rImg.page];
				}

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
			if (writeIndex) {
				logger.debug("\t\tNon allocated space    : " + (RamImage.PAGE_SIZE - rImg.endAddress[rImg.page]) + " octets");
			}
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static void generateImgAniIndex() throws Exception {
		logger.info("Generate Image index and Animation script index ...");
		
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			logger.debug("\nGame Mode : " + gameMode.getKey());
			
			// Game Mode Common
			for (GameModeCommon common : gameMode.getValue().gameModeCommon) {
				if (common != null) {
					for (Entry<String, Object> object : common.objects.entrySet()) {
						generateImgAniIndex(object.getValue());
						gameMode.getValue().ramFD.setData(object.getValue().imageSet.dataIndex.page, object.getValue().imageSet.dataIndex.address, Files.readAllBytes(Paths.get(Game.generatedCodeDirName + object.getValue() + "/" + object.getValue().imageSet.fileName)));
						gameMode.getValue().ramFD.setData(object.getValue().animation.dataIndex.page, object.getValue().animation.dataIndex.address, Files.readAllBytes(Paths.get(Game.generatedCodeDirName + object.getValue() + "/" + object.getValue().animation.fileName)));
						if (object.getValue().imageSetInRAM)
							gameMode.getValue().ramFD.setData(object.getValue().imageSet.dataIndex.page, object.getValue().imageSet.dataIndex.address, Files.readAllBytes(Paths.get(Game.generatedCodeDirName + object.getValue() + "/" + object.getValue().imageSet.fileName)));
						if (object.getValue().animationInRAM)						
							gameMode.getValue().ramFD.setData(object.getValue().animation.dataIndex.page, object.getValue().animation.dataIndex.address, Files.readAllBytes(Paths.get(Game.generatedCodeDirName + object.getValue() + "/" + object.getValue().animation.fileName)));						
						//T2 in ROM
					}
				}
			}
			
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				generateImgAniIndex(object.getValue());
				gameMode.getValue().ramFD.setData(object.getValue().imageSet.dataIndex.page, object.getValue().imageSet.dataIndex.address, Files.readAllBytes(Paths.get(Game.generatedCodeDirName + object.getValue() + "/" + object.getValue().imageSet.fileName)));
				gameMode.getValue().ramFD.setData(object.getValue().animation.dataIndex.page, object.getValue().animation.dataIndex.address, Files.readAllBytes(Paths.get(Game.generatedCodeDirName + object.getValue() + "/" + object.getValue().animation.fileName)));
				if (object.getValue().imageSetInRAM)
					gameMode.getValue().ramFD.setData(object.getValue().imageSet.dataIndex.page, object.getValue().imageSet.dataIndex.address, Files.readAllBytes(Paths.get(Game.generatedCodeDirName + object.getValue() + "/" + object.getValue().imageSet.fileName)));
				if (object.getValue().animationInRAM)						
					gameMode.getValue().ramFD.setData(object.getValue().animation.dataIndex.page, object.getValue().animation.dataIndex.address, Files.readAllBytes(Paths.get(Game.generatedCodeDirName + object.getValue() + "/" + object.getValue().animation.fileName)));						
				//T2 in ROM
			}
		}
	}
	
	private static void generateImgAniIndex(Object object) throws Exception {
		AsmSourceCode asmImgIndex = new AsmSourceCode(createFile(object.imageSet.fileName, object.name));
		for (Entry<String, Sprite> sprite : object.sprites.entrySet()) {
			writeImgIndex(asmImgIndex, sprite.getValue());
		}

		AsmSourceCode asmAniIndex = new AsmSourceCode(createFile(object.animation.fileName, object.name));
		writeAniIndex(asmAniIndex, object);
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
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
	
	private static int compileAndWriteRAMLoaderManager(String mode) throws Exception {
		logger.info("Compile and Write RAM Loader Manager for " + mode + " ...");

		// GAME MODE DATA - Construction des données de chargement disquette pour chaque Game Mode
		// ---------------------------------------------------------------------------------------
		AsmSourceCode dataIndex = new AsmSourceCode(createFile(FileNames.FILE_INDEX));
		dataIndex.addCommentLine("structure: sector, nb sector, drive (bit 7) track (bit 6-0), end offset, ram dest page, ram dest end addr. hb, ram dest end addr. lb");
		
		// Parcours des objets du Game Mode
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			
			dataIndex.addLabel("gm_" + gameMode.getKey());
			dataIndex.addFdb(new String[] { "RL_RAM_index+"+(gameMode.getValue().dataSize-2+6+1)}); // -2 index, +6 balise FF (lecture par groupe de 7 octets), +1 balise FF ajoutée par le GameModeManager au runtime	
			
			// Ajout du tag pour identifier le game mode de démarrage
			if (gameMode.getKey().contentEquals(game.gameModeBoot)) {
				dataIndex.addLabel("gmboot");
			}
			
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				for (Entry<String, Sprite> sprite : object.getValue().sprites.entrySet()) {
					for (Entry<String, SubSprite> subSprite : sprite.getValue().subSprites.entrySet()) {
						extractSubSpriteFileIndex(subSprite.getValue(), dataIndex, sprite.getKey()+" "+subSprite.getValue().name);
					}
				}
				
				for (Sound sound : object.getValue().sounds) {
					for (SoundBin sb : sound.sb) {
						dataIndex.addFcb(new String[] {
						String.format("$%1$02X", sb.dataIndex.sector),
						String.format("$%1$02X", sb.dataIndex.nbSector-1),
						String.format("$%1$02X", (sb.dataIndex.drive << 7)+sb.dataIndex.track),				
						String.format("$%1$02X", -sb.dataIndex.endOffset & 0xFF),
						String.format("$%1$02X", sb.dataIndex.page),	
						String.format("$%1$02X", sb.dataIndex.endAddress >> 8),			
						String.format("$%1$02X", sb.dataIndex.endAddress & 0x00FF)});			
						dataIndex.appendComment(sound.name + sound.sb.indexOf(sb) + " Sound");						
					}
				}
				
				// Code de l'objet
				dataIndex.addFcb(new String[] {
				String.format("$%1$02X", object.getValue().code.dataIndex.sector),
				String.format("$%1$02X", object.getValue().code.dataIndex.nbSector-1),
				String.format("$%1$02X", (object.getValue().code.dataIndex.drive << 7)+object.getValue().code.dataIndex.track),				
				String.format("$%1$02X", -object.getValue().code.dataIndex.endOffset & 0xFF),
				String.format("$%1$02X", object.getValue().code.dataIndex.page),	
				String.format("$%1$02X", object.getValue().code.dataIndex.endAddress >> 8),			
				String.format("$%1$02X", object.getValue().code.dataIndex.endAddress & 0x00FF)});			
				dataIndex.appendComment(object.getValue().name+ " Object code");
			}
			
			// Code main engine
			dataIndex.addFcb(new String[] {
			String.format("$%1$02X", gameMode.getValue().code.dataIndex.sector),
			String.format("$%1$02X", gameMode.getValue().code.dataIndex.nbSector-1),
			String.format("$%1$02X", (gameMode.getValue().code.dataIndex.drive << 7)+gameMode.getValue().code.dataIndex.track),			
			String.format("$%1$02X", -gameMode.getValue().code.dataIndex.endOffset & 0xFF),
			String.format("$%1$02X", gameMode.getValue().code.dataIndex.page),	
			String.format("$%1$02X", gameMode.getValue().code.dataIndex.endAddress >> 8),			
			String.format("$%1$02X", gameMode.getValue().code.dataIndex.endAddress & 0x00FF)});			
			dataIndex.appendComment(gameMode.getValue().name+ " Main Engine code");			
		}
		
		dataIndex.addFcb(new String[] { "$FF" });		
		dataIndex.flush();
		
		// GAME MODE DATA - Compilation du Game Mode Manager
		// -------------------------------------------------		

		String gameModeManagerTmpFile = duplicateFile(game.engineAsmRAMLoaderManager);
		compileRAW(gameModeManagerTmpFile);
		game.engineRAMLoaderManagerBytes = Files.readAllBytes(Paths.get(getBINFileName(gameModeManagerTmpFile)));

		if (game.engineRAMLoaderManagerBytes.length > RamImage.PAGE_SIZE) {
			throw new Exception("Le fichier "+game.engineAsmRAMLoaderManager+" est trop volumineux:"+game.engineRAMLoaderManagerBytes.length+" octets (max:"+RamImage.PAGE_SIZE+")");
		}
		
		// Ecriture sur disquette
		//fd.setIndex(0, 0, 2);		
		//fd.write(game.engineRAMLoaderManagerBytes);		
		
		return game.engineRAMLoaderManagerBytes.length;
	}
	
	private static void compileAndWriteBoot() throws IOException {
		logger.info("Compile boot ...");
		
		String bootTmpFile = duplicateFile(game.engineAsmBoot);
		Game.glb.addConstant("boot_dernier_bloc", String.format("$%1$02X", (0xA000 + game.engineRAMLoaderManagerBytes.length) >> 8)+"00"); // On tronque l'octet de poids faible
		Game.glb.flush();
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
		if (ssBin != null && ssBin.dataIndex != null) {
			String[] line = new String[7];			
			line [0] = String.format("$%1$02X", ssBin.dataIndex.sector);
			line [1] = String.format("$%1$02X", ssBin.dataIndex.nbSector-1);
			line [2] = String.format("$%1$02X", (ssBin.dataIndex.drive << 7)+ssBin.dataIndex.track);			
			line [3] = String.format("$%1$02X", -ssBin.dataIndex.endOffset & 0xFF);
			line [4] = String.format("$%1$02X", ssBin.dataIndex.page);			
			line [5] = String.format("$%1$02X", ssBin.dataIndex.endAddress >> 8);			
			line [6] = String.format("$%1$02X", ssBin.dataIndex.endAddress & 0x00FF);			
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
		line.add(String.format("$%1$02X", s.draw.dataIndex.page));
		line.add(String.format("$%1$02X", s.draw.dataIndex.address >> 8));		
		line.add(String.format("$%1$02X", s.draw.dataIndex.address & 0xFF));
		
		if (s.erase != null) {
			line.add(String.format("$%1$02X", s.erase.dataIndex.page));
			line.add(String.format("$%1$02X", s.erase.dataIndex.address >> 8));		
			line.add(String.format("$%1$02X", s.erase.dataIndex.address & 0xFF));
			line.add(String.format("$%1$02X", s.nb_cell)); // unsigned value
		}
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static void writeObjIndex(AsmSourceCode asmBuilder, GameMode gameMode) {	
		String[][] objIndexPage = new String[gameMode.objects.entrySet().size() + 1][];
		String[][] objIndex = new String[gameMode.objects.entrySet().size() + 1][];
		
		// Game Mode Common
		for (GameModeCommon common : gameMode.gameModeCommon) {
			if (common != null) {
				for (Entry<String, Object> object : common.objects.entrySet()) {
					if (object.getValue().code.dataIndex != null) {
						objIndexPage[gameMode.objectsId.get(object.getValue())] = new String[] {String.format("$%1$02X", object.getValue().code.dataIndex.page) };
						objIndex[gameMode.objectsId.get(object.getValue())] = new String[] {String.format("$%1$02X", object.getValue().code.dataIndex.address >> 8), String.format("$%1$02X", object.getValue().code.dataIndex.address & 0x00FF) };
					}
				}
			}
		}
		
		// Objets du Game Mode
		for (Entry<String, Object> object : gameMode.objects.entrySet()) {
			if (object.getValue().code.dataIndex != null) {
				objIndexPage[gameMode.objectsId.get(object.getValue())] = new String[] {String.format("$%1$02X", object.getValue().code.dataIndex.page) };
				objIndex[gameMode.objectsId.get(object.getValue())] = new String[] {String.format("$%1$02X", object.getValue().code.dataIndex.address >> 8), String.format("$%1$02X", object.getValue().code.dataIndex.address & 0x00FF) };
			}
		}		

		asmBuilder.addLabel("Obj_Index_Page");
		for (int i = 0; i < objIndexPage.length; i++) {
			if (objIndexPage[i] == null) {
				objIndexPage[i] = new String[] { "$00" };
			}
			asmBuilder.addFcb(objIndexPage[i]);
		}

		asmBuilder.addLabel("Obj_Index_Address");
		for (int i = 0; i < objIndex.length; i++) {
			if (objIndex[i] == null) {
				objIndex[i] = new String[] { "$00", "$00" };
			}
			asmBuilder.addFcb(objIndex[i]);
		}	
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private static void writeSndIndex(AsmSourceCode asmSndIndex, GameMode gameMode) {
		
		// Game Mode Common
		for (GameModeCommon common : gameMode.gameModeCommon) {
			if (common != null) {
				for (Entry<String, Object> object : common.objects.entrySet()) {
					for (Sound sound : object.getValue().sounds) {
						writeSndIndex(asmSndIndex, sound);
					}
				}
			}
		}
		
		// Objets du Game Mode
		for (Entry<String, Object> object : gameMode.objects.entrySet()) {
			for (Sound sound : object.getValue().sounds) {
				writeSndIndex(asmSndIndex, sound);
			}
		}
	}
	
	private static void writeSndIndex(AsmSourceCode asmSndIndex, Sound sound) {
		asmSndIndex.addLabel(sound.name + " ");
		for (SoundBin sb : sound.sb) {
			String[] line = new String[5];
			line[0] = String.format("$%1$02X", sb.dataIndex.page);
			line[1] = String.format("$%1$02X", sb.dataIndex.address >> 8);
			line[2] = String.format("$%1$02X", sb.dataIndex.address & 0x00FF);
			line[3] = String.format("$%1$02X", sb.dataIndex.endAddress >> 8);
			line[4] = String.format("$%1$02X", sb.dataIndex.endAddress & 0x00FF);
			asmSndIndex.addFcb(line);
		}
		asmSndIndex.addFcb(new String[] { "$00" });
	}	
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static void writeImgPgIndex(AsmSourceCode asmBuilder, GameMode gameMode) throws Exception {
		asmBuilder.addLabel("Img_Page_Index");		
		// Game Mode Common
		for (GameModeCommon common : gameMode.gameModeCommon) {
			if (common != null) {
				for (Entry<String, Object> object : common.objects.entrySet()) {
					if (object.getValue().imageSet != null && object.getValue().imageSet.dataIndex != null) {
					asmBuilder.addFcb(new String[] { String.format("$%1$02X", object.getValue().imageSet.dataIndex.page) });
					} else {
						asmBuilder.addFcb(new String[] {"$00"});
					}
				}
			}
		}
		
		// Objets du Game Mode
		for (Entry<String, Object> object : gameMode.objects.entrySet()) {
			if (object.getValue().imageSet != null && object.getValue().imageSet.dataIndex != null) {
				asmBuilder.addFcb(new String[] { String.format("$%1$02X", object.getValue().animation.dataIndex.page) });
			} else {
				asmBuilder.addFcb(new String[] {"$00"});
			}			
		}
	}	
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static void writeAniPgIndex(AsmSourceCode asmBuilder, GameMode gameMode) throws Exception {
		asmBuilder.addLabel("Ani_Page_Index");		
		// Game Mode Common
		for (GameModeCommon common : gameMode.gameModeCommon) {
			if (common != null) {
				for (Entry<String, Object> object : common.objects.entrySet()) {
					if (object.getValue().animation != null && object.getValue().animation.dataIndex != null) {
						asmBuilder.addFcb(new String[] { String.format("$%1$02X", object.getValue().animation.dataIndex.page) });
					} else {
						asmBuilder.addFcb(new String[] {"$00"});
					}
				}
			}
		}
		
		// Objets du Game Mode
		for (Entry<String, Object> object : gameMode.objects.entrySet()) {
			if (object.getValue().animation != null && object.getValue().animation.dataIndex != null) {
				asmBuilder.addFcb(new String[] { String.format("$%1$02X", object.getValue().animation.dataIndex.page) });
			} else {
				asmBuilder.addFcb(new String[] {"$00"});
			}			
		}
	}	
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
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

			ProcessBuilder pb = new ProcessBuilder(Game.exobin, Paths.get(binFile).toString());
			pb.redirectErrorStream(true);
			Process p = pb.start();
			BufferedReader br=new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;

			while((line=br.readLine())!=null){
				logger.debug("\t\t\t" + line);
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
		String destFileName = Game.generatedCodeDirName+basename+".asm";

		Path original = Paths.get(fileName);        
		Path copied = Paths.get(destFileName);
		Files.copy(original, copied, StandardCopyOption.REPLACE_EXISTING);
		return destFileName;
	}
	
	public static String duplicateFile(String fileName, String subDir) throws IOException {
		String basename = FileUtil.removeExtension(Paths.get(fileName).getFileName().toString());
		String destFileName = Game.generatedCodeDirName+subDir+"/"+basename+".asm";

		// Creation du chemin si les répertoires sont manquants
		File file = new File (destFileName);
		file.getParentFile().mkdirs();
		
		Path original = Paths.get(fileName);        
		Path copied = Paths.get(destFileName);
		Files.copy(original, copied, StandardCopyOption.REPLACE_EXISTING);
		return destFileName;
	}	
	
	public static String duplicateFilePrepend(String fileName, String subDir, String prepend) throws IOException {
		String basename = FileUtil.removeExtension(Paths.get(fileName).getFileName().toString());
		String destFileName = Game.generatedCodeDirName+subDir+"/"+basename+".asm";

		// Creation du chemin si les répertoires sont manquants
		File file = new File (destFileName);
		file.getParentFile().mkdirs();
		
		List<String> result = new ArrayList<>();
		result.add(prepend);
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


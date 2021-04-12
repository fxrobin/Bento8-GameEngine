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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Enumeration;
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
import fr.bento8.to8.image.Animation;
import fr.bento8.to8.image.AnimationBin;
import fr.bento8.to8.image.ImageSetBin;
import fr.bento8.to8.image.PaletteTO8;
import fr.bento8.to8.image.Sprite;
import fr.bento8.to8.image.SpriteSheet;
import fr.bento8.to8.image.SubSprite;
import fr.bento8.to8.image.SubSpriteBin;
import fr.bento8.to8.ram.RamImage;
import fr.bento8.to8.storage.BinUtil;
import fr.bento8.to8.storage.DataIndex;
import fr.bento8.to8.storage.FdUtil;
import fr.bento8.to8.util.FileUtil;
import fr.bento8.to8.util.LWASMUtil;
import fr.bento8.to8.util.knapsack.Item;
import fr.bento8.to8.util.knapsack.Knapsack;
import fr.bento8.to8.util.knapsack.Solution;

public class BuildDisk
{
	static final Logger logger = LogManager.getLogger("log");

	public static Game game;
	private static int gm_totalSize = 0; // Taille totale du binaire : Game Mode Manager + Game Mode Loader + Game Mode Data

	private static FdUtil fd = new FdUtil();
	
	public static int UNDEFINED = 0;
	public static int FLOPPY_DISK = 0;
	public static int MEGAROM_T2 = 1;
	public static String[] MODE_LABEL = new String[]{"FLOPPY_DISK", "MEGAROM_T2"};
	public static String[] MODE_DIR = new String[]{"FD", "T2"};
	public static boolean GAMEMODE = false;
	public static boolean GAMEMODE_COMMON = true;
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
			computeRamAddress();
			computeRomAddress();
			generateImgAniIndex(); 
			compileMainEngines();
			exomizeData();
			
			writeObjects(); // TODO écriture sur FD (entrelacé 2) des pages RAM et T2 (par Pages ROM) des pages RAM en ROM
			compileAndWriteRAMLoaderManager(); // TODO séparation en 2 fichiers FD et T2 + update données sur storage FD ou t2
			compileAndWriteBoot(); // TODO séparation en 2 fichiers FD et T2 + update données sur storage FD ou t2
			writeDiskImage(); // TODO ajout T2
			
			// Ecriture sur disquette
			//fd.setIndex(0, 0, 2);		
			//fd.write(game.engineRAMLoaderManagerBytes);	
			
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
		// Remarque: le code d'un objet n'est jamais commun, (seules les images et animations le sont)
		// En effet un code objet fait référence au MainEngine qui est spécifique au GameMode
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

		// Chargement des données audio
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

		// Génération des sprites compilés pour chaque objet
		// -------------------------------------------------

		// Parcours de tous les objets de manière unitaire
		for (Entry<String, Object> object : Game.allObjects.entrySet()) {
				generateSprites(object.getValue());
		}
	}
	
	private static void generateSprites(Object object) throws Exception {
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
				logger.debug("\t"+object.name+" Compile sprite: " + sprite.name + " image:" + sprite.spriteFile + " variant:" + cur_variant);

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
					curSubSprite.draw.uncompressedSize = asm.getDSize();
					curSubSprite.draw.inRAM = sprite.inRAM;
					object.subSpritesBin.add(curSubSprite.draw);

					curSubSprite.erase = new SubSpriteBin(curSubSprite);
					curSubSprite.erase.setName(cur_variant+" E");
					curSubSprite.erase.bin = Files.readAllBytes(Paths.get(asm.getEraseBINFile()));
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
					curSubSprite.draw.uncompressedSize = sasm.getDSize();
					curSubSprite.draw.inRAM = sprite.inRAM;							
					object.subSpritesBin.add(curSubSprite.draw);
				}

				sprite.subSprites.put(cur_variant, curSubSprite);
			}

			// Sauvegarde de tous les rendus demandés pour l'image en cours
			object.sprites.put(sprite.name, sprite);
			object.imageSet.uncompressedSize += writeImgIndex(asmImgIndex, sprite, UNDEFINED);
		}
		
		object.imageSet.bin = new byte[object.imageSet.uncompressedSize];
		AsmSourceCode asmAniIndex = new AsmSourceCode(createFile(object.animation.fileName, object.name));
		object.animation.uncompressedSize += writeAniIndex(asmAniIndex, object);
		object.animation.bin = new byte[object.animation.uncompressedSize];
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private static void compileMainEngines() throws Throwable {
		logger.info("Compile Main Engines ...");
		compileMainEngines(FLOPPY_DISK);
		compileMainEngines(MEGAROM_T2);
	}
	
	private static void compileMainEngines(int mode) throws Throwable {
		logger.info("Compile Main Engines for " + MODE_LABEL[mode] + "...");
		
		for(Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			logger.debug("\tGame Mode : " + gameMode.getKey());
			
			String mainEngineTmpFile = duplicateFile(gameMode.getValue().engineAsmMainEngine, gameMode.getKey()+"/"+MODE_DIR[mode]+"/");
			AsmSourceCode asmBuilder = new AsmSourceCode(createFile(FileNames.MAIN_GENCODE, gameMode.getValue().name));			
			
			writePalIndex(asmBuilder, gameMode.getValue());
			writeObjIndex(asmBuilder, gameMode.getValue(), mode);
			writeSndIndex(asmBuilder, gameMode.getValue());
			writeImgPgIndex(asmBuilder, gameMode.getValue(), mode);
			writeAniPgIndex(asmBuilder, gameMode.getValue(), mode);
			writeLoadActIndex(asmBuilder, gameMode.getValue());
			
			compileRAW(mainEngineTmpFile);
			byte[] binBytes = Files.readAllBytes(Paths.get(getBINFileName(mainEngineTmpFile)));

			if (binBytes.length > RamImage.PAGE_SIZE) {
				throw new Exception("file " + gameMode.getValue().engineAsmMainEngine + " is too large:" + binBytes.length + " bytes (max:"+RamImage.PAGE_SIZE+")");
			}
			
			// Le MainEngine est de taille constante, ci dessous utilisé pour le calcul emplacement ram/rom, pas besoin de demultiplier pour FD/T2
			gameMode.getValue().code = new ObjectBin();
			byte[] mainBin = Files.readAllBytes(Paths.get(getBINFileName(mainEngineTmpFile)));
			gameMode.getValue().code.bin = mainBin;
			
			// Dans le cas d'une seconde passe on maj les données
			if (mode == FLOPPY_DISK) {
				gameMode.getValue().code.dataIndex.fd_ram_page = 1;
				gameMode.getValue().code.dataIndex.fd_ram_address = 0x6100;				
				gameMode.getValue().ramFD.setData(gameMode.getValue().code.dataIndex.fd_ram_page, 0x0100, mainBin);
			} else {
				gameMode.getValue().code.dataIndex.t2_ram_page = 1;
				gameMode.getValue().code.dataIndex.t2_ram_address = 0x6100;				
				gameMode.getValue().ramT2.setData(gameMode.getValue().code.dataIndex.t2_ram_page, 0x0100, mainBin);
			}
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
						compileObject(gameMode.getValue(), object.getValue(), 0);
					}
				}
			}
			
			for (Entry<String, Object> object : gameMode.getValue().objects.entrySet()) {
				compileObject(gameMode.getValue(), object.getValue(), 0);
			}		
		}		
	}	
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static byte[] compileObject(GameMode gm, Object object, int org) throws Exception {
		logger.info("\t\t"+object.name+" at "+String.format("$%1$04X", org));

		String prepend;
		
		prepend = "\torg   $" + org + "\n";
		prepend = "\topt   c,ct\n";
		
		prepend += "\tINCLUDE \"" + Game.generatedCodeDirName + gm.name + "/" + MODE_DIR[UNDEFINED] + "/" + FileNames.MAIN_GENCODEGLB+"\"\n";
		prepend += "\tINCLUDE \"" + Game.generatedCodeDirName + gm.name + "/" + FileNames.OBJECTID+"\"\n";
		
		if (object.sprites.size() > 0) {
			duplicateFile(Game.generatedCodeDirName + object.name + "/" +object.imageSet.fileName, gm.name + "/" + object.name);
			prepend += "\tINCLUDE \"" + Game.generatedCodeDirName + gm.name + "/" + object.name + "/" + object.imageSet.fileName + "\"\n";
			prepend += "\tINCLUDE \"" + Game.generatedCodeDirName + object.name + "/" + object.animation.fileName + "\"\n";
		}
		
		// Compilation du code Objet
		String objectCodeTmpFile = duplicateFilePrepend(object.codeFileName, gm.name + "/" + object.name, prepend);

		compileRAW(objectCodeTmpFile);
		object.gmCode.get(gm).code.bin = Files.readAllBytes(Paths.get(getBINFileName(objectCodeTmpFile)));
		object.gmCode.get(gm).code.uncompressedSize = object.gmCode.get(gm).code.bin.length;

		if (object.gmCode.get(gm).code.uncompressedSize > RamImage.PAGE_SIZE) {
			throw new Exception("file " + objectCodeTmpFile + " is too large:" + object.gmCode.get(gm).code.uncompressedSize + " bytes (max:" + RamImage.PAGE_SIZE + ")");
		}

		return object.gmCode.get(gm).code.bin;
	}		
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static void computeRamAddress() throws Exception {
		
		logger.debug("computeRamAddress ...");
		
		// La taille des index fichier du RAMLoader dépend du nombre de pages utilisées par chaque Game Loader
		// première passe de sac a dos pour determiner le nombre de pages necessaires pour chaque Game Mode
		int initStartPage = 4;
		int INDEX_STRUCT_SIZE_FD = 7;
		int INDEX_STRUCT_SIZE_T2 = 6;
		int totalIndexSizeFD = 0;
		int totalIndexSizeT2 = 0;		
		
		// Au runtime on a le game mode courant (celui chargé en RAM) et le prochain game Mode
		// Au moment du chargement une comparaison est effectuée entre chaque ligne de l'index fichier
		// si ligne identique : pas de chargement de la ligne (a faire jusqu'a la fin de l'index)
		// Necessite de trier les lignes d'index fichier pour pouvoir faire une comparaison sans tout parcourir
		// et de positionner les communs en début d'index
		GameMode gm;
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			gm = gameMode.getValue();
			logger.debug("\tGame Mode : " + gm.name);
		
			gm.ramFD.curPage = initStartPage;
			gm.indexSizeFD = 0;

			// Calcul de la taille d'index fichier pour les Communs du game Mode (Disquette)
			for (GameModeCommon common : gm.gameModeCommon) {
				if (common != null) {
					if (!abortFloppyDisk) {
						logger.debug("\t\tCommon : " + common.name);
						common.items = getRAMItems(gm, common.objects, FLOPPY_DISK, GAMEMODE_COMMON);
						gm.indexSizeFD += computeItemsRamAddress(gm, common.items, gm.ramFD, false);
						if (gm.ramFD.isOutOfMemory())
							abortFloppyDisk = true;
					}
				}
			}
			
			// Calcul de la taille d'index fichier pour le Game Mode (Disquette)
			if (!abortFloppyDisk) {
				gm.items = getRAMItems(gm, gm.objects, FLOPPY_DISK, GAMEMODE);
				gm.items = addCommonObjectCodeToRAMItems(gm.items, gm, FLOPPY_DISK);
				gm.indexSizeFD += computeItemsRamAddress(gm, gm.items, gm.ramFD, false);
				if (gm.ramFD.isOutOfMemory())
					abortFloppyDisk = true;
			}
			
			gm.indexSizeFD += 1; // index supplémentaire pour ajustement avec RAM Loader Manager
			gm.indexSizeFD *= INDEX_STRUCT_SIZE_FD;
			gm.indexSizeFD += 2; // index
			totalIndexSizeFD += gm.indexSizeFD;			
			logger.debug("\t\tindex size FD: "+gm.indexSizeFD);
			
			gm.ramT2.curPage = initStartPage;
			gm.indexSizeT2 = 0;
			
			// Calcul de la taille d'index fichier pour les Communs du game Mode (T.2)
			for (GameModeCommon common : gm.gameModeCommon) {
				if (common != null) {
					if (!abortT2) {
						logger.debug("\t\tCommon : " + common.name);
						common.items = getRAMItems(gm, common.objects, MEGAROM_T2, GAMEMODE_COMMON);
						gm.indexSizeT2 += computeItemsRamAddress(gm, common.items, gm.ramT2, false);
						if (gm.ramT2.isOutOfMemory())
							abortFloppyDisk = true;
					}
				}
			}			
			
			// Calcul de la taille d'index fichier pour le Game Mode (T.2)
			if (!abortT2) {
				gm.items = getRAMItems(gm, gm.objects, MEGAROM_T2, GAMEMODE);
				gm.items = addCommonObjectCodeToRAMItems(gm.items, gm, MEGAROM_T2);
				gm.indexSizeT2 += computeItemsRamAddress(gm, gm.items, gm.ramT2, false); 
				if (gm.ramT2.isOutOfMemory())
					abortT2 = true;
			}
			
			gm.indexSizeT2 += 1; // index supplémentaire pour ajustement avec RAM Loader Manager			
			gm.indexSizeT2 *= INDEX_STRUCT_SIZE_T2;
			gm.indexSizeT2 += 2; // index
			totalIndexSizeT2 += gm.indexSizeT2;
			logger.debug("\t\tindex size T2: "+gm.indexSizeT2);
		}

		if (abortFloppyDisk && abortT2)
			logger.fatal("Not enough RAM !");
		
		// Positionnement des adresses de départ du code en RAM
		// calcul de la taille des index fichier de RAMLoader/RAMLoaderManager
		Game.loadManagerSizeFd = getRAMLoaderManagerSize();
		Game.loadManagerSizeT2 = Game.loadManagerSizeFd;
		Game.loadManagerSizeFd += totalIndexSizeFD + 1; // ajout du bloc de fin
		Game.loadManagerSizeT2 += totalIndexSizeT2 + 1; // ajout du bloc de fin
		
		logger.debug("\t\tinitStartAddressFD: "+Game.loadManagerSizeFd);
		logger.debug("\t\tinitStartAddressT2: "+Game.loadManagerSizeT2);
		
		logger.debug("compute ram position ... ");
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			gm = gameMode.getValue();
			logger.debug("\tGame Mode : " + gm.name);

			if (!abortFloppyDisk) {
				gm.ramFD.curPage = initStartPage;
				gm.ramFD.curAddress = Game.loadManagerSizeFd;

				for (GameModeCommon common : gm.gameModeCommon) {
					if (common != null) {
						logger.debug("\t\tCommon : " + common.name);
						common.items = getRAMItems(gm, common.objects, FLOPPY_DISK, GAMEMODE_COMMON);
						computeItemsRamAddress(gm, common.items, gm.ramFD, true);
					}
				}
				gm.items = getRAMItems(gm, gm.objects, FLOPPY_DISK, GAMEMODE);
				gm.items = addCommonObjectCodeToRAMItems(gm.items, gm, FLOPPY_DISK);
				computeItemsRamAddress(gm, gm.items, gm.ramFD, true);
			}
			
			if (!abortT2) {
				gm.ramT2.curPage = initStartPage;
				gm.ramT2.curAddress = Game.loadManagerSizeT2;

				for (GameModeCommon common : gm.gameModeCommon) {
					if (common != null) {
						logger.debug("\t\tCommon : " + common.name);
						common.items = getRAMItems(gm, common.objects, MEGAROM_T2, GAMEMODE_COMMON);
						computeItemsRamAddress(gm, common.items, gm.ramT2, true);
					}
				}
				gm.items = getRAMItems(gm, gm.objects, MEGAROM_T2, GAMEMODE);
				gm.items = addCommonObjectCodeToRAMItems(gm.items, gm, MEGAROM_T2);
				computeItemsRamAddress(gm, gm.items, gm.ramT2, true);
			}
		}
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static Item[] getRAMItems(GameMode gm, HashMap<String, Object> objects, int mode, boolean isCommon) {
		logger.debug("\t\tCompute " + (isCommon?"Common":"") + " RAM Items for " + MODE_LABEL[mode] + " ...");

		// Répartition des données en RAM
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
				if (mode == FLOPPY_DISK || (mode == MEGAROM_T2 && subSprite.inRAM))
					nbGameModeItems += 1;

			// ImageSet Index
			if (object.getValue().subSpritesBin.size() > 0
					&& (mode == FLOPPY_DISK || (mode == MEGAROM_T2 && object.getValue().imageSetInRAM)))
				nbGameModeItems++;

			// Animation Index
			if (!object.getValue().animationsProperties.isEmpty()
					&& (mode == FLOPPY_DISK || (mode == MEGAROM_T2 && object.getValue().animationInRAM)))
				nbGameModeItems++;

			// Sounds
			for (Sound sound : object.getValue().sounds)
				for (SoundBin soundBIN : sound.sb)
					if (mode == FLOPPY_DISK || (mode == MEGAROM_T2 && soundBIN.inRAM))
						nbGameModeItems += 1;

			// Object Code
			if (!isCommon && (mode == FLOPPY_DISK || (mode == MEGAROM_T2 && object.getValue().codeInRAM)))
				nbGameModeItems++;
		}

		// Initialise un item pour chaque élément a écrire en RAM
		Item[] items = new Item[nbGameModeItems];
		int itemIdx = 0;

		// Initialisation des items
		for (Entry<String, Object> object : objects.entrySet()) {

			// Sprites
			for (SubSpriteBin subSprite : object.getValue().subSpritesBin)
				if (mode == FLOPPY_DISK || (mode == MEGAROM_T2 && subSprite.inRAM))
					items[itemIdx++] = new Item(subSprite, 1);

			// ImageSet Index
			if (object.getValue().subSpritesBin.size() > 0
					&& (mode == FLOPPY_DISK || (mode == MEGAROM_T2 && object.getValue().imageSetInRAM)))
				items[itemIdx++] = new Item(object.getValue().imageSet, 1);

			// Animation Index
			if (!object.getValue().animationsProperties.isEmpty()
					&& (mode == FLOPPY_DISK || (mode == MEGAROM_T2 && object.getValue().animationInRAM)))
				items[itemIdx++] = new Item(object.getValue().animation, 1);

			// Sounds
			for (Sound sound : object.getValue().sounds)
				for (SoundBin soundBIN : sound.sb)
					if (mode == FLOPPY_DISK || (mode == MEGAROM_T2 && soundBIN.inRAM))
						items[itemIdx++] = new Item(soundBIN, 1);

			// Object Code
			if (!isCommon && (mode == FLOPPY_DISK || (mode == MEGAROM_T2 && object.getValue().codeInRAM))) {
				Item obj = new Item(object.getValue().gmCode.get(gm).code, 1);
				items[itemIdx++] = obj;	
			}
		}

		return items;
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static Item[] addCommonObjectCodeToRAMItems(Item[] items, GameMode gm, int mode) {
		logger.debug("\t\tAdd common ObjectCode to GameMode RAM Items for " + MODE_LABEL[mode] + " ...");
		int nbGameModeItems = 0;
		Item[] newItems;

		// Un code objet ne peut pas être commun, il est spécifique à un GameMode MainEngine
		// On l'extrait donc des ressources communes pour l'ajouter au GameMode

		// Compte le nombre d'objets a traiter
		for (GameModeCommon common : gm.gameModeCommon) {
			if (common != null) {
				for (Entry<String, Object> object : common.objects.entrySet()) {

					// Ajoute les items du commun de type code objet
					if (mode == FLOPPY_DISK || (mode == MEGAROM_T2 && object.getValue().codeInRAM))
						nbGameModeItems++;
				}
			}
		}

		// Copie les items du Game Mode dans le nouveau tableau
		int i;
		newItems = new Item[items.length + nbGameModeItems];
		for (i = 0; i < items.length; i++) {
			newItems[i] = items[i];
		}

		for (GameModeCommon common : gm.gameModeCommon) {
			if (common != null) {
				for (Entry<String, Object> object : common.objects.entrySet()) {
					
					// Ajoute les items du commun de type code objet
					if (mode == FLOPPY_DISK || (mode == MEGAROM_T2 && object.getValue().codeInRAM)) {
						Item obj = new Item(object.getValue().gmCode.get(gm).code, 1);
						newItems[i++] = obj;
					}
				}

			}
		}

		return newItems;
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static int computeItemsRamAddress(GameMode gm, Item[] items, RamImage rImg, boolean writeIndex) throws Exception {
		boolean firstLoop = true;
		int nbHalfPages = 0;

		if (items.length > 0) {
			rImg.startAddress[rImg.curPage] = rImg.curAddress;
			rImg.endAddress[rImg.curPage] = rImg.curAddress;
		}
		
		while (items.length > 0) {

			if (!firstLoop) {
				rImg.curPage++;
				if (rImg.isOutOfMemory()) {
					logger.fatal("C'est un peu trop ambitieux ... plus de place en RAM !");
					return 0;
				}
				rImg.startAddress[rImg.curPage] = 0;
				rImg.endAddress[rImg.curPage] = 0;
			}
			
			// les données sont réparties en pages en fonction de leur taille par un
			// algorithme "sac à dos"
			Knapsack knapsack = new Knapsack(items, RamImage.PAGE_SIZE-rImg.startAddress[rImg.curPage]); // Sac à dos de poids max 16Ko
			Solution solution = knapsack.solve();

			// Parcours de la solution
			for (Iterator<Item> iter = solution.items.listIterator(); iter.hasNext();) {

				Item currentItem = iter.next();
				
				if (writeIndex) {
					if (rImg.mode == BuildDisk.FLOPPY_DISK) {
						currentItem.bin.dataIndex.fd_ram_page = rImg.curPage;					
						currentItem.bin.dataIndex.fd_ram_address = rImg.endAddress[rImg.curPage];
					} else {
						currentItem.bin.dataIndex.t2_ram_page = rImg.curPage;					
						currentItem.bin.dataIndex.t2_ram_address = rImg.endAddress[rImg.curPage];
					}
					
					rImg.setDataAtCurPos(currentItem.bin.bin);
					if (rImg.mode == BuildDisk.FLOPPY_DISK) {
						currentItem.bin.dataIndex.fd_ram_endAddress = rImg.endAddress[rImg.curPage];
					} else {
						currentItem.bin.dataIndex.t2_ram_endAddress = rImg.endAddress[rImg.curPage];
					}
				} else {
					rImg.endAddress[rImg.curPage] += currentItem.weight;
					rImg.curAddress = rImg.endAddress[rImg.curPage] + 1;
				}
				
				logger.debug("Item: "+currentItem.name+" FD "+currentItem.bin.dataIndex.fd_ram_page+" "+currentItem.bin.dataIndex.fd_ram_address+" T2 "+currentItem.bin.dataIndex.t2_ram_page+" "+currentItem.bin.dataIndex.t2_ram_address);

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
			
			nbHalfPages += 1;
			if (rImg.startAddress[rImg.curPage] < 0x2000 && rImg.endAddress[rImg.curPage] >= 0x2000) {
				nbHalfPages += 1;
			}
			
			if (writeIndex) {
				logger.debug("\t\tFound solution for page : " + rImg.curPage + " start: " + String.format("$%1$04X", rImg.startAddress[rImg.curPage]) + " end: " + String.format("$%1$04X", rImg.endAddress[rImg.curPage]) + " non allocated space: " + (RamImage.PAGE_SIZE - rImg.endAddress[rImg.curPage]) + " octets");
			} else {
				logger.debug("\t\tFound solution for page : " + rImg.curPage + " start: " + String.format("$%1$04X", rImg.startAddress[rImg.curPage]) + " end: " + String.format("$%1$04X", rImg.endAddress[rImg.curPage]));
			}
			
			firstLoop = false;
		}
		
		return nbHalfPages;
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static void computeRomAddress() throws Exception {
		
		logger.debug("computeRomAddress ...");
		
		int page = 0;
		int address = 256 + Game.loadManagerSizeT2; // TODO boot + RAMLoaderManager
		
		Item[] items = getROMItems();
		computeItemsRomAddress(items, page, address);
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static Item[] getROMItems() {
		logger.debug("\t\tCompute ROM Items for " + MODE_LABEL[MEGAROM_T2] + " ...");

		// Compte le nombre d'objets a traiter
		int nbItems = 0;
		GameMode gm;
		
		// Parcours unique de tous les games modes communs (sans le code objet)
		for (Entry<String, GameModeCommon> common : Game.allGameModeCommons.entrySet()) {
			if (common != null) {
				for (Entry<String, Object> object : common.getValue().objects.entrySet()) {
					// Sprites
					for (SubSpriteBin subSprite : object.getValue().subSpritesBin)
						if (!subSprite.inRAM)
							nbItems += 1;

					// ImageSet Index
					if (object.getValue().subSpritesBin.size() > 0 && !object.getValue().imageSetInRAM)
						nbItems++;

					// Animation Index
					if (!object.getValue().animationsProperties.isEmpty() && !object.getValue().animationInRAM)
						nbItems++;

					// Sounds
					for (Sound sound : object.getValue().sounds)
						for (SoundBin soundBIN : sound.sb)
							if (!soundBIN.inRAM)
								nbItems += 1;
				}
			}
		}

		// Parcours des communs de chaque game mode pour récupérer les codes objets
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			gm = gameMode.getValue();
			for (GameModeCommon common : gm.gameModeCommon) {
				if (common != null) {
					for (Entry<String, Object> object : common.objects.entrySet()) {
						// Object Code
						if (!object.getValue().codeInRAM)
							nbItems++;
					}
				}
			}

			for (Entry<String, Object> object : gm.objects.entrySet()) {

				// Sprites
				for (SubSpriteBin subSprite : object.getValue().subSpritesBin)
					if (!subSprite.inRAM)
						nbItems += 1;

				// ImageSet Index
				if (object.getValue().subSpritesBin.size() > 0 && !object.getValue().imageSetInRAM)
					nbItems++;

				// Animation Index
				if (!object.getValue().animationsProperties.isEmpty() && !object.getValue().animationInRAM)
					nbItems++;

				// Sounds
				for (Sound sound : object.getValue().sounds)
					for (SoundBin soundBIN : sound.sb)
						if (!soundBIN.inRAM)
							nbItems += 1;

				// Object Code
				if (!object.getValue().codeInRAM)
					nbItems++;
			}
		}

		// Initialise un item pour chaque élément a écrire en RAM
		Item[] items = new Item[nbItems];
		int itemIdx = 0;

		// Parcours unique de tous les games modes communs (sans le code objet)
		for (Entry<String, GameModeCommon> common : Game.allGameModeCommons.entrySet()) {
			if (common != null) {
				for (Entry<String, Object> object : common.getValue().objects.entrySet()) {
					// Sprites
					for (SubSpriteBin subSprite : object.getValue().subSpritesBin)
						if (!subSprite.inRAM)
							items[itemIdx++] = new Item(subSprite, 1);

					// ImageSet Index
					if (object.getValue().subSpritesBin.size() > 0 && !object.getValue().imageSetInRAM)
						items[itemIdx++] = new Item(object.getValue().imageSet, 1);

					// Animation Index
					if (!object.getValue().animationsProperties.isEmpty() && !object.getValue().animationInRAM)
						items[itemIdx++] = new Item(object.getValue().animation, 1);

					// Sounds
					for (Sound sound : object.getValue().sounds)
						for (SoundBin soundBIN : sound.sb)
							if (!soundBIN.inRAM)
								items[itemIdx++] = new Item(soundBIN, 1);
				}
			}
		}

		// Parcours des communs de chaque game mode pour récupérer les codes objets
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			gm = gameMode.getValue();
			for (GameModeCommon common : gm.gameModeCommon) {
				if (common != null) {
					for (Entry<String, Object> object : common.objects.entrySet()) {
						// Object Code
						if (!object.getValue().codeInRAM) {
							Item obj = new Item(object.getValue().gmCode.get(gm).code, 1);
							obj.gameMode = gm;
							items[itemIdx++] = obj;	
						}
					}
				}
			}

			for (Entry<String, Object> object : gm.objects.entrySet()) {

				// Sprites
				for (SubSpriteBin subSprite : object.getValue().subSpritesBin)
					if (!subSprite.inRAM)
						items[itemIdx++] = new Item(subSprite, 1);

				// ImageSet Index
				if (object.getValue().subSpritesBin.size() > 0 && !object.getValue().imageSetInRAM)
					items[itemIdx++] = new Item(object.getValue().imageSet, 1);

				// Animation Index
				if (!object.getValue().animationsProperties.isEmpty() && !object.getValue().animationInRAM)
					items[itemIdx++] = new Item(object.getValue().animation, 1);

				// Sounds
				for (Sound sound : object.getValue().sounds)
					for (SoundBin soundBIN : sound.sb)
						if (!soundBIN.inRAM)
							items[itemIdx++] = new Item(soundBIN, 1);

				// Object Code
				if (!object.getValue().codeInRAM) {
					Item obj = new Item(object.getValue().gmCode.get(gm).code, 1);
					obj.gameMode = gm;
					items[itemIdx++] = obj;
				}
			}
		}

		return items;
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private static void computeItemsRomAddress(Item[] items, int pageStart, int pageAddress) throws Exception {
		boolean firstLoop = true;
		game.romT2.curPage = pageStart;
		game.romT2.curAddress = pageAddress;
		
		// les pages rom vont de 0 à 127 mais on y accede par les index 128 à 256
		// pour ne pas interférer avec les pages de RAM 0 à 31

		if (items.length > 0) {
			game.romT2.startAddress[game.romT2.curPage] = game.romT2.curAddress;
			game.romT2.endAddress[game.romT2.curPage] = game.romT2.curAddress;
		}
		
		while (items.length > 0) {

			if (!firstLoop) {
				game.romT2.curPage++;
				if (game.romT2.isOutOfMemory())
					throw new Exception("C'est un peu trop ambitieux ... 2Mo pour la T.2 et pas un octet de plus !");
				
				game.romT2.startAddress[game.romT2.curPage] = 0;
				game.romT2.endAddress[game.romT2.curPage] = 0;
			}
			
			// les données sont réparties en pages en fonction de leur taille par un algorithme "sac à dos"
			Knapsack knapsack = new Knapsack(items, RamImage.PAGE_SIZE-game.romT2.startAddress[game.romT2.curPage]); // Sac à dos de poids max 16Ko
			Solution solution = knapsack.solve();

			// Parcours de la solution
			for (Iterator<Item> iter = solution.items.listIterator(); iter.hasNext();) {

				Item currentItem = iter.next();
				
				currentItem.bin.dataIndex.t2_page = game.romT2.curPage;					
				currentItem.bin.dataIndex.t2_address = game.romT2.endAddress[game.romT2.curPage];
				game.romT2.setDataAtCurPos(currentItem.bin.bin);
				currentItem.bin.dataIndex.t2_endAddress = game.romT2.endAddress[game.romT2.curPage];
				
				logger.debug("Item: "+currentItem.name+" T2 ROM "+currentItem.bin.dataIndex.t2_page+" "+currentItem.bin.dataIndex.t2_address);

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
			
			logger.debug("\t\tFound solution for page : " + game.romT2.curPage + " start: " + String.format("$%1$04X", game.romT2.startAddress[game.romT2.curPage]) + " end: " + String.format("$%1$04X", game.romT2.endAddress[game.romT2.curPage]) + " non allocated space: " + (RamImage.PAGE_SIZE - game.romT2.endAddress[game.romT2.curPage]) + " octets");
			
			firstLoop = false;
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static void generateImgAniIndex() throws Exception {
		logger.info("Generate Image index and Animation script index ...");
		
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			logger.debug("\nGame Mode : " + gameMode.getKey());
			GameMode gm = gameMode.getValue();
			
			// Objets Communs au Game Mode
			for (GameModeCommon common : gm.gameModeCommon) {
				if (common != null) {
					for (Entry<String, Object> object : common.objects.entrySet()) {
						generateImgAniIndex(gameMode.getValue(), object.getValue());
					}
				}
			}
			
			// Objets du Game Mode
			for (Entry<String, Object> object : gm.objects.entrySet()) {
				generateImgAniIndex(gameMode.getValue(), object.getValue());
			}
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
	private static void generateImgAniIndex(GameMode gm, Object obj) throws Exception {
		AsmSourceCode asmImgIndexFd;
		AsmSourceCode asmImgIndexT2;		
		
		String imgSetDirFd = gm.name + "/"+MODE_DIR[FLOPPY_DISK]+"/" + obj.name;
		String imgSetDirT2 = gm.name + "/"+MODE_DIR[MEGAROM_T2]+"/" + obj.name;
		String aniDir = obj.name;
		
		RamImage imgSetData, aniData, codeData;
		int objCodePage, objCodeAddress;
		int imgSetPage, imgSetAddress;
		int aniPage, aniAddress;
		
		// Génération de l'index ImageSet pour FD	
		asmImgIndexFd = new AsmSourceCode(createFile(obj.imageSet.fileName, imgSetDirFd));
		for (Entry<String, Sprite> sprite : obj.sprites.entrySet()) {
			writeImgIndex(asmImgIndexFd, sprite.getValue(), FLOPPY_DISK);
		}
		
		// Génération de l'index Animation pour FD et T2				
		AsmSourceCode asmAniIndex = new AsmSourceCode(createFile(obj.animation.fileName, aniDir));
		writeAniIndex(asmAniIndex, obj);
		
		codeData = gm.ramFD;
		imgSetData = gm.ramFD;
		aniData = gm.ramFD;
		objCodePage = obj.gmCode.get(gm).code.dataIndex.fd_ram_page;
		objCodeAddress = obj.gmCode.get(gm).code.dataIndex.fd_ram_address;
		imgSetPage = obj.imageSet.dataIndex.fd_ram_page;
		imgSetAddress = obj.imageSet.dataIndex.fd_ram_address;
		aniPage = obj.animation.dataIndex.fd_ram_page;
		aniAddress = obj.animation.dataIndex.fd_ram_address;		
		
		// Compilation de ImageSet, Animation, Object pour FD
		compileObjectWithImageRef(gm, obj, imgSetDirFd, aniDir, codeData, imgSetData, aniData, objCodePage, objCodeAddress, imgSetPage, imgSetAddress, aniPage, aniAddress, FLOPPY_DISK);

		// Génération de l'index ImageSet pour T2
		asmImgIndexT2 = new AsmSourceCode(createFile(obj.imageSet.fileName, imgSetDirT2));
		for (Entry<String, Sprite> sprite : obj.sprites.entrySet()) {
			writeImgIndex(asmImgIndexT2, sprite.getValue(), MEGAROM_T2);
		}
		
		codeData = gm.ramT2;
		objCodePage = obj.gmCode.get(gm).code.dataIndex.t2_ram_page;
		objCodeAddress = obj.gmCode.get(gm).code.dataIndex.t2_ram_address;
		
		if (obj.imageSetInRAM) {
			imgSetData = gm.ramT2;
			imgSetPage = obj.imageSet.dataIndex.t2_ram_page;
			imgSetAddress = obj.imageSet.dataIndex.t2_ram_address;			
		} else {
			imgSetData = game.romT2;
			imgSetPage = obj.imageSet.dataIndex.t2_page;
			imgSetAddress = obj.imageSet.dataIndex.t2_address;			
		}
		
		if (obj.animationInRAM) {
			aniData = gm.ramT2;
			aniPage = obj.animation.dataIndex.t2_ram_page;
			aniAddress = obj.animation.dataIndex.t2_ram_address;				
		} else {
			aniData = game.romT2;
			aniPage = obj.animation.dataIndex.t2_page;
			aniAddress = obj.animation.dataIndex.t2_address;				
		}		

		compileObjectWithImageRef(gm, obj, imgSetDirT2, aniDir, codeData, imgSetData, aniData, objCodePage, objCodeAddress, imgSetPage, imgSetAddress, aniPage, aniAddress, MEGAROM_T2);
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
	private static void compileObjectWithImageRef(GameMode gm, Object obj, String imgSetDir, String aniDir, RamImage codeData, RamImage imgSetData, RamImage aniData,
			                                      int objCodePage, int objCodeAddress, int imgSetPage, int imgSetAddress, int aniPage, int aniAddress, int mode) throws Exception {
		logger.info("\t\t"+obj.name+" at "+String.format("$%1$04X|$%2$02X", objCodeAddress, objCodePage)+" imageSet at "+String.format("$%1$04X|$%2$02X", imgSetAddress, imgSetPage)+" animation at "+String.format("$%1$04X|$%2$02X", aniAddress, aniPage));

		String prepend = "\tINCLUDE \"" + Game.generatedCodeDirName + gm.name+ "/" + MODE_DIR[mode] + "/" + FileNames.MAIN_GENCODEGLB+"\"\n";
		prepend += "\tINCLUDE \"" + Game.generatedCodeDirName + gm.name + "/" + FileNames.OBJECTID+"\"\n";
		prepend += "\topt   c,ct\n";		
		
		if (obj.imageSet.uncompressedSize > 0) {
			prepend += "\torg   $" + String.format("%1$04X", imgSetAddress) + "\n";
			prepend += "\tINCLUDE \"" + Game.generatedCodeDirName + imgSetDir + "/" + obj.imageSet.fileName + "\"\n";
		}
		
		if (obj.animation.uncompressedSize > 0) {
			prepend += "\torg   $" + String.format("%1$04X", aniAddress) + "\n";
			prepend += "\tINCLUDE \"" + Game.generatedCodeDirName + aniDir + "/" + obj.animation.fileName + "\"\n";
		}
		
		prepend += "\torg   $" + String.format("%1$04X", objCodeAddress) + "\n";
		
		// Compilation du code Objet
		String objectCodeTmpFile = duplicateFilePrepend(obj.codeFileName, imgSetDir, prepend);
		compileRAW(objectCodeTmpFile);
		byte[] allBytes = Files.readAllBytes(Paths.get(getBINFileName(objectCodeTmpFile)));
		int start = 0;
		
		// Mise à jour des données du code objet 
		if (obj.imageSet.uncompressedSize > 0) {
			obj.imageSet.bin = Arrays.copyOfRange(allBytes, start, start+obj.imageSet.uncompressedSize-1);
			imgSetData.setData(imgSetPage, imgSetAddress, obj.imageSet.bin);			
			start = obj.imageSet.uncompressedSize;
		}
		
		if  (obj.animation.uncompressedSize > 0) {
			obj.animation.bin = Arrays.copyOfRange(allBytes, start, start+obj.animation.uncompressedSize-1);
			aniData.setData(aniPage, aniAddress, obj.animation.bin);		
			start = obj.animation.uncompressedSize;
		}
		
		obj.gmCode.get(gm).code.bin = Arrays.copyOfRange(allBytes, start, start+obj.gmCode.get(gm).code.uncompressedSize-1);
		codeData.setData(objCodePage, objCodeAddress, obj.gmCode.get(gm).code.bin);		
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

				// Ecriture sur disquette des images de sprite
				// ------------------------------------------------------------
				for (Entry<String, Sprite> sprite : object.getValue().sprites.entrySet()) {
					sprite.getValue().setAllFileIndex(fd);
				}
				
				// Ecriture sur disquette des données audio
				// ---------------------------------------------------------
				for (Sound sound : object.getValue().sounds) {
					sound.setAllFileIndex(fd);
				}				

				// Ecriture sur disquette du code des objets
				// ----------------------------------------------------------
				object.getValue().gmCode.get(gameMode.getValue()).code.setFileIndex(fd);

				// Ecriture sur disquette des Main Engines
				// --------------------------------------------------------
				gameMode.getValue().code.setFileIndex(fd);
			}
		}
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static int getRAMLoaderManagerSize() throws Exception {
		logger.info("get RAM Loader Manager size ...");

		AsmSourceCode dataIndex = new AsmSourceCode(createFile(FileNames.FILE_INDEX));
		dataIndex.flush();

		// Compilation du Game Mode Manager
		// -------------------------------------------------		

		String gameModeManagerTmpFile = duplicateFile(game.engineAsmRAMLoaderManager);
		compileRAW(gameModeManagerTmpFile);
		game.engineRAMLoaderManagerBytes = Files.readAllBytes(Paths.get(getBINFileName(gameModeManagerTmpFile)));

		if (game.engineRAMLoaderManagerBytes.length > RamImage.PAGE_SIZE) {
			throw new Exception("Le fichier "+game.engineAsmRAMLoaderManager+" est trop volumineux:"+game.engineRAMLoaderManagerBytes.length+" octets (max:"+RamImage.PAGE_SIZE+")");
		}	
		
		return game.engineRAMLoaderManagerBytes.length;
	}	
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

	private static void compileAndWriteRAMLoaderManager() throws Exception {
		compileAndWriteRAMLoaderManager(FLOPPY_DISK);
		compileAndWriteRAMLoaderManager(MEGAROM_T2);
	}	
	
	private static int compileAndWriteRAMLoaderManager(int mode) throws Exception {
		logger.info("Compile and Write RAM Loader Manager for " + mode + " ...");
		int pad = 5; // T.2
		int indexSize = 0;
		
		if (mode == FLOPPY_DISK) {
			pad = 6;
		}

		// Construction des données de chargement disquette pour chaque Game Mode
		// ---------------------------------------------------------------------------------------
		AsmSourceCode dataIndex = new AsmSourceCode(createFile(FileNames.FILE_INDEX));
		dataIndex.addCommentLine("structure: sector, nb sector, drive (bit 7) track (bit 6-0), end offset, ram dest page, ram dest end addr. hb, ram dest end addr. lb");
		
		for (Entry<String, GameMode> gameMode : game.gameModes.entrySet()) {
			
			if (mode == FLOPPY_DISK) {
				indexSize = gameMode.getValue().indexSizeFD;
			} else {
				indexSize = gameMode.getValue().indexSizeT2;
			}
			
			dataIndex.addLabel("gm_" + gameMode.getKey());
			dataIndex.addFdb(new String[] { "RL_RAM_index+"+(indexSize-2+pad+1)}); // -2 index, +6 ou +5 balise FF (lecture par groupe de 7 ou 6 octets), +1 balise FF ajoutée par le GameModeManager au runtime	
			
			// Ajout du tag pour identifier le game mode de démarrage
			if (gameMode.getKey().contentEquals(game.gameModeBoot)) {
				dataIndex.addLabel("gmboot");
			}

			// Ecriture de l'index des de chargement des demi-pages
			if (mode == FLOPPY_DISK) {
				Enumeration<DataIndex> enumFd = Collections.enumeration(gameMode.getValue().fdIdx);
				while(enumFd.hasMoreElements()) {
					DataIndex di = enumFd.nextElement();
						dataIndex.addFcb(new String[] {
						String.format("$%1$02X", di.fd_sector),
						String.format("$%1$02X", di.fd_nbSector-1),
						String.format("$%1$02X", (di.fd_drive << 7)+di.fd_track),				
						String.format("$%1$02X", -di.fd_endOffset & 0xFF),
						String.format("$%1$02X", di.fd_ram_page),	
						String.format("$%1$02X", di.fd_ram_endAddress >> 8),			
						String.format("$%1$02X", di.fd_ram_endAddress & 0x00FF)});			
				}
			}
			
			if (mode == MEGAROM_T2) {
				Enumeration<DataIndex> enumT2 = Collections.enumeration(gameMode.getValue().t2Idx);
				while(enumT2.hasMoreElements()) {
					DataIndex di = enumT2.nextElement();
					dataIndex.addFcb(new String[] {
						String.format("$%1$02X", di.t2_page),
						String.format("$%1$02X", di.t2_endAddress >> 8),			
						String.format("$%1$02X", di.t2_endAddress & 0x00FF),								
						String.format("$%1$02X", di.t2_ram_page),	
						String.format("$%1$02X", di.t2_ram_endAddress >> 8),			
						String.format("$%1$02X", di.t2_ram_endAddress & 0x00FF)});			
			     }
			}			
		}
		
		dataIndex.addFcb(new String[] { "$FF" });		
		dataIndex.flush();

		// Compilation du Game Mode Manager
		// -------------------------------------------------		

		String gameModeManagerTmpFile = duplicateFile(game.engineAsmRAMLoaderManager);
		compileRAW(gameModeManagerTmpFile);
		game.engineRAMLoaderManagerBytes = Files.readAllBytes(Paths.get(getBINFileName(gameModeManagerTmpFile)));

		if (game.engineRAMLoaderManagerBytes.length > RamImage.PAGE_SIZE) {
			throw new Exception("Le fichier "+game.engineAsmRAMLoaderManager+" est trop volumineux:"+game.engineRAMLoaderManagerBytes.length+" octets (max:"+RamImage.PAGE_SIZE+")");
		}	
		
		return game.engineRAMLoaderManagerBytes.length;
	}
	
	private static void compileAndWriteBoot() throws IOException {
		logger.info("Compile boot ...");
		
		String bootTmpFile = duplicateFile(game.engineAsmBoot);
		game.glb.addConstant("boot_dernier_bloc", String.format("$%1$02X", (0xA000 + game.engineRAMLoaderManagerBytes.length) >> 8)+"00"); // On tronque l'octet de poids faible
		game.glb.flush();
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
	
	private static int writeImgIndex(AsmSourceCode asm, Sprite sprite, int mode) {
		
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
				getImgSubSpriteIndex(sprite.subSprites.get("NB0"), line, mode);
			}

			if (sprite.subSprites.containsKey("ND0")) {
				getImgSubSpriteIndex(sprite.subSprites.get("ND0"), line, mode);
			}

			if (sprite.subSprites.containsKey("NB1")) {
				getImgSubSpriteIndex(sprite.subSprites.get("NB1"), line, mode);
			}

			if (sprite.subSprites.containsKey("ND1")) {
				getImgSubSpriteIndex(sprite.subSprites.get("ND1"), line, mode);
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
				getImgSubSpriteIndex(sprite.subSprites.get("XB0"), line, mode);
			}

			if (sprite.subSprites.containsKey("XD0")) {
				getImgSubSpriteIndex(sprite.subSprites.get("XD0"), line, mode);
			}

			if (sprite.subSprites.containsKey("XB1")) {
				getImgSubSpriteIndex(sprite.subSprites.get("XB1"), line, mode);
			}

			if (sprite.subSprites.containsKey("XD1")) {
				getImgSubSpriteIndex(sprite.subSprites.get("XD1"), line, mode);
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
				getImgSubSpriteIndex(sprite.subSprites.get("YB0"), line, mode);
			}

			if (sprite.subSprites.containsKey("YD0")) {
				getImgSubSpriteIndex(sprite.subSprites.get("YD0"), line, mode);
			}

			if (sprite.subSprites.containsKey("YB1")) {
				getImgSubSpriteIndex(sprite.subSprites.get("YB1"), line, mode);
			}

			if (sprite.subSprites.containsKey("YD1")) {
				getImgSubSpriteIndex(sprite.subSprites.get("YD1"), line, mode);
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
				getImgSubSpriteIndex(sprite.subSprites.get("XYB0"), line, mode);
			}

			if (sprite.subSprites.containsKey("XYD0")) {
				getImgSubSpriteIndex(sprite.subSprites.get("XYD0"), line, mode);
			}

			if (sprite.subSprites.containsKey("XYB1")) {
				getImgSubSpriteIndex(sprite.subSprites.get("XYB1"), line, mode);
			}

			if (sprite.subSprites.containsKey("XYD1")) {
				getImgSubSpriteIndex(sprite.subSprites.get("XYD1"), line, mode);
			}
		}		
		
		String[] result = line.toArray(new String[0]);
		if (asm != null) {
			asm.addFcb(result);
			asm.flush();
		}
		return line.size();
	}
	
	private static void getImgSubSpriteIndex(SubSprite s, List<String> line, int mode) {
		
		if (mode == FLOPPY_DISK) {
			line.add(String.format("$%1$02X", s.draw.dataIndex.fd_ram_page));
			line.add(String.format("$%1$02X", s.draw.dataIndex.fd_ram_address >> 8));		
			line.add(String.format("$%1$02X", s.draw.dataIndex.fd_ram_address & 0xFF));
		
			if (s.erase != null) {
				line.add(String.format("$%1$02X", s.erase.dataIndex.fd_ram_page));
				line.add(String.format("$%1$02X", s.erase.dataIndex.fd_ram_address >> 8));		
				line.add(String.format("$%1$02X", s.erase.dataIndex.fd_ram_address & 0xFF));
				line.add(String.format("$%1$02X", s.nb_cell)); // unsigned value
			}
		} else if (mode == MEGAROM_T2 && s.parent.inRAM) {
			line.add(String.format("$%1$02X", s.draw.dataIndex.t2_ram_page));
			line.add(String.format("$%1$02X", s.draw.dataIndex.t2_ram_address >> 8));		
			line.add(String.format("$%1$02X", s.draw.dataIndex.t2_ram_address & 0xFF));
		
			if (s.erase != null) {
				line.add(String.format("$%1$02X", s.erase.dataIndex.t2_ram_page));
				line.add(String.format("$%1$02X", s.erase.dataIndex.t2_ram_address >> 8));		
				line.add(String.format("$%1$02X", s.erase.dataIndex.t2_ram_address & 0xFF));
				line.add(String.format("$%1$02X", s.nb_cell)); // unsigned value
			}
		} else if (mode == MEGAROM_T2 && !s.parent.inRAM) {
			line.add(String.format("$%1$02X", s.draw.dataIndex.t2_page));
			line.add(String.format("$%1$02X", s.draw.dataIndex.t2_address >> 8));		
			line.add(String.format("$%1$02X", s.draw.dataIndex.t2_address & 0xFF));
		
			if (s.erase != null) {
				line.add(String.format("$%1$02X", s.erase.dataIndex.t2_page));
				line.add(String.format("$%1$02X", s.erase.dataIndex.t2_address >> 8));		
				line.add(String.format("$%1$02X", s.erase.dataIndex.t2_address & 0xFF));
				line.add(String.format("$%1$02X", s.nb_cell)); // unsigned value
			}
		}
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static void writeObjIndex(AsmSourceCode asmBuilder, GameMode gm, int mode) {	
		String[][] objIndexPage = new String[gm.objectsId.entrySet().size() + 1][];
		String[][] objIndex = new String[gm.objectsId.entrySet().size() + 1][];
		
		// Game Mode Common
		for (GameModeCommon common : gm.gameModeCommon) {
			if (common != null) {
				for (Entry<String, Object> obj : common.objects.entrySet()) {
					writeObjIndex(objIndexPage, objIndex, gm, obj.getValue(), mode);				
				}
			}
		}
		
		// Objets du Game Mode
		for (Entry<String, Object> obj : gm.objects.entrySet()) {
			writeObjIndex(objIndexPage, objIndex, gm, obj.getValue(), mode);		
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

	private static void writeObjIndex(String[][] objIndexPage, String[][] objIndex, GameMode gm, Object obj, int mode) {	
		if (mode == FLOPPY_DISK) {
			objIndexPage[gm.objectsId.get(obj)] = new String[] {String.format("$%1$02X", obj.gmCode.get(gm).code.dataIndex.fd_ram_page) };
			objIndex[gm.objectsId.get(obj)] = new String[] {String.format("$%1$02X", obj.gmCode.get(gm).code.dataIndex.fd_ram_address >> 8), String.format("$%1$02X", obj.gmCode.get(gm).code.dataIndex.fd_ram_address & 0x00FF) };
		} else if (mode == MEGAROM_T2) {
			if (obj.codeInRAM) {
				objIndexPage[gm.objectsId.get(obj)] = new String[] {String.format("$%1$02X", obj.gmCode.get(gm).code.dataIndex.t2_ram_page) };
				objIndex[gm.objectsId.get(obj)] = new String[] {String.format("$%1$02X", obj.gmCode.get(gm).code.dataIndex.t2_ram_address >> 8), String.format("$%1$02X", obj.gmCode.get(gm).code.dataIndex.t2_ram_address & 0x00FF) };					
			} else {
				objIndexPage[gm.objectsId.get(obj)] = new String[] {String.format("$%1$02X", obj.gmCode.get(gm).code.dataIndex.t2_page) };
				objIndex[gm.objectsId.get(obj)] = new String[] {String.format("$%1$02X", obj.gmCode.get(gm).code.dataIndex.t2_address >> 8), String.format("$%1$02X", obj.gmCode.get(gm).code.dataIndex.t2_address & 0x00FF) };
			}			
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
			line[0] = String.format("$%1$02X", sb.dataIndex.fd_ram_page);
			line[1] = String.format("$%1$02X", sb.dataIndex.fd_ram_address >> 8);
			line[2] = String.format("$%1$02X", sb.dataIndex.fd_ram_address & 0x00FF);
			line[3] = String.format("$%1$02X", sb.dataIndex.fd_ram_endAddress >> 8);
			line[4] = String.format("$%1$02X", sb.dataIndex.fd_ram_endAddress & 0x00FF);
			asmSndIndex.addFcb(line);
		}
		asmSndIndex.addFcb(new String[] { "$00" });
	}	
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static void writeImgPgIndex(AsmSourceCode asmBuilder, GameMode gameMode, int mode) throws Exception {
		asmBuilder.addLabel("Img_Page_Index");		
		// Game Mode Common
		for (GameModeCommon common : gameMode.gameModeCommon) {
			if (common != null) {
				for (Entry<String, Object> object : common.objects.entrySet()) {
					writeImgPgIndex(asmBuilder, object.getValue().imageSet, object.getValue().imageSetInRAM, mode);
				}
			}
		}
		
		// Objets du Game Mode
		for (Entry<String, Object> object : gameMode.objects.entrySet()) {
			writeImgPgIndex(asmBuilder, object.getValue().imageSet, object.getValue().imageSetInRAM, mode);
		}
	}	
	
	private static void writeImgPgIndex(AsmSourceCode asmBuilder, ImageSetBin ibin, boolean objInRAM, int mode) throws Exception {
		if (ibin != null && ibin.dataIndex != null) {
			if (mode == FLOPPY_DISK) {
				asmBuilder.addFcb(new String[] { String.format("$%1$02X", ibin.dataIndex.fd_ram_page) });
			} else if (mode == MEGAROM_T2) {
				if (objInRAM) {
					asmBuilder.addFcb(new String[] { String.format("$%1$02X", ibin.dataIndex.t2_ram_page) });
				} else {
					asmBuilder.addFcb(new String[] { String.format("$%1$02X", ibin.dataIndex.t2_page) });
				}			
			}
		} else {
			asmBuilder.addFcb(new String[] {"$00"});			
		}
	}	
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static void writeAniPgIndex(AsmSourceCode asmBuilder, GameMode gameMode, int mode) throws Exception {
		asmBuilder.addLabel("Ani_Page_Index");		
		// Game Mode Common
		for (GameModeCommon common : gameMode.gameModeCommon) {
			if (common != null) {
				for (Entry<String, Object> object : common.objects.entrySet()) {
					writeAniPgIndex(asmBuilder, object.getValue().animation, object.getValue().animationInRAM, mode);
				}
			}
		}
		
		// Objets du Game Mode
		for (Entry<String, Object> object : gameMode.objects.entrySet()) {
			writeAniPgIndex(asmBuilder, object.getValue().animation, object.getValue().animationInRAM, mode);
		}
	}	
	
	private static void writeAniPgIndex(AsmSourceCode asmBuilder, AnimationBin abin, boolean objInRAM, int mode) throws Exception {
		if (abin != null && abin.dataIndex != null) {
			if (mode == FLOPPY_DISK) {
				asmBuilder.addFcb(new String[] { String.format("$%1$02X", abin.dataIndex.fd_ram_page) });
			} else if (mode == MEGAROM_T2) {
				if (objInRAM) {
					asmBuilder.addFcb(new String[] { String.format("$%1$02X", abin.dataIndex.t2_ram_page) });
				} else {
					asmBuilder.addFcb(new String[] { String.format("$%1$02X", abin.dataIndex.t2_page) });
				}			
			}
		} else {
			asmBuilder.addFcb(new String[] {"$00"});			
		}

	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	private static void exomizeData() throws Exception {
		logger.info("Exomize data ...");
		
		for(Entry<String, GameMode> gm : game.gameModes.entrySet()) {
			exomizeData(FLOPPY_DISK, gm.getValue().ramFD, gm.getValue().fdIdx);
			exomizeData(MEGAROM_T2, gm.getValue().ramT2, gm.getValue().t2Idx);
		}
	}
	
	private static void exomizeData(int mode, RamImage ram, List<DataIndex> ldi) throws Exception {
		logger.info("Exomize data for " + MODE_LABEL[mode] + "...");
		
		String tmpFile = Game.generatedCodeDirName+FileNames.TEMPORARY_FILE;
		
		Enumeration<DataIndex> edi = Collections.enumeration(ldi);
		while(edi.hasMoreElements()) {
			
			DataIndex di = edi.nextElement();
			byte[] fileData = new byte[di.fd_ram_endAddress-di.fd_ram_address];
			int j = 0;
			
			for (int i = di.fd_ram_address; i < di.fd_ram_endAddress; i++) {
				fileData[j++] = ram.data[di.fd_ram_page][i];
			}
			
			Files.write(Paths.get(tmpFile), fileData);
			BinUtil.RawToLinear(tmpFile, di.fd_ram_address);

			di.exoBin = exomize(getBINFileName(tmpFile));
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

			ProcessBuilder pb = new ProcessBuilder(game.exobin, Paths.get(binFile).toString());
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
			Process p = new ProcessBuilder(game.lwasm, path.toString(), "--output=" + binFile, "--list=" + lstFile, "--6809", "--pragma=undefextern,autobranchlength", "--symbol-dump=" + glbFile, option).start();
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
			Process p = new ProcessBuilder(game.lwasm, path.toString(), "--output=" + binFile, "--list=" + lstFile, "--6809", "--pragma=undefextern,autobranchlength,undefextern", "--obj").start();
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


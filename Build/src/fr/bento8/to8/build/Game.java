package fr.bento8.to8.build;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import fr.bento8.to8.disk.FdUtil;

public class Game {
	
	public String name;
	
	// Engine Loader
	public String engineAsmBoot;
	public String engineAsmRAMLoaderManager;
	public String engineAsmRAMLoader;
	
	// Game Mode
	public String gameModeBoot;
	public HashMap<String, GameMode> gameModes = new HashMap<String, GameMode>();

	// Build
	public static String lwasm;
	public static String exobin;
	public boolean debug;
	public boolean logToConsole;	
	public String outputDiskName;
	public static String generatedCodeDirName;
	public boolean memoryExtension;
	public static int nbMaxPagesRAM;	
	public static boolean useCache;
	public static int maxTries;

	public FdUtil fd = new FdUtil();
	public static AsmSourceCode glb;
	
	public byte[] engineRAMLoaderManagerBytes;	
	public byte[] engineAsmRAMLoaderBytes;	
	public byte[] mainEXOBytes;
	public byte[] bootLoaderBytes;
	
	public Game(String file) throws Exception {	
			Properties prop = new Properties();
			this.name = "Game";
			
			try {
				InputStream input = new FileInputStream(file);
				prop.load(input);
			} catch (Exception e) {
				throw new Exception("\tUnable to load: "+file, e); 
			}
			
			glb = new AsmSourceCode(BuildDisk.createFile(FileNames.GLOBALS, ""));
			
			if (prop.getProperty("builder.to8.memoryExtension") == null) {
				throw new Exception("builder.to8.memoryExtension not found in "+file);
			}
			memoryExtension = (prop.getProperty("builder.to8.memoryExtension").contentEquals("Y")?true:false);
			if (memoryExtension) {
				nbMaxPagesRAM = 31;
			} else {
				nbMaxPagesRAM = 15;
			}

			// Engine ASM source code
			// ********************************************************************

			engineAsmBoot = prop.getProperty("engine.asm.boot");
			if (engineAsmBoot == null) {
				throw new Exception("engine.asm.boot not found in "+file);
			}

			engineAsmRAMLoaderManager = prop.getProperty("engine.asm.RAMLoaderManager");
			if (engineAsmRAMLoaderManager == null) {
				throw new Exception("engine.asm.RAMLoaderManager not found in "+file);
			}
			
			engineAsmRAMLoader = prop.getProperty("engine.asm.RAMLoader");
			if (engineAsmRAMLoader == null) {
				throw new Exception("engine.asm.RAMLoader not found in "+file);
			}
			
			generatedCodeDirName = prop.getProperty("builder.generatedCode") + "/";
			if (generatedCodeDirName == null) {
				throw new Exception("builder.generatedCode not found in "+file);
			}

			// Game Definition
			// ********************************************************************		

			gameModeBoot = prop.getProperty("gameModeBoot");
			if (gameModeBoot == null) {
				throw new Exception("gameModeBoot not found in "+file);
			}

			HashMap<String, String[]> gameModeProperties = PropertyList.get(prop, "gameMode");
			if (gameModeProperties == null) {
				throw new Exception("gameMode not found in "+file);
			}
			
			// Chargement des fichiers de configuration des Game Modes
			for (Map.Entry<String,String[]> curGameMode : gameModeProperties.entrySet()) {
				BuildDisk.logger.debug("\tLoad Game Mode "+curGameMode.getKey()+": "+curGameMode.getValue()[0]);
				gameModes.put(curGameMode.getKey(), new GameMode(curGameMode.getKey(), curGameMode.getValue()[0]));
			}	

			// Build parameters
			// ********************************************************************				

			lwasm = prop.getProperty("builder.lwasm");
			if (lwasm == null) {
				throw new Exception("builder.lwasm not found in "+file);
			}

			exobin = prop.getProperty("builder.exobin");
			if (exobin == null) {
				throw new Exception("builder.exobin not found in "+file);
			}

			if (prop.getProperty("builder.debug") == null) {
				throw new Exception("builder.debug not found in "+file);
			}
			debug = (prop.getProperty("builder.debug").contentEquals("Y")?true:false);

			if (prop.getProperty("builder.logToConsole") == null) {
				throw new Exception("builder.logToConsole not found in "+file);
			}
			logToConsole = (prop.getProperty("builder.logToConsole").contentEquals("Y")?true:false);

			outputDiskName = prop.getProperty("builder.diskName");
			if (outputDiskName == null) {
				throw new Exception("builder.diskName not found in "+file);
			}

			if (prop.getProperty("builder.compilatedSprite.useCache") == null) {
				throw new Exception("builder.compilatedSprite.useCache not found in "+file);
			}
			useCache = (prop.getProperty("builder.compilatedSprite.useCache").contentEquals("Y")?true:false);

			if (prop.getProperty("builder.compilatedSprite.maxTries") == null) {
				throw new Exception("builder.compilatedSprite.maxTries not found in "+file);
			}
			maxTries = Integer.parseInt(prop.getProperty("builder.compilatedSprite.maxTries"));
		}	
}
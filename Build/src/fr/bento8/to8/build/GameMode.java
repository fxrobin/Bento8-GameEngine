package fr.bento8.to8.build;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

public class GameMode {

	public String name;
	public String fileName;
	public int dataSize;
	public ObjectBin code; // Main Engine
	
	public String engineAsmMainEngine;
	public GameModeCommon gameModeCommon;
	public HashMap<String, Object> objects = new HashMap<String, Object>();
	public HashMap<Object, Integer> objectsId = new HashMap<Object, Integer>();
	public HashMap<String, Palette> palettes = new HashMap<String, Palette>();
	public HashMap<String, Act> acts = new HashMap<String, Act>(); 
	public String actBoot;
	public AsmSourceCode glb;
	public GameModeCommon common;
	public int nbPages = 0;	
	
	public GameMode(String gameModeName, String fileName) throws Exception {
		
		this.name = gameModeName;
		this.fileName = fileName;
		
		glb = new AsmSourceCode(BuildDisk.createFile(FileNames.GLOBALS, name));
		
		Properties prop = new Properties();
		try {
			InputStream input = new FileInputStream(fileName);
			prop.load(input);
		} catch (Exception e) {
			throw new Exception("Impossible de charger le fichier de configuration: " + fileName, e);
		}

		// Main Engine
		// ********************************************************************

		engineAsmMainEngine = prop.getProperty("engine.asm.mainEngine");
		if (engineAsmMainEngine == null) {
			throw new Exception("engine.asm.mainEngine not found in " + fileName);
		}

		// Game Mode Common
		// ********************************************************************

		HashMap<String, String[]> gameModeCommonProperties = PropertyList.get(prop, "gameModeCommon");
		
		if (gameModeCommonProperties != null && gameModeCommonProperties.size() >= 1) {
			
			if (gameModeCommonProperties.size()>1)
				throw new Exception("Only one GameModeCommon supported for each Game Mode.");
			
			// Chargement du fichier de configuration du Game Mode Common
			for (Map.Entry<String,String[]> curGameModeCommon : gameModeCommonProperties.entrySet()) {
				BuildDisk.logger.debug("\tLoad Game Mode Common"+curGameModeCommon.getKey()+": "+curGameModeCommon.getValue()[0]);
				if (!BuildDisk.allGameModeCommons.containsKey(curGameModeCommon.getKey())) {
					gameModeCommon = new GameModeCommon(curGameModeCommon.getKey(), curGameModeCommon.getValue()[0]);
					BuildDisk.allGameModeCommons.put(curGameModeCommon.getKey(), gameModeCommon);
				} else {
					gameModeCommon = BuildDisk.allGameModeCommons.get(curGameModeCommon.getKey());
				}
			}
		}
		
		// Objects
		// ********************************************************************
		
		HashMap<String, String[]> objectProperties = PropertyList.get(prop, "object");
		
		if (objectProperties == null)
			throw new Exception("object not found in " + fileName);
		
		// Chargement des fichiers de configuration des Objets
		for (Map.Entry<String,String[]> curObject : objectProperties.entrySet()) {
			BuildDisk.logger.debug("\tLoad Object "+curObject.getKey()+": "+curObject.getValue()[0]);
			objects.put(curObject.getKey(), new Object(name, curObject.getKey(), curObject.getValue()[0]));
		}	
		
		// Palettes
		// ********************************************************************
		
		HashMap<String, String[]> paletteProperties = PropertyList.get(prop, "palette");
		if (paletteProperties == null)
			throw new Exception("palette not found in " + fileName);
		
		// Chargement des fichiers de configuration des Palettes
		for (Map.Entry<String,String[]> curPalette : paletteProperties.entrySet()) {
			BuildDisk.logger.debug("\tLoad Palette "+curPalette.getKey()+": "+curPalette.getValue()[0]);
			palettes.put(curPalette.getKey(), new Palette(name, curPalette.getKey(), curPalette.getValue()[0]));
		}			

		// Act Sequence
		// ********************************************************************

		actBoot = prop.getProperty("actBoot");

		// Act Definition
		// ********************************************************************

		HashMap<String, String[]> actProperties = PropertyList.get(prop, "act");
		
		for (Map.Entry<String, String[]> curActProperty : actProperties.entrySet()) {
			if (!acts.containsKey(curActProperty.getKey().split("\\.",2)[0])) {
				acts.put(curActProperty.getKey().split("\\.",2)[0], new Act(curActProperty.getKey().split("\\.",2)[0]));
			}
			acts.get(curActProperty.getKey().split("\\.",2)[0]).setProperty(curActProperty.getKey().split("\\.",2)[1], curActProperty.getValue());
		}
	}
}
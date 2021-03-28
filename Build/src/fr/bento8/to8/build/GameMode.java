package fr.bento8.to8.build;

import java.io.FileInputStream;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import fr.bento8.to8.disk.DataIndex;

public class GameMode {

	public String name;
	public String fileName;
	public int dataSize;
	public DataIndex fileIndex = new DataIndex();
	public ObjectBin code; // Main Engine
	
	public String engineAsmMainEngine;
	public HashMap<String, Object> objects = new HashMap<String, Object>();
	public HashMap<String, Palette> palettes = new HashMap<String, Palette>();
	public HashMap<String, Act> acts = new HashMap<String, Act>(); 
	public String actBoot;
	public AsmSourceCode glb;
	
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

		// Objects
		// ********************************************************************
		
		HashMap<String, String[]> objectProperties = PropertyList.get(prop, "object");
		if (objectProperties == null) {
			throw new Exception("object not found in " + fileName);
		}
		
		// Chargement des fichiers de configuration des Objets
		for (Map.Entry<String,String[]> curObject : objectProperties.entrySet()) {
			BuildDisk.logger.debug("\tLoad Object "+curObject.getKey()+": "+curObject.getValue()[0]);
			objects.put(curObject.getKey(), new Object(name, curObject.getKey(), curObject.getValue()[0]));
		}	
		
		// Palettes
		// ********************************************************************
		
		HashMap<String, String[]> paletteProperties = PropertyList.get(prop, "palette");
		if (paletteProperties == null) {
			throw new Exception("palette not found in " + fileName);
		}
		
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
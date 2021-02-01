package fr.bento8.to8.build;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import fr.bento8.to8.disk.DataIndex;

public class GameMode extends AsmInclude{

	public String fileName;
	public int dataSize;
	public DataIndex fileIndex = new DataIndex();
	public ObjectBin code; // Main Engine
	
	public String engineAsmMainEngine;
	public HashMap<String, Object> objects = new HashMap<String, Object>();
	public HashMap<String, Act> acts = new HashMap<String, Act>(); 
	public String actBoot;
	
	public GameMode(String gameModeName, String fileName) throws Exception {
		
		this.name = gameModeName;
		this.fileName = fileName;
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

		HashMap<String, String[]> engineAsmIncludesTmp = PropertyList.get(prop, "engine.asm.includ");
		for (Map.Entry<String, String[]> curInclude : engineAsmIncludesTmp.entrySet()) {
			asmIncludes.put(curInclude.getKey(), curInclude.getValue()[0]);
		}
		HashMap<String, String[]> engineLoaderAsmGenIncludes = PropertyList.get(prop, "engine.asm.gen.includ");
		for (Map.Entry<String, String[]> include : engineLoaderAsmGenIncludes.entrySet()) {
			asmIncludes.put(include.getKey(), Game.generatedCodeDirName+"/"+name+"/"+include.getValue()[0]);
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

		// Act Sequence
		// ********************************************************************

		actBoot = prop.getProperty("actBoot");
		if (actBoot == null) {
			throw new Exception("actBoot not found in " + fileName);
		}

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
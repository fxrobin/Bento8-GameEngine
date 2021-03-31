package fr.bento8.to8.build;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

public class GameModeCommon {

	public String name;
	public String fileName;
		
	public HashMap<String, Object> objects = new HashMap<String, Object>();
	public AsmSourceCode glb;
	
	public int nbHalfPage = 0;
	
	public GameModeCommon(String gameModeName, String fileName) throws Exception {
		
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
	}
}
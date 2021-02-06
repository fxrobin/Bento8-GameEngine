package fr.bento8.to8.build;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import fr.bento8.to8.image.Sprite;
import fr.bento8.to8.image.SubSpriteBin;

public class Object extends AsmInclude{

	public int id;
	public String parentName;
	public String fileName;	
	public ObjectBin code;
	public String codeFileName;
	
	public HashMap<String, Sprite> sprites = new HashMap<String, Sprite>();
	public List<SubSpriteBin> subSpritesBin = new ArrayList<SubSpriteBin>();	
	
	public HashMap<String, String[]> spritesProperties;
	public HashMap<String, String[]> animationsProperties;	
	
	public Object(String parentName, String name, String propertiesFileName) throws Exception {
		this.name = name;
		this.parentName = parentName;
		this.fileName = propertiesFileName;
		Properties prop = new Properties();
		try {
			InputStream input = new FileInputStream(propertiesFileName);
			prop.load(input);
		} catch (Exception e) {
			throw new Exception("Impossible de charger le fichier de configuration: " + propertiesFileName, e);
		}
		codeFileName = prop.getProperty("code");
		if (codeFileName == null) {
			throw new Exception("code not found in " + propertiesFileName);
		}
		
		HashMap<String, String[]> engineLoaderAsmGenIncludes = PropertyList.get(prop, "engine.asm.gen.includ");
		for (Map.Entry<String, String[]> include : engineLoaderAsmGenIncludes.entrySet()) {
			asmIncludes.put(include.getKey(), Game.generatedCodeDirName+"/"+parentName+"/"+name+"/"+include.getValue()[0]);
		}

		spritesProperties = PropertyList.get(prop, "sprite");
		animationsProperties = PropertyList.get(prop, "animation");
	}	
}

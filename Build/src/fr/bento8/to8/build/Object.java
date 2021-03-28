package fr.bento8.to8.build;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import fr.bento8.to8.audio.Sound;
import fr.bento8.to8.image.AnimationBin;
import fr.bento8.to8.image.ImageSetBin;
import fr.bento8.to8.image.Sprite;
import fr.bento8.to8.image.SubSpriteBin;

public class Object {

	public int id;
	public String name;
	public String parentName;
	public String fileName;	
	public ObjectBin code;
	public String codeFileName;
	public boolean toRAM = false;
	
	public HashMap<String, Sprite> sprites = new HashMap<String, Sprite>();
	public List<SubSpriteBin> subSpritesBin = new ArrayList<SubSpriteBin>();
	public AnimationBin animation;
	public ImageSetBin imageSet;
	public List<Sound> sounds = new ArrayList<Sound>();
	
	public HashMap<String, String[]> spritesProperties;
	public HashMap<String, String[]> animationsProperties;	
	public HashMap<String, String[]> soundsProperties;
	
	public Object(String parentName, String name, String propertiesFileName) throws Exception {
		this.name = name;
		this.parentName = parentName;
		this.fileName = propertiesFileName;
		this.animation = new AnimationBin(name);
		this.imageSet = new ImageSetBin(name);	
		
		Properties prop = new Properties();
		try {
			InputStream input = new FileInputStream(propertiesFileName);
			prop.load(input);
		} catch (Exception e) {
			throw new Exception("Impossible de charger le fichier de configuration: " + propertiesFileName, e);
		}
		
		String[] codeFileNameTmp = prop.getProperty("code").split(";");
		codeFileName = codeFileNameTmp[0];
		if (codeFileNameTmp.length > 1 && codeFileNameTmp[1].equalsIgnoreCase("RAM"))
		{
			toRAM = true;
		}
		
		if (codeFileName == null) {
			throw new Exception("code not found in " + propertiesFileName);
		}

		spritesProperties = PropertyList.get(prop, "sprite");
		animationsProperties = PropertyList.get(prop, "animation");
		soundsProperties = PropertyList.get(prop, "sound");
	}	
}

package moto.gfx;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.HashMap;

public class ReadProperties {

	HashMap<String, String[]> animationImages = new HashMap<String, String[]>();
	HashMap<String, String[]> animationScripts = new HashMap<String, String[]>();
	HashMap<String, String[]> tileImages = new HashMap<String, String[]>();
	HashMap<String, String[]> tileMaps = new HashMap<String, String[]>();
	HashMap<String, String[]> raws = new HashMap<String, String[]>();
	
	public ReadProperties() {
		try {
			List<String> allLines = Files.readAllLines(Paths.get("./input/config.properties"));
			for (String line : allLines) {
				String[] splitedLine = line.split(";");
				if (line.startsWith("animation.images=")) {
					animationImages.put(splitedLine[0], splitedLine);
				} else if (line.startsWith("animation.script")) {
					animationScripts.put(splitedLine[0], splitedLine);
				} else if (line.startsWith("tile.images=")) {
					tileImages.put(splitedLine[0], splitedLine);
				} else if (line.startsWith("tile.map=")) {
					tileMaps.put(splitedLine[0], splitedLine);
				} else if (line.startsWith("raw=")) {
					raws.put(splitedLine[0], splitedLine);
				}
			}
		} catch (IOException ex) {
			ex.printStackTrace();
		}
    }
}
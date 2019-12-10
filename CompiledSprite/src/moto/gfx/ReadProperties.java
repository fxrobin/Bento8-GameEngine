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
	String bootfile = new String();
	String outputfile = new String();
	
	public ReadProperties(String file) {
		try {
			List<String> allLines = Files.readAllLines(Paths.get(file));
			for (String line : allLines) {
				String[] splitedLine = line.split("=");
				if (splitedLine.length > 1) {
					splitedLine = splitedLine[1].split(";");
				}
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
				} else if (line.startsWith("bootfile=")) {
					bootfile=splitedLine[0];
				} else if (line.startsWith("outputfile=")) {
					outputfile=splitedLine[0];
				}
			}
		} catch (IOException ex) {
			ex.printStackTrace();
		}
    }
}
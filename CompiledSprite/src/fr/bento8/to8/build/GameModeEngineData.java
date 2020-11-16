package fr.bento8.to8.build;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.HashMap;

public class GameModeEngineData
{
	private Path gameModeEngineData;
	private String content = "";

	public GameModeEngineData(HashMap<String, String[]> includes) throws Exception {
		String key = "GMEDATA";
		if (includes.get(key) == null) {
			throw new Exception (key + " not found in include declaration.");
		}

		gameModeEngineData = Paths.get(includes.get(key)[0]);
		new AsmFile(gameModeEngineData);
	}

	public void addConstant(String name, String value) {
		content += "\n" + name + " equ " + value; 
	}

	public void addLabel(String value) { 
		content += "\n" + value; 
	}

	public void addFdb(String[] value) {
		boolean firstpass = true;
		content += "\n        fdb   "; 
		for (int i = 0; i < value.length; i++ ) {
			if (firstpass) {
				firstpass = false;
			} else {
				content += ",";
			}
			content += value[i];
		}
	}

	public void addFcb(String[] value) {
		boolean firstpass = true;
		content += "\n        fcb   "; 
		for (int i = 0; i < value.length; i++ ) {
			if (firstpass) {
				firstpass = false;
			} else {
				content += ",";
			}
			content += value[i];
		}
	}

	public void flush() {
		if(Files.exists(gameModeEngineData)) {
			try {
				Files.write(gameModeEngineData, content.getBytes(StandardCharsets.ISO_8859_1), StandardOpenOption.APPEND);
				content = "";
			} catch (IOException ioExceptionObj) {
				System.out.println("Problème à l'écriture du fichier "+gameModeEngineData.getFileName()+": " + ioExceptionObj.getMessage());
			}
		} else {
			System.out.println(gameModeEngineData.getFileName()+" introuvable.");
		}   
	}
}
package fr.bento8.to8.build;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.HashMap;

public class Globals
{
	private Path globals;
	
	public Globals(HashMap<String, String[]> includes) throws Exception {
		String key = "GLOBALS";
		if (includes.get(key) == null) {
			throw new Exception (key + " not found in include declaration.");
		}

		new AsmFile(includes.get(key)[0], key);
	}

	public void addConstant(String name, String value) {
		String content = name+" equ "+value;
        if(Files.exists(globals)) {
            try {
                Files.write(globals, content.getBytes(StandardCharsets.ISO_8859_1), StandardOpenOption.APPEND);
            } catch (IOException ioExceptionObj) {
                System.out.println("Problème à l'écriture du fichier "+globals.getFileName()+": " + ioExceptionObj.getMessage());
            }
        } else {
            System.out.println(globals.getFileName()+" introuvable.");
        }   
	}
}
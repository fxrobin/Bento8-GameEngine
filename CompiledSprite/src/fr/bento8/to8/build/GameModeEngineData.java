package fr.bento8.to8.build;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.core.LoggerContext;
import org.apache.logging.log4j.core.config.Configuration;
import org.apache.logging.log4j.core.config.Configurator;
import org.apache.logging.log4j.core.config.LoggerConfig;

import fr.bento8.to8.boot.Bootloader;
import fr.bento8.to8.compiledSprite.AssemblyGenerator;
import fr.bento8.to8.disk.FdUtil;
import fr.bento8.to8.image.PngToBottomUpBinB16;
import fr.bento8.to8.image.SpriteSheet;
import fr.bento8.to8.util.C6809Util;
import fr.bento8.to8.util.FileUtil;
import fr.bento8.to8.util.knapsack.Item;
import fr.bento8.to8.util.knapsack.Knapsack;
import fr.bento8.to8.util.knapsack.Solution;

public class GameModeEngineData
{
	private Path gameModeEngineData;
	
	public GameModeEngineData(HashMap<String, String[]> includes) throws Exception {
		String key = "GMEDATA";
		if (includes.get(key) == null) {
			throw new Exception (key + " not found in include declaration.");
		}

		new AsmFile(includes.get(key)[0], key);
	}

	public void addConstant(String name, String value) {
		String content = name+" equ $"+value;
        if(Files.exists(gameModeEngineData)) {
            try {
                Files.write(gameModeEngineData, content.getBytes(StandardCharsets.ISO_8859_1), StandardOpenOption.APPEND);
            } catch (IOException ioExceptionObj) {
                System.out.println("Problème à l'écriture du fichier "+gameModeEngineData.getFileName()+": " + ioExceptionObj.getMessage());
            }
        } else {
            System.out.println(gameModeEngineData.getFileName()+" introuvable.");
        }   
	}
	
	public void addLabel(String name) {
		String content = name;
        if(Files.exists(gameModeEngineData)) {
            try {
                Files.write(gameModeEngineData, content.getBytes(StandardCharsets.ISO_8859_1), StandardOpenOption.APPEND);
            } catch (IOException ioExceptionObj) {
                System.out.println("Problème à l'écriture du fichier "+gameModeEngineData.getFileName()+": " + ioExceptionObj.getMessage());
            }
        } else {
            System.out.println(gameModeEngineData.getFileName()+" introuvable.");
        }   
	}
	
	public void addFdb(String[] value) {
//		String content = value;
//        if(Files.exists(gameModeEngineData)) {
//            try {
//                Files.write(gameModeEngineData, content.getBytes(StandardCharsets.ISO_8859_1), StandardOpenOption.APPEND);
//            } catch (IOException ioExceptionObj) {
//                System.out.println("Problème à l'écriture du fichier "+gameModeEngineData.getFileName()+": " + ioExceptionObj.getMessage());
//            }
//        } else {
//            System.out.println(gameModeEngineData.getFileName()+" introuvable.");
//        }   
	}
}
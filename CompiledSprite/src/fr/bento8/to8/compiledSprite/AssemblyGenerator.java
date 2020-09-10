package fr.bento8.to8.compiledSprite;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import fr.bento8.to8.build.BuildDisk;
import fr.bento8.to8.image.SpriteSheet;

public class AssemblyGenerator{

	private static final Logger logger = LogManager.getLogger("log");

	boolean FORWARD = true;

	String spriteName;

	public String eraseAddress;

	// Initialisation du code statique
	String posAdress = "9F00";

	// Etiquettes
	String erasePrefix = "ERASE_";
	String drawLabel, dataLabel, ssaveLabel, eraseLabel, erasePosLabel, eraseCodeLabel;

	// Code
	List<String> spriteCode1 = new ArrayList<String>();
	List<String> spriteCode2 = new ArrayList<String>();
	List<String> spriteECode1 = new ArrayList<String>();
	List<String> spriteECode2 = new ArrayList<String>();
	List<String> spriteEData1 = new ArrayList<String>();
	List<String> spriteEData2 = new ArrayList<String>();

	public AssemblyGenerator(SpriteSheet spriteSheet, int imageNum) throws Exception {
		spriteName = spriteSheet.getName().toUpperCase().replaceAll("[^A-Za-z0-9]", "")+imageNum;

		// Etiquettes Code d'éctiture et Code d'effacement
		drawLabel   = "DRAW_" + spriteName;
		dataLabel   = "DATA_" + spriteName;
		ssaveLabel  = "SSAV_" + spriteName;

		// Etiquettes spécifiques Code d'effacement
		eraseLabel     = erasePrefix + spriteName;
		erasePosLabel  = erasePrefix + "POS_"  + spriteName;
		eraseCodeLabel = erasePrefix + "CODE_"  + spriteName;

		logger.debug("Planche:"+spriteSheet.getName()+" image:"+imageNum);
		logger.debug("RAM 0 (val hex 00 à 10 par pixel, 00 Transparent):");
		logger.debug(debug80Col(spriteSheet.getSubImagePixels(imageNum, 0)));

		PatternFinder cs0 = new PatternFinder(spriteSheet.getSubImagePixels(imageNum, 0));
		cs0.buildCode(FORWARD);
		fr.bento8.to8.compiledSprite.Solution solution = cs0.getSolutions().get(0);
		PatternCluster cluster = new PatternCluster(solution);
		cluster.cluster(FORWARD);
		RegisterOptim regOpt = new RegisterOptim(solution, spriteSheet.getSubImageData(imageNum, 0));
		regOpt.build();
		spriteCode1 = regOpt.getAsmCode();
		generateDataFDB(regOpt.getTotalPatternBytes(), spriteEData1);

		logger.debug("RAM 1 (val hex 00 à 10 par pixel, 00 Transparent):");
		logger.debug(debug80Col(spriteSheet.getSubImagePixels(imageNum, 1)));

		PatternFinder cs1 = new PatternFinder(spriteSheet.getSubImagePixels(imageNum, 1));
		cs1.buildCode(FORWARD);
		solution = cs1.getSolutions().get(0);
		cluster = new PatternCluster(solution);
		cluster.cluster(FORWARD);
		regOpt = new RegisterOptim(solution, spriteSheet.getSubImageData(imageNum, 1));
		regOpt.build();
		spriteCode2 = regOpt.getAsmCode();	
		generateDataFDB(regOpt.getTotalPatternBytes(), spriteEData2);

	}

	public List<String> getCompiledEData(int i) {
		return getCompiledEData("", i);
	}	

	public List<String> getCompiledEData(String prefix, int i) {
		if (i == 1) {
			spriteEData2.set(0, prefix + dataLabel + "_2");
			spriteEData2.add(prefix + dataLabel + "_END");
		} else {
			spriteEData1.set(0, prefix + dataLabel + "_1");
		}
		return (i == 1) ? spriteEData2 : spriteEData1;
	}

	public List<String> getCodeHeader(String label, int pos) {
		return getCodeHeader("", label, pos);
	}	

	public List<String> getCodeHeader(String prefix, String label, int pos) {
		List<String> code = new ArrayList<String>();
		code.add(label);
		code.add("\tPSHS U,DP");
		code.add("\tSTS " + prefix + ssaveLabel + "+2");
		code.add("");
		if (prefix.contentEquals(""))
		{
			code.add("\tLDS $" + posAdress);
			code.add("\tSTS " + erasePosLabel + "_" + pos + "+2"); // auto-modification du code
		}
		else {
			code.add(erasePosLabel + "_" + pos); // label pour auto-modification du code
			code.add("\tLDS #$0000");
		}

		if (prefix.contentEquals(""))
		{
			code.add("\tLDU #" + erasePrefix + dataLabel + "_" + pos);
		} else {
			code.add("\tLDU #" + erasePrefix + dataLabel + "_2-1");
		}

		if (prefix.contentEquals(""))
		{
			code.add("");
		}
		else {
			code.add(eraseCodeLabel + "_" + pos);
		}

		return code;
	}

	public List<String> getCodeSwitchData(int pos) {
		return getCodeSwitchData("", pos);
	}

	public List<String> getCodeSwitchData(String prefix, int pos) {
		List<String> code = new ArrayList<String>();
		code.add("");
		if (prefix.contentEquals(""))
		{
			code.add("\tLDS $" + posAdress + "+2");
			code.add("\tSTS " + erasePosLabel + "_" + pos + "+2"); // auto-modification du code
		}
		else {
			code.add(erasePosLabel + "_" + pos); // label pour auto-modification du code
			code.add("\tLDS #$0000");
		}

		if (prefix.contentEquals(""))
		{
		code.add("\tLDU #" + erasePrefix + dataLabel + "_" + pos);
		} else {
			code.add("\tLDU #" + erasePrefix + dataLabel + "_END-1");
		}

		if (prefix.contentEquals(""))
		{
			code.add("");
		}
		else {
			code.add(eraseCodeLabel + "_" + pos);
		}
		return code;
	}

	public List<String> getCodeFooter() {
		return getCodeFooter("");
	}

	public List<String> getCodeFooter(String prefix) {
		List<String> code = new ArrayList<String>();
		code.add("");
		code.add(prefix + ssaveLabel);
		code.add("\tLDS #$0000");
		code.add("\tPULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)");
		code.add("");
		return code;
	}

	public void generateDataFDB(int size, List<String> spriteData) {

		// **************************************************************
		// Construit un tableau de données en assembleur
		// **************************************************************
		spriteData.add(""); // utilisé plus tard pour le tag
		int i = 0;

		while (i < size) {
			if (i < size - 2) {
				spriteData.add("\tFDB $0000");
				i += 2;
			} else {
				spriteData.add("\tFCB $00");
				i += 1;
			}
		}
	}

	public byte[] getCompiledCode(String org) {
		byte[]  content = {};
		List<String> code = new ArrayList<String>();
		String asmFileName = BuildDisk.tmpDirName+"/"+spriteName+".ASM";
		String binFileName = BuildDisk.tmpDirName+"/"+spriteName+".BIN";
		String lstFileName = BuildDisk.tmpDirName+"/"+spriteName+".lst";

		try
		{
			Path assemblyFile = Paths.get(asmFileName);
			Files.deleteIfExists(assemblyFile);
			Files.createFile(assemblyFile);

			code.add("(main)"+asmFileName);
			code.add("\tORG $"+org);
			Files.write(assemblyFile, code, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCodeHeader(drawLabel, 1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, spriteCode2, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCodeSwitchData(2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, spriteCode1, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCodeFooter(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);

			Files.write(assemblyFile, getCodeHeader(erasePrefix, eraseLabel, 1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, spriteECode2, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCodeSwitchData(erasePrefix, 2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, spriteECode1, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCodeFooter(erasePrefix), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCompiledEData(erasePrefix, 2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCompiledEData(erasePrefix, 1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);

			// Delete binary file
			Path binaryFile = Paths.get(binFileName);
			Files.deleteIfExists(binaryFile);

			// Generate binary code from assembly code
			Process p = new ProcessBuilder("c6809.exe", "-bd", asmFileName, binFileName).start();
			BufferedReader br=new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;
			while((line=br.readLine())!=null){
				System.out.println(line);
			}
			p.waitFor();

			// Load binary code
			content = Files.readAllBytes(Paths.get(binFileName));	
			Files.deleteIfExists(binaryFile);

			// Rename .lst File
			File f = new File("codes.lst"); 
			Path lstFile = Paths.get(lstFileName);
			Files.deleteIfExists(lstFile);
			f.renameTo(new File(lstFileName));

			// Récupère l'adresse de la routine d'effacement
			Pattern pattern = Pattern.compile(".*Label (.*) ERASE_"+spriteName);
			try (Stream<String> lines = Files.lines(Paths.get(lstFileName), Charset.forName("ISO-8859-1"))) {
				lines.map(pattern::matcher)
				.filter(Matcher::matches)
				.findFirst()
				.ifPresent(matcher -> eraseAddress = matcher.group(1));
			}
		} 
		catch (Exception e)
		{
			e.printStackTrace(); 
			System.out.println(e); 
		}
		return content;
	}

	public static String debug80Col(byte[] b1) {
		StringBuilder strBuilder = new StringBuilder();
		int i = 0;
		for(byte val : b1) {
			if (val == 0) {
				strBuilder.append(".");
			} else {
				strBuilder.append(String.format("%01x", (val-1)&0xff));
			}
			if (++i == 80) {
				strBuilder.append(System.lineSeparator());
				i = 0;
			}
		}
		return strBuilder.toString();
	}

	public String getEraseAddress() {
		return eraseAddress;
	}
}
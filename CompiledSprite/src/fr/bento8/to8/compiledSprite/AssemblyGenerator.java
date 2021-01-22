package fr.bento8.to8.compiledSprite;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
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

import fr.bento8.to8.InstructionSet.Register;
import fr.bento8.to8.build.BuildDisk;
import fr.bento8.to8.image.SpriteSheet;
import fr.bento8.to8.util.C6809Util;

public class AssemblyGenerator{

	private static final Logger logger = LogManager.getLogger("log");

	boolean FORWARD = true;
	public String spriteName;
	public String eraseAddress;
	private int cyclesFrameCode;
	private int sizeFrameCode;

	// Code
	private List<String> spriteCode1 = new ArrayList<String>();
	private List<String> spriteCode2 = new ArrayList<String>();
	private List<String> spriteECode1 = new ArrayList<String>();
	private List<String> spriteECode2 = new ArrayList<String>();
	private int cyclesSpriteCode1;
	private int cyclesSpriteCode2;
	private int cyclesSpriteECode1;
	private int cyclesSpriteECode2;
	private int sizeSpriteCode1;
	private int sizeSpriteCode2;
	private int sizeSpriteECode1;
	private int sizeSpriteECode2;
	private int sizeSpriteEData1;
	private int sizeSpriteEData2;
	private int sizeCache, cycleCache;

	public AssemblyGenerator(SpriteSheet spriteSheet, int imageNum) throws Exception {
		spriteName = spriteSheet.getName().toUpperCase().replaceAll("[^A-Za-z0-9]", "")+imageNum;

		logger.debug("Planche:"+spriteSheet.getName()+" image:"+imageNum);
		logger.debug("RAM 0 (val hex 0 à f par pixel, . Transparent):");
		logger.debug(debug80Col(spriteSheet.getSubImagePixels(imageNum, 0)));

		String asmFileName = BuildDisk.generatedCodeDirName+"/"+spriteName+".ASM";
		Path asmFile = Paths.get(asmFileName);
		String lstFileName = BuildDisk.generatedCodeDirName+"/"+spriteName+".lst";
		Path lstFile = Paths.get(lstFileName);
		String binFileName = BuildDisk.generatedCodeDirName+"/"+spriteName+".BIN";
		Path binFile = Paths.get(binFileName);

		// Si l'option d'utilisation du cache est activée et qu'on trouve les fichiers .BIN et .ASM
		// on passe la génération du code de sprite compilé
		if (!(BuildDisk.useCache && Files.exists(binFile) && Files.exists(asmFile) && Files.exists(lstFile))) {

			PatternFinder cs = new PatternFinder(spriteSheet.getSubImagePixels(imageNum, 0));
			cs.buildCode(FORWARD);
			Solution solution = cs.getSolutions().get(0);

			PatternCluster cluster = new PatternCluster(solution);
			cluster.cluster(FORWARD);

			SolutionOptim regOpt = new SolutionOptim(solution, spriteSheet.getSubImageData(imageNum, 0), BuildDisk.maxTries);
			regOpt.build();

			spriteCode1 = regOpt.getAsmCode();
			cyclesSpriteCode1 = regOpt.getAsmCodeCycles();
			sizeSpriteCode1 = regOpt.getAsmCodeSize();

			spriteECode1 = regOpt.getAsmECode();
			cyclesSpriteECode1 = regOpt.getAsmECodeCycles();
			sizeSpriteECode1 = regOpt.getAsmECodeSize();

			sizeSpriteEData1 = regOpt.getDataSize();

			logger.debug("Taille de la zone data 1: "+sizeSpriteEData1);
			logger.debug("RAM 1 (val hex 0  à f par pixel, . Transparent):");
			logger.debug(debug80Col(spriteSheet.getSubImagePixels(imageNum, 1)));

			cs = new PatternFinder(spriteSheet.getSubImagePixels(imageNum, 1));
			cs.buildCode(FORWARD);
			solution = cs.getSolutions().get(0);

			cluster = new PatternCluster(solution);
			cluster.cluster(FORWARD);

			regOpt = new SolutionOptim(solution, spriteSheet.getSubImageData(imageNum, 1), BuildDisk.maxTries);
			regOpt.build();

			spriteCode2 = regOpt.getAsmCode();	
			cyclesSpriteCode2 = regOpt.getAsmCodeCycles();
			sizeSpriteCode2 = regOpt.getAsmCodeSize();

			spriteECode2 = regOpt.getAsmECode();
			cyclesSpriteECode2 = regOpt.getAsmECodeCycles();
			sizeSpriteECode2 = regOpt.getAsmECodeSize();

			sizeSpriteEData2 = regOpt.getDataSize();

			logger.debug("Taille de la zone data 2: "+sizeSpriteEData2);

			// Calcul des cycles et taille du code de cadre
			sizeFrameCode = 0;
			sizeFrameCode += getCodeFrame1Size();
			sizeFrameCode += getCodeFrame2Size();
			sizeFrameCode += getCodeFrame3Size();
			sizeFrameCode += getCodeFrame5Size();

			cyclesFrameCode = 0;
			cyclesFrameCode += getCodeFrame1Cycles();
			cyclesFrameCode += getCodeFrame2Cycles();
			cyclesFrameCode += getCodeFrame3Cycles();
			cyclesFrameCode += getCodeFrame5Cycles();
		} else {
			// Utilisation du .BIN existant
			byte[] content = Files.readAllBytes(Paths.get(binFileName));	
			sizeCache = content.length;
			// Utilisation du .lst existant
			cycleCache = C6809Util.countCycles(lstFileName);
		}
	}

	public byte[] getCompiledCode(String org) {
		byte[]  content = {};
		String asmFileName = BuildDisk.generatedCodeDirName+"/"+spriteName+".ASM";
		String binFileName = BuildDisk.generatedCodeDirName+"/"+spriteName+".BIN";
		String lstFileName = BuildDisk.generatedCodeDirName+"/"+spriteName+".lst";

		Path asmFile = Paths.get(asmFileName);
		Path lstFile = Paths.get(lstFileName);
		Path binFile = Paths.get(binFileName);

		try
		{
			if (!(BuildDisk.useCache && Files.exists(binFile) && Files.exists(asmFile) && Files.exists(lstFile))) {
				Files.deleteIfExists(asmFile);
				Files.createFile(asmFile);

				Files.write(asmFile, getCodeFrame1("IMG.ASM", org), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmFile, spriteCode2, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmFile, getCodeFrame2(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmFile, spriteCode1, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmFile, getCodeFrame3(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmFile, spriteECode1, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmFile, spriteECode2, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmFile, getCodeFrame5(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			} else {
				// change ORG adress in existing ASM file
				String str = new String(Files.readAllBytes(asmFile), StandardCharsets.UTF_8);
				Pattern p = Pattern.compile("[ \t]*ORG[ \t]*\\$[a-fA-F0-9]{4}");
				Matcher m = p.matcher(str);
				if (m.find()) {
				    str = m.replaceFirst("\tORG \\$"+org);
				}
				Files.write(asmFile, str.getBytes(StandardCharsets.UTF_8));
			}

			// Delete binary file
			Files.deleteIfExists(binFile);

			// Generate binary code from assembly code
			Process p = new ProcessBuilder(BuildDisk.c6809, "-bd", asmFileName, binFileName).start();
			BufferedReader br=new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;
			while((line=br.readLine())!=null){
				System.out.println(line);
			}
			p.waitFor();

			// Load binary code
			content = Files.readAllBytes(Paths.get(binFileName));	

			// Rename .lst File
			File f = new File("codes.lst"); 
			Files.deleteIfExists(lstFile);
			f.renameTo(new File(lstFileName));

			// Compte le nombre de cycles du .lst
			int compilerCycles = C6809Util.countCycles(lstFileName);
			int computedCycles = getCycles();
			int computedSize = getSize();
			logger.debug(lstFileName + " c6809.exe cycles: " + compilerCycles + " computed cycles: " + computedCycles);
			logger.debug(lstFileName + " c6809.exe size: " + content.length + " computed size: " + computedSize);

			if (computedCycles != compilerCycles || content.length != computedSize) {
				logger.fatal(lstFileName + " Ecart de cycles ou de taille entre la version compilée par c6809 et la valeur calculée par le générateur de code.", new Exception("Prérequis."));
			}

			// Récupère l'adresse de la routine d'effacement
			Pattern pattern = Pattern.compile(".*Label (.*) ERASE_"+spriteName);
			try (Stream<String> lines = Files.lines(lstFile, Charset.forName("ISO-8859-1"))) {
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

	public List<String> getCodeFrame1(String fileName, String org) {
		List<String> asm = new ArrayList<String>();
		asm.add("(main)" + fileName + "");
		asm.add("\tORG $" + org + "");
		asm.add("DRAW_" + spriteName + "");
		asm.add("\tSTS SSAV_" + spriteName + "+2,PCR\n");
		asm.add("\tSTD DYN_POS+2,PCR");		
		asm.add("\tLDS ,Y");
		return asm;
	}

	public int getCodeFrame1Cycles() {
		int cycles = 0;
		cycles += Register.costIndexedST[Register.S]+Register.costIndexedOffsetPCR;
		cycles += Register.costIndexedST[Register.D]+Register.costIndexedOffsetPCR;		
		cycles += Register.costIndexedLD[Register.S];
		return cycles;
	}

	public int getCodeFrame1Size() {
		int size = 0;
		size += Register.sizeIndexedST[Register.S]+Register.sizeIndexedOffsetPCR;
		size += Register.sizeIndexedST[Register.D]+Register.sizeIndexedOffsetPCR;		
		size += Register.sizeIndexedLD[Register.S];
		return size;
	}

	public List<String> getCodeFrame2() {
		List<String> asm = new ArrayList<String>();
		asm.add("DYN_POS");
		asm.add("\n\tLDS #$0000");		
		return asm;
	}

	public int getCodeFrame2Cycles() {
		int cycles = 0;
		cycles += Register.costDirectLD[Register.S];
		return cycles;
	}

	public int getCodeFrame2Size() {
		int size = 0;
		size += Register.sizeDirectLD[Register.S];
		return size;
	}

	public List<String> getCodeFrame3() {
		List<String> asm = new ArrayList<String>();
		asm.add("SSAV_" + spriteName + "");
		asm.add("\tLDS #$0000");
		asm.add("\tRTS\n");
		asm.add("ERASE_" + spriteName + "");
		asm.add("\tSTS ERASE_SSAV_" + spriteName + "+2,PCR\n");
		asm.add("ERASE_CODE_" + spriteName + "_1");
		return asm;
	}

	public int getCodeFrame3Cycles() {
		int cycles = 0;
		cycles += Register.costImmediateLD[Register.S];
		cycles += 5; // RTS
		cycles += Register.costIndexedST[Register.S]+Register.costIndexedOffsetPCR;
		return cycles;
	}

	public int getCodeFrame3Size() {
		int size = 0;
		size += Register.sizeImmediateLD[Register.S];
		size += 1; // RTS
		size += Register.sizeIndexedST[Register.S]+Register.sizeIndexedOffsetPCR;
		return size;
	}

	public List<String> getCodeFrame5() {
		List<String> asm = new ArrayList<String>();
		asm.add("ERASE_SSAV_" + spriteName + "");
		asm.add("\tLDS #$0000");
		asm.add("\tRTS\n");
		return asm;
	}

	public int getCodeFrame5Cycles() {
		int cycles = 0;
		cycles += Register.costImmediateLD[Register.S];
		cycles += 5; // RTS
		return cycles;
	}

	public int getCodeFrame5Size() {
		int size = 0;
		size += Register.sizeImmediateLD[Register.S];
		size += 1; // RTS
		return size;
	}

	public int getCycles() {
		return cyclesFrameCode + cyclesSpriteCode1 + cyclesSpriteCode2 + cyclesSpriteECode1 + cyclesSpriteECode2 + cycleCache;
	}

	public int getSize() {
		return sizeFrameCode + sizeSpriteCode1 + sizeSpriteCode2 + sizeSpriteECode1 + sizeSpriteECode2 + sizeCache;
	}

	public int getSizeData1() {
		return sizeSpriteEData1;
	}

	public int getSizeData2() {
		return sizeSpriteEData2;
	}
}
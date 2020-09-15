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
	private String heroPosition = "9F00"; // identique à HERO_POS dans MAIN.ASM TODO A modifier : stocker les positions avec les données d'effacement (multisprite)

	// Code
	private List<String> spriteCode1 = new ArrayList<String>();
	private List<String> spriteCode2 = new ArrayList<String>();
	private List<String> spriteECode1 = new ArrayList<String>();
	private List<String> spriteECode2 = new ArrayList<String>();
	private List<String> spriteEData1 = new ArrayList<String>();
	private List<String> spriteEData2 = new ArrayList<String>();
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

	public AssemblyGenerator(SpriteSheet spriteSheet, int imageNum) throws Exception {
		spriteName = spriteSheet.getName().toUpperCase().replaceAll("[^A-Za-z0-9]", "")+imageNum;

		logger.debug("Planche:"+spriteSheet.getName()+" image:"+imageNum);
		logger.debug("RAM 0 (val hex 0 à f par pixel, . Transparent):");
		logger.debug(debug80Col(spriteSheet.getSubImagePixels(imageNum, 0)));

		PatternFinder cs = new PatternFinder(spriteSheet.getSubImagePixels(imageNum, 0));
		cs.buildCode(FORWARD);
		Solution solution = cs.getSolutions().get(0);
		
		PatternCluster cluster = new PatternCluster(solution);
		cluster.cluster(FORWARD);
		
		SolutionOptim regOpt = new SolutionOptim(solution, spriteSheet.getSubImageData(imageNum, 0));
		regOpt.build();
		
		spriteCode1 = regOpt.getAsmCode();
		cyclesSpriteCode1 = regOpt.getAsmCodeCycles();
		sizeSpriteCode1 = regOpt.getAsmCodeSize();
		
		spriteECode1 = regOpt.getAsmECode();
		cyclesSpriteECode1 = regOpt.getAsmECodeCycles();
		sizeSpriteECode1 = regOpt.getAsmECodeSize();
		
		sizeSpriteEData1 = regOpt.getDataSize();
		generateDataFDB(sizeSpriteEData1, spriteEData1);

		logger.debug("Taille de la zone data 1: "+sizeSpriteEData1);
		logger.debug("RAM 1 (val hex 0 à f par pixel, . Transparent):");
		logger.debug(debug80Col(spriteSheet.getSubImagePixels(imageNum, 1)));

		cs = new PatternFinder(spriteSheet.getSubImagePixels(imageNum, 1));
		cs.buildCode(FORWARD);
		solution = cs.getSolutions().get(0);
		
		cluster = new PatternCluster(solution);
		cluster.cluster(FORWARD);
		
		regOpt = new SolutionOptim(solution, spriteSheet.getSubImageData(imageNum, 1));
		regOpt.build();
		
		spriteCode2 = regOpt.getAsmCode();	
		cyclesSpriteCode2 = regOpt.getAsmCodeCycles();
		sizeSpriteCode2 = regOpt.getAsmCodeSize();
		
		spriteECode2 = regOpt.getAsmECode();
		cyclesSpriteECode2 = regOpt.getAsmECodeCycles();
		sizeSpriteECode2 = regOpt.getAsmECodeSize();
		
		sizeSpriteEData2 = regOpt.getDataSize();
		generateDataFDB(sizeSpriteEData2, spriteEData2);
		
		logger.debug("Taille de la zone data 2: "+sizeSpriteEData2);
		
		// Calcul des cycles et taille du code de cadre
		sizeFrameCode = 0;
		sizeFrameCode += getCodeFrame1Size();
		sizeFrameCode += getCodeFrame2Size();
		sizeFrameCode += getCodeFrame3Size();
		sizeFrameCode += getCodeFrame4Size();
		sizeFrameCode += getCodeFrame5Size();
		
		cyclesFrameCode = 0;
		cyclesFrameCode += getCodeFrame1Cycles();
		cyclesFrameCode += getCodeFrame2Cycles();
		cyclesFrameCode += getCodeFrame3Cycles();
		cyclesFrameCode += getCodeFrame4Cycles();
		cyclesFrameCode += getCodeFrame5Cycles();
	}
	
	public byte[] getCompiledCode(String org) {
		byte[]  content = {};
		String asmFileName = BuildDisk.tmpDirName+"/"+spriteName+".ASM";
		String binFileName = BuildDisk.tmpDirName+"/"+spriteName+".BIN";
		String lstFileName = BuildDisk.tmpDirName+"/"+spriteName+".lst";

		try
		{
			Path assemblyFile = Paths.get(asmFileName);
			Files.deleteIfExists(assemblyFile);
			Files.createFile(assemblyFile);
			
			Files.write(assemblyFile, getCodeFrame1("IMG.ASM", org), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, spriteCode1, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCodeFrame2(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, spriteCode2, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCodeFrame3(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, spriteECode1, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCodeFrame4(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, spriteECode2, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCodeFrame5(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, spriteEData1, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCodeFrame6(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, spriteEData2, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(assemblyFile, getCodeFrame7(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			
			// Delete binary file
			Path binaryFile = Paths.get(binFileName);
			Files.deleteIfExists(binaryFile);

			// Generate binary code from assembly code
			Process p = new ProcessBuilder(BuildDisk.compiler, "-bd", asmFileName, binFileName).start();
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
			
			// Compte le nombre de cycles du .lst
			int compilerCycles = C6809Util.countCycle(lstFileName);
			int computedCycles = getCycles();
			int computedSize = getSize();
			logger.debug(lstFileName + " c6809.exe cycles: " + compilerCycles + " computed cycles: " + computedCycles);
			logger.debug(lstFileName + " c6809.exe size: " + content.length + " computed size: " + computedSize);

			if (computedCycles != compilerCycles || content.length != computedSize) {
				logger.fatal(lstFileName + " Ecart de cycles ou de taille entre la version compilée par c6809 et la valeur calculée par le générateur de code.", new Exception("Prérequis."));
			}
			
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

	public List<String> getCodeFrame1(String fileName, String org) {
		List<String> asm = new ArrayList<String>();
		asm.add("(main)" + fileName + "");
		asm.add("\tORG $" + org + "");
		asm.add("DRAW_" + spriteName + "");
		asm.add("\tPSHS U,DP");
		asm.add("\tSTS SSAV_" + spriteName + "+2\n");
		asm.add("\tLDS $"+heroPosition+"");
		asm.add("\tSTS ERASE_POS_" + spriteName + "_1+2");
		asm.add("\tLDU #ERASE_DATA_" + spriteName + "_2");
		return asm;
	}
	
	public int getCodeFrame1Cycles() {
		int cycles = 0;
		cycles += Register.getCostImmediatePULPSH(3);
		cycles += Register.costExtendedST[Register.S];
		cycles += Register.costExtendedLD[Register.S];
		cycles += Register.costExtendedST[Register.S];
		cycles += Register.costImmediateLD[Register.U];
		return cycles;
	}
	
	public int getCodeFrame1Size() {
		int size = 0;
		size += Register.sizeImmediatePULPSH;
		size += Register.sizeExtendedST[Register.S];
		size += Register.sizeExtendedLD[Register.S];
		size += Register.sizeExtendedST[Register.S];
		size += Register.sizeImmediateLD[Register.U];
		return size;
	}

	public List<String> getCodeFrame2() {
		List<String> asm = new ArrayList<String>();
		asm.add("\n\tLDS $"+heroPosition+"+2");		
		asm.add("\tSTS ERASE_POS_" + spriteName + "_2+2");		
		asm.add("\tLDU #ERASE_DATA_" + spriteName + "_END\n");
		return asm;
	}
	
	public int getCodeFrame2Cycles() {
		int cycles = 0;
		cycles += Register.costExtendedLD[Register.S];
		cycles += Register.costExtendedST[Register.S];
		cycles += Register.costImmediateLD[Register.U];
		return cycles;
	}
	
	public int getCodeFrame2Size() {
		int size = 0;
		size += Register.sizeExtendedLD[Register.S];
		size += Register.sizeExtendedST[Register.S];
		size += Register.sizeImmediateLD[Register.U];
		return size;
	}
	
	public List<String> getCodeFrame3() {
		List<String> asm = new ArrayList<String>();
		asm.add("SSAV_" + spriteName + "");
	    asm.add("\tLDS #$0000");
	    asm.add("\tPULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)\n");
	    asm.add("ERASE_" + spriteName + "");
	    asm.add("\tPSHS U,DP");	    
	    asm.add("\tSTS ERASE_SSAV_" + spriteName + "+2\n");
	    asm.add("ERASE_POS_" + spriteName + "_1");
	    asm.add("\tLDS #$0000");
	    asm.add("\tLDU #ERASE_DATA_" + spriteName + "_1\n");
	    asm.add("ERASE_CODE_" + spriteName + "_1");
		return asm;
	}
	
	public int getCodeFrame3Cycles() {
		int cycles = 0;
		cycles += Register.costImmediateLD[Register.S];
		cycles += Register.getCostImmediatePULPSH(5);
		cycles += Register.getCostImmediatePULPSH(3);
		cycles += Register.costExtendedST[Register.S];
		cycles += Register.costImmediateLD[Register.S];
		cycles += Register.costImmediateLD[Register.U];
		return cycles;
	}
	
	public int getCodeFrame3Size() {
		int size = 0;
		size += Register.sizeImmediateLD[Register.S];
		size += Register.sizeImmediatePULPSH;
		size += Register.sizeImmediatePULPSH;
		size += Register.sizeExtendedST[Register.S];
		size += Register.sizeImmediateLD[Register.S];
		size += Register.sizeImmediateLD[Register.U];
		return size;
	}

	public List<String> getCodeFrame4() {
		List<String> asm = new ArrayList<String>();
		asm.add("ERASE_POS_" + spriteName + "_2");
	    asm.add("\tLDS #$0000");	    
	    asm.add("\tLDU #ERASE_DATA_" + spriteName + "_2\n");
	    asm.add("ERASE_CODE_" + spriteName + "_2");
		return asm;
	}
	
	public int getCodeFrame4Cycles() {
		int cycles = 0;
		cycles += Register.costImmediateLD[Register.S];
		cycles += Register.costImmediateLD[Register.U];
		return cycles;
	}
	
	public int getCodeFrame4Size() {
		int size = 0;
		size += Register.sizeImmediateLD[Register.S];
		size += Register.sizeImmediateLD[Register.U];
		return size;
	}
	
	public List<String> getCodeFrame5() {
		List<String> asm = new ArrayList<String>();
		asm.add("ERASE_SSAV_" + spriteName + "");
		asm.add("\tLDS #$0000");
		asm.add("\tPULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)\n");
		asm.add("ERASE_DATA_" + spriteName + "_1");
		return asm;
	}
	
	public int getCodeFrame5Cycles() {
		int cycles = 0;
		cycles += Register.costImmediateLD[Register.S];
		cycles += Register.getCostImmediatePULPSH(5);
		return cycles;
	}
	
	public int getCodeFrame5Size() {
		int size = 0;
		size += Register.sizeImmediateLD[Register.S];
		size += Register.sizeImmediatePULPSH;
		return size;
	}
	
	public List<String> getCodeFrame6() {
		List<String> asm = new ArrayList<String>();
		asm.add("ERASE_DATA_" + spriteName + "_2");
		return asm;
	}
	
	public List<String> getCodeFrame7() {
		List<String> asm = new ArrayList<String>();
		asm.add("ERASE_DATA_" + spriteName + "_END");
		return asm;
	}
	
	public void generateDataFDB(int size, List<String> spriteData) {

		// **************************************************************
		// Construit un tableau de données vide en assembleur
		// **************************************************************
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

	public int getCycles() {
		return cyclesFrameCode + cyclesSpriteCode1 + cyclesSpriteCode2 + cyclesSpriteECode1 + cyclesSpriteECode2;
	}

	public int getSize() {
		return sizeFrameCode + sizeSpriteCode1 + sizeSpriteCode2 + sizeSpriteECode1 + sizeSpriteECode2 + sizeSpriteEData1 + sizeSpriteEData2;
	}
	
	public int getSizeData1() {
		return sizeSpriteEData1;
	}
	
	public int getSizeData2() {
		return sizeSpriteEData2;
	}
}
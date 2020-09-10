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

public class AssemblyGenerator{

	private static final Logger logger = LogManager.getLogger("log");

	boolean FORWARD = true;
	public String spriteName;
	public String eraseAddress;
	private int cyclesFrameCode;
	private int sizeFrameCode;
	private String heroPosition = "9F00"; // identique à HERO_POS dans MAIN.ASM TODO A modifier : stocker les positions avec les données d'effacement (multisprite)

	// Code
	List<String> spriteCode1 = new ArrayList<String>();
	List<String> spriteCode2 = new ArrayList<String>();
	List<String> spriteECode1 = new ArrayList<String>();
	List<String> spriteECode2 = new ArrayList<String>();
	List<String> spriteEData1 = new ArrayList<String>();
	List<String> spriteEData2 = new ArrayList<String>();

	public AssemblyGenerator(SpriteSheet spriteSheet, int imageNum) throws Exception {
		spriteName = spriteSheet.getName().toUpperCase().replaceAll("[^A-Za-z0-9]", "")+imageNum;

		logger.debug("Planche:"+spriteSheet.getName()+" image:"+imageNum);
		logger.debug("RAM 0 (val hex 00 à 10 par pixel, 00 Transparent):");
		logger.debug(debug80Col(spriteSheet.getSubImagePixels(imageNum, 0)));

		PatternFinder cs = new PatternFinder(spriteSheet.getSubImagePixels(imageNum, 0));
		cs.buildCode(FORWARD);
		Solution solution = cs.getSolutions().get(0);
		
		PatternCluster cluster = new PatternCluster(solution);
		cluster.cluster(FORWARD);
		
		RegisterOptim regOpt = new RegisterOptim(solution, spriteSheet.getSubImageData(imageNum, 0));
		regOpt.build();
		
		spriteCode1 = regOpt.getAsmCode();
		generateDataFDB(regOpt.getTotalPatternBytes(), spriteEData1);

		logger.debug("RAM 1 (val hex 00 à 10 par pixel, 00 Transparent):");
		logger.debug(debug80Col(spriteSheet.getSubImagePixels(imageNum, 1)));

		cs = new PatternFinder(spriteSheet.getSubImagePixels(imageNum, 1));
		cs.buildCode(FORWARD);
		solution = cs.getSolutions().get(0);
		
		cluster = new PatternCluster(solution);
		cluster.cluster(FORWARD);
		
		regOpt = new RegisterOptim(solution, spriteSheet.getSubImageData(imageNum, 1));
		regOpt.build();
		
		spriteCode2 = regOpt.getAsmCode();	
		generateDataFDB(regOpt.getTotalPatternBytes(), spriteEData2);

	}

	public byte[] getCompiledCode(String org) {
		byte[]  content = {};
		String asmFileName = BuildDisk.tmpDirName+"/"+spriteName+".ASM";
		String binFileName = BuildDisk.tmpDirName+"/"+spriteName+".BIN";
		String lstFileName = BuildDisk.tmpDirName+"/"+spriteName+".lst";
		
		cyclesFrameCode=0;
		sizeFrameCode=0;	

		try
		{
			Path assemblyFile = Paths.get(asmFileName);
			Files.deleteIfExists(assemblyFile);
			Files.createFile(assemblyFile);
			
			Files.write(assemblyFile, getCodeFrame1(asmFileName, org), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
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
		cyclesFrameCode += Register.getCostImmediatePULPSH(3);
		sizeFrameCode += Register.sizeImmediatePULPSH;

		asm.add("\tSTS SSAV_" + spriteName + "+2\n");
		cyclesFrameCode += Register.costExtendedST[Register.S];
		sizeFrameCode += Register.sizeExtendedST[Register.S];

		asm.add("\tLDS $"+heroPosition+"");
		cyclesFrameCode += Register.costExtendedLD[Register.S];
		sizeFrameCode += Register.sizeExtendedLD[Register.S];

		asm.add("\tSTS ERASE_POS_" + spriteName + "_1+2");
		cyclesFrameCode += Register.costExtendedST[Register.S];
		sizeFrameCode += Register.sizeExtendedST[Register.S];

		asm.add("\tLDU #ERASE_DATA_" + spriteName + "_2");
		cyclesFrameCode += Register.costImmediateLD[Register.U];
		sizeFrameCode += Register.sizeImmediateLD[Register.U];

		return asm;
	}

	public List<String> getCodeFrame2() {
		
		List<String> asm = new ArrayList<String>();
		asm.add("\n\tLDS $"+heroPosition+"+2");
		
		asm.add("\tSTS ERASE_POS_" + spriteName + "_2+2");
		cyclesFrameCode += Register.costExtendedST[Register.S];
		sizeFrameCode += Register.sizeExtendedST[Register.S];
		
		asm.add("\tLDU #ERASE_DATA_" + spriteName + "_END\n");
		cyclesFrameCode += Register.costImmediateLD[Register.U];
		sizeFrameCode += Register.sizeImmediateLD[Register.U];
		
		return asm;
	}
	
	public List<String> getCodeFrame3() {
		
		List<String> asm = new ArrayList<String>();
		asm.add("SSAV_" + spriteName + "");
		
	    asm.add("\tLDS #$0000");
		cyclesFrameCode += Register.costExtendedLD[Register.S];
		sizeFrameCode += Register.sizeExtendedLD[Register.S];
	    
	    asm.add("\tPULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)\n");
		cyclesFrameCode += Register.getCostImmediatePULPSH(5);
		sizeFrameCode += Register.sizeImmediatePULPSH;
	    
	    asm.add("ERASE_" + spriteName + "");
	    
	    asm.add("\tPSHS U,DP");
		cyclesFrameCode += Register.getCostImmediatePULPSH(3);
		sizeFrameCode += Register.sizeImmediatePULPSH;
	    
	    asm.add("\tSTS ERASE_SSAV_" + spriteName + "+2\n");
		cyclesFrameCode += Register.costExtendedST[Register.S];
		sizeFrameCode += Register.sizeExtendedST[Register.S];
	    
	    asm.add("ERASE_POS_" + spriteName + "_1");
	    
	    asm.add("\tLDS #$0000");
		cyclesFrameCode += Register.costExtendedLD[Register.S];
		sizeFrameCode += Register.sizeExtendedLD[Register.S];
	    
	    asm.add("\tLDU #ERASE_DATA_" + spriteName + "_1\n");
		cyclesFrameCode += Register.costImmediateLD[Register.U];
		sizeFrameCode += Register.sizeImmediateLD[Register.U];
	    
	    asm.add("ERASE_CODE_" + spriteName + "_1");
	    
		return asm;
	}

	public List<String> getCodeFrame4() {
		
		List<String> asm = new ArrayList<String>();
		asm.add("ERASE_POS_" + spriteName + "_2");
		
	    asm.add("\tLDS #$0000");
		cyclesFrameCode += Register.costExtendedLD[Register.S];
		sizeFrameCode += Register.sizeExtendedLD[Register.S];
	    
	    asm.add("\tLDU #ERASE_DATA_" + spriteName + "_2\n");
		cyclesFrameCode += Register.costImmediateLD[Register.U];
		sizeFrameCode += Register.sizeImmediateLD[Register.U];
	    
	    asm.add("ERASE_CODE_" + spriteName + "_2");
	    
		return asm;
	}
	
	public List<String> getCodeFrame5() {
		
		List<String> asm = new ArrayList<String>();
		asm.add("ERASE_SSAV_" + spriteName + "");
		
		asm.add("\tLDS #$0000");
		cyclesFrameCode += Register.costExtendedLD[Register.S];
		sizeFrameCode += Register.sizeExtendedLD[Register.S];
		
		asm.add("\tPULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)\n");
		cyclesFrameCode += Register.getCostImmediatePULPSH(5);
		sizeFrameCode += Register.sizeImmediatePULPSH;
		
		asm.add("ERASE_DATA_" + spriteName + "_1");
		return asm;
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

	public int getCyclesFrameCode() {
		return cyclesFrameCode;
	}

	public int getSizeFrameCode() {
		return sizeFrameCode;
	}

}
package fr.bento8.to8.compiledSprite.draw;

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

import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.core.config.Configurator;

import fr.bento8.to8.InstructionSet.Register;
import fr.bento8.to8.build.Game;
import fr.bento8.to8.image.SpriteSheet;
import fr.bento8.to8.util.C6809Util;

public class SimpleAssemblyGenerator{

	private static final Logger logger = LogManager.getLogger("log");

	boolean FORWARD = true;
	boolean REARWARD = false;
	public String spriteName;
	private int cyclesDFrameCode;
	private int sizeDFrameCode;
	
	private int x_offset;
	private int x1_offset;
	private int y1_offset;
	private int x_size;
	private int y_size;
	
	// Code
	private List<String> spriteCode1 = new ArrayList<String>();
	private List<String> spriteCode2 = new ArrayList<String>();
	private int cyclesSpriteCode1;
	private int cyclesSpriteCode2;
	private int sizeSpriteCode1;
	private int sizeSpriteCode2;
	private int sizeDCache, cycleDCache;
	
	// Binary
	private byte[] content;
	private String asmDrawFileName, lstDrawFileName, binDrawFileName;
	private Path asmDFile, lstDFile, binDFile;

	public static void main(String[] args) throws Exception {
		Game.c6809 = "./c6809.exe";
		Configurator.setAllLevels(LogManager.getRootLogger().getName(), Level.DEBUG);
		SimpleAssemblyGenerator asm = new SimpleAssemblyGenerator(new SpriteSheet("test", "./Sonic2/Objects/TitleScreen/Title_008.png", 1, "N"), "./tmp/cs_draw_out", 0);
		asm.compileCode("A000");
		System.out.println("XOffset: "+asm.getX_offset());;
		System.out.println("X1Offset: "+asm.getX1_offset());
		System.out.println("Y1Offset: "+asm.getY1_offset());
		System.out.println("XSize: "+asm.getX_size());
		System.out.println("YSize: "+asm.getY_size());
	}
	
	public SimpleAssemblyGenerator(SpriteSheet spriteSheet, String destDir, int imageNum) throws Exception {
		spriteName = spriteSheet.getName();
		x1_offset = spriteSheet.getSubImageX1Offset(imageNum);
		y1_offset = spriteSheet.getSubImageY1Offset(imageNum);
		x_size = spriteSheet.getSubImageXSize(imageNum);
		y_size = spriteSheet.getSubImageYSize(imageNum);

		logger.debug("Planche:"+spriteSheet.getName()+" image:"+imageNum);
		logger.debug("XOffset: "+getX_offset());;
		logger.debug("X1Offset: "+getX1_offset());
		logger.debug("Y1Offset: "+getY1_offset());
		logger.debug("XSize: "+getX_size());
		logger.debug("YSize: "+getY_size());	
		logger.debug("Center: "+spriteSheet.getCenter());
		
		logger.debug("RAM 0 (val hex 0 à f par pixel, . Transparent):");
		logger.debug(debug80Col(spriteSheet.getSubImagePixels(imageNum, 0)));
		
		destDir += "/"+spriteName;
		asmDrawFileName = destDir+"_Draw.ASM";
		File file = new File (asmDrawFileName);
		file.getParentFile().mkdirs();		
		asmDFile = Paths.get(asmDrawFileName);
		lstDrawFileName = destDir+"_Draw.lst";
		lstDFile = Paths.get(lstDrawFileName);
		binDrawFileName = destDir+"_Draw.BIN";
		binDFile = Paths.get(binDrawFileName);

		// Si l'option d'utilisation du cache est activée et qu'on trouve les fichiers .BIN et .ASM
		// on passe la génération du code de sprite compilé
		if (!(Game.useCache && Files.exists(binDFile) && Files.exists(asmDFile) && Files.exists(lstDFile))) {

			PatternFinder cs = new PatternFinder(spriteSheet.getSubImagePixels(imageNum, 0));
			cs.buildCode(REARWARD);
			Solution solution = cs.getSolutions().get(0);

			PatternCluster cluster = new PatternCluster(solution, spriteSheet.getCenter());
			cluster.cluster(REARWARD);

			SolutionOptim regOpt = new SolutionOptim(solution, spriteSheet.getSubImageData(imageNum, 0), Game.maxTries);
			regOpt.build();

			spriteCode1 = regOpt.getAsmCode();
			cyclesSpriteCode1 = regOpt.getAsmCodeCycles();
			sizeSpriteCode1 = regOpt.getAsmCodeSize();

			logger.debug("RAM 1 (val hex 0  à f par pixel, . Transparent):");
			logger.debug(debug80Col(spriteSheet.getSubImagePixels(imageNum, 1)));

			cs = new PatternFinder(spriteSheet.getSubImagePixels(imageNum, 1));
			cs.buildCode(REARWARD);
			solution = cs.getSolutions().get(0);

			cluster = new PatternCluster(solution, spriteSheet.getCenter());
			cluster.cluster(REARWARD);

			regOpt = new SolutionOptim(solution, spriteSheet.getSubImageData(imageNum, 1), Game.maxTries);
			regOpt.build();

			spriteCode2 = regOpt.getAsmCode();	
			cyclesSpriteCode2 = regOpt.getAsmCodeCycles();
			sizeSpriteCode2 = regOpt.getAsmCodeSize();

			// Calcul des cycles et taille du code de cadre
			cyclesDFrameCode = 0;
			cyclesDFrameCode += getCodeFrameDrawStartCycles();
			cyclesDFrameCode += getCodeFrameDrawMidCycles();
			cyclesDFrameCode += getCodeFrameDrawEndCycles();

			sizeDFrameCode = 0;
			sizeDFrameCode += getCodeFrameDrawStartSize();
			sizeDFrameCode += getCodeFrameDrawMidSize();
			sizeDFrameCode += getCodeFrameDrawEndSize();					
		} else {
			// Utilisation du .BIN existant
			sizeDCache = Files.readAllBytes(Paths.get(binDrawFileName)).length-10;
			// Utilisation du .lst existant
			cycleDCache = C6809Util.countCycles(lstDrawFileName);
		}
	}

	public byte[] getCompiledCode() {
		return content;
	}
		
	public String getDrawBINFile() {
		return binDrawFileName;
	}
	
	public void compileCode(String org) {		
		try
		{
			Pattern pt = Pattern.compile("[ \t]*ORG[ \t]*\\$[a-fA-F0-9]{4}");
			Process pr;
			BufferedReader br;
			String line;
			File f;
			
			// Process Draw Code
			// ****************************************************************			
			if (!(Game.useCache && Files.exists(binDFile) && Files.exists(asmDFile) && Files.exists(lstDFile))) {
				Files.deleteIfExists(asmDFile);
				Files.createFile(asmDFile);

				Files.write(asmDFile, getCodeFrameDrawStart("IMGD.ASM", org), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmDFile, spriteCode2, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmDFile, getCodeFrameDrawMid(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmDFile, spriteCode1, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmDFile, getCodeFrameDrawEnd(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			} else {
				// change ORG adress in existing ASM file
				String str = new String(Files.readAllBytes(asmDFile), StandardCharsets.UTF_8);
				Matcher m = pt.matcher(str);
				if (m.find()) {
				    str = m.replaceFirst("\tORG \\$"+org);
				}
				Files.write(asmDFile, str.getBytes(StandardCharsets.UTF_8));
			}

			// Delete binary file
			Files.deleteIfExists(binDFile);

			// Generate binary code from assembly code
			pr = new ProcessBuilder(Game.c6809, "-bl", asmDrawFileName, binDrawFileName).start();
			br = new BufferedReader(new InputStreamReader(pr.getErrorStream()));

			while((line=br.readLine())!=null){
				logger.debug(line);
			}
			pr.waitFor();

			// Load binary code
			content = Files.readAllBytes(Paths.get(binDrawFileName));	

			// Rename .lst File
			f = new File("codes.lst"); 
			Files.deleteIfExists(lstDFile);
			f.renameTo(new File(lstDrawFileName));

			// Compte le nombre de cycles du .lst
			int compilerDCycles = C6809Util.countCycles(lstDrawFileName);
			int compilerDSize = content.length - 10;			
			int computedDCycles = getDCycles();
			int computedDSize = getDSize();
			logger.debug(lstDrawFileName + " c6809.exe DRAW cycles: " + compilerDCycles + " computed cycles: " + computedDCycles);
			logger.debug(lstDrawFileName + " c6809.exe DRAW size: " + compilerDSize + " computed size: " + computedDSize);

			if (computedDCycles != compilerDCycles || compilerDSize != computedDSize) {
				logger.fatal(lstDrawFileName + " Ecart de cycles ou de taille entre la version Draw compilée par c6809 et la valeur calculée par le générateur de code.", new Exception("Prérequis."));
			}
			
			if (compilerDSize > 16384) {
				logger.fatal(lstDrawFileName + " Le code généré ("+compilerDSize+" octets) dépasse la taille d'une page", new Exception("Prérequis."));
			}			
		} 
		catch (Exception e)
		{
			e.printStackTrace(); 
			System.out.println(e); 
		}
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

	public List<String> getCodeFrameDrawStart(String fileName, String org) {
		List<String> asm = new ArrayList<String>();
		asm.add("(main)" + fileName + "");
		asm.add("\tORG $" + org + "");
		asm.add("\tSETDP $FF");
		asm.add("DRAW_" + spriteName + "");
		//asm.add("\tSTS SSAV_" + spriteName + "+1,PCR\n");
		asm.add("\tSTD DYN_POS+2,PCR");		
		asm.add("\tLEAS ,U");		
		asm.add("\tLDU ,Y");
		return asm;
	}

	public int getCodeFrameDrawStartCycles() {
		int cycles = 0;
		//cycles += Register.costIndexedST[Register.S]+Register.costIndexedOffsetPCR;
		cycles += Register.costIndexedST[Register.D]+Register.costIndexedOffsetPCR;
		cycles += Register.costIndexedLEA;
		cycles += Register.costIndexedLD[Register.U];
		return cycles;
	}

	public int getCodeFrameDrawStartSize() {
		int size = 0;
		//size += Register.sizeIndexedST[Register.S]+Register.sizeIndexedOffsetPCR;
		size += Register.sizeIndexedST[Register.D]+Register.sizeIndexedOffsetPCR;		
		size += Register.sizeIndexedLEA;
		size += Register.sizeIndexedLD[Register.U];
		return size;
	}

	public List<String> getCodeFrameDrawMid() {
		List<String> asm = new ArrayList<String>();
		asm.add("DYN_POS");
		asm.add("\n\tLDU #$0000");		
		return asm;
	}

	public int getCodeFrameDrawMidCycles() {
		int cycles = 0;
		cycles += Register.costImmediateLD[Register.U];
		return cycles;
	}

	public int getCodeFrameDrawMidSize() {
		int size = 0;
		size += Register.costImmediateLD[Register.U];
		return size;
	}

	public List<String> getCodeFrameDrawEnd() {
		List<String> asm = new ArrayList<String>();
		//asm.add("SSAV_" + spriteName + "");
		//asm.add("\tLDS #$0000");
		asm.add("\tRTS\n");
		asm.add("(info)\n");
		return asm;
	}

	public int getCodeFrameDrawEndCycles() {
		int cycles = 0;
		//cycles += Register.costImmediateLD[Register.S];
		cycles += 5; // RTS
		return cycles;
	}

	public int getCodeFrameDrawEndSize() {
		int size = 0;
		//size += Register.sizeImmediateLD[Register.S];
		size += 1; // RTS
		return size;
	}

	public int getDCycles() {
		return cyclesDFrameCode + cyclesSpriteCode1 + cyclesSpriteCode2 + cycleDCache;
	}

	public int getDSize() {
		return sizeDFrameCode + sizeSpriteCode1 + sizeSpriteCode2 + sizeDCache;
	}

	public int getX_offset() {
		return x_offset;
	}

	public int getX1_offset() {
		return x1_offset;
	}	
	
	public int getY1_offset() {
		return y1_offset;
	}

	public int getX_size() {
		return x_size;
	}

	public int getY_size() {
		return y_size;
	}	
}
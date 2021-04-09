package fr.bento8.to8.compiledSprite.backupDrawErase;

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

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import fr.bento8.to8.InstructionSet.Register;
import fr.bento8.to8.build.BuildDisk;
import fr.bento8.to8.image.SpriteSheet;
import fr.bento8.to8.util.LWASMUtil;

public class AssemblyGenerator{

	private static final Logger logger = LogManager.getLogger("log");

	boolean FORWARD = true;
	public String spriteName;
	public boolean spriteCenterEven;
	private int cyclesDFrameCode;
	private int sizeDFrameCode;
	private int cyclesEFrameCode;
	private int sizeEFrameCode;
	
	private int x1_offset;
	private int y1_offset;
	private int x_size;
	private int y_size;

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
	private int sizeDCache, cycleDCache, sizeECache, cycleECache;
	
	// Binary
	private byte[] content;
	private String asmBckDrawFileName, lstBckDrawFileName, binBckDrawFileName;
	private String asmEraseFileName, lstEraseFileName, binEraseFileName;
	private Path asmDFile, lstDFile, binDFile;
	private Path asmEFile, lstEFile, binEFile;	

	public AssemblyGenerator(SpriteSheet spriteSheet, String destDir, int imageNum) throws Exception {
		spriteName = spriteSheet.getName();
		spriteCenterEven = (spriteSheet.center % 2) == 0;
		x1_offset = spriteSheet.getSubImageX1Offset(imageNum);
		y1_offset = spriteSheet.getSubImageY1Offset(imageNum);
		x_size = spriteSheet.getSubImageXSize(imageNum);
		y_size = spriteSheet.getSubImageYSize(imageNum);

		logger.debug("\t\t\tPlanche:"+spriteSheet.getName()+" "+spriteSheet.variant+" image:"+imageNum);
		logger.debug("\t\t\tX1Offset: "+getX1_offset());
		logger.debug("\t\t\tY1Offset: "+getY1_offset());
		logger.debug("\t\t\tXSize: "+getX_size());
		logger.debug("\t\t\tYSize: "+getY_size());		
		logger.debug("\t\t\tCenter: "+spriteSheet.getCenter());
		
		destDir += "/"+spriteName;
		asmBckDrawFileName = destDir+"_"+spriteSheet.variant+".asm";
		File file = new File (asmBckDrawFileName);
		file.getParentFile().mkdirs();		
		asmDFile = Paths.get(asmBckDrawFileName);
		lstBckDrawFileName = destDir+"_"+spriteSheet.variant+".lst";
		lstDFile = Paths.get(lstBckDrawFileName);
		binBckDrawFileName = destDir+"_"+spriteSheet.variant+".bin";
		binDFile = Paths.get(binBckDrawFileName);
		
		asmEraseFileName = destDir+"_"+spriteSheet.variant+"_Erase.asm";
		asmEFile = Paths.get(asmEraseFileName);
		lstEraseFileName = destDir+"_"+spriteSheet.variant+"_Erase.lst";
		lstEFile = Paths.get(lstEraseFileName);
		binEraseFileName = destDir+"_"+spriteSheet.variant+"_Erase.bin";
		binEFile = Paths.get(binEraseFileName);

		// Si l'option d'utilisation du cache est activée et qu'on trouve les fichiers .BIN et .ASM
		// on passe la génération du code de sprite compilé
		if (!(BuildDisk.game.useCache && Files.exists(binDFile) && Files.exists(asmDFile) && Files.exists(lstDFile) && Files.exists(binEFile) && Files.exists(asmEFile) && Files.exists(lstEFile))) {
			
			//logger.debug("RAM 0 (val hex 0 à f par pixel, . Transparent):");
			//if (logger.isDebugEnabled())
			//	logger.debug(debug80Col(spriteSheet.getSubImagePixels(imageNum, 0)));			

			PatternFinder cs = new PatternFinder(spriteSheet.getSubImagePixels(imageNum, 0));
			cs.buildCode(FORWARD);
			Solution solution = cs.getSolutions().get(0);

			PatternCluster cluster = new PatternCluster(solution, spriteSheet.getCenter());
			cluster.cluster(FORWARD);

			SolutionOptim regOpt = new SolutionOptim(solution, spriteSheet.getSubImageData(imageNum, 0), BuildDisk.game.maxTries);
			regOpt.build();

			spriteCode1 = regOpt.getAsmCode();
			cyclesSpriteCode1 = regOpt.getAsmCodeCycles();
			sizeSpriteCode1 = regOpt.getAsmCodeSize();

			spriteECode1 = regOpt.getAsmECode();
			cyclesSpriteECode1 = regOpt.getAsmECodeCycles();
			sizeSpriteECode1 = regOpt.getAsmECodeSize();

			sizeSpriteEData1 = regOpt.getDataSize();

			logger.debug("\t\t\tTaille de la zone data 1: "+sizeSpriteEData1);
			//logger.debug("RAM 1 (val hex 0  à f par pixel, . Transparent):");
			//if (logger.isDebugEnabled())			
			//	logger.debug(debug80Col(spriteSheet.getSubImagePixels(imageNum, 1)));

			cs = new PatternFinder(spriteSheet.getSubImagePixels(imageNum, 1));
			cs.buildCode(FORWARD);
			solution = cs.getSolutions().get(0);

			cluster = new PatternCluster(solution, spriteSheet.getCenter());
			cluster.cluster(FORWARD);

			regOpt = new SolutionOptim(solution, spriteSheet.getSubImageData(imageNum, 1), BuildDisk.game.maxTries);
			regOpt.build();

			spriteCode2 = regOpt.getAsmCode();	
			cyclesSpriteCode2 = regOpt.getAsmCodeCycles();
			sizeSpriteCode2 = regOpt.getAsmCodeSize();

			spriteECode2 = regOpt.getAsmECode();
			cyclesSpriteECode2 = regOpt.getAsmECodeCycles();
			sizeSpriteECode2 = regOpt.getAsmECodeSize();

			sizeSpriteEData2 = regOpt.getDataSize();

			logger.debug("\t\t\tTaille de la zone data 2: "+sizeSpriteEData2);

			// Calcul des cycles et taille du code de cadre
			cyclesDFrameCode = 0;
			cyclesDFrameCode += getCodeFrameBckDrawStartCycles();
			cyclesDFrameCode += getCodeFrameBckDrawMidCycles();
			cyclesDFrameCode += getCodeFrameBckDrawEndCycles();

			sizeDFrameCode = 0;
			sizeDFrameCode += getCodeFrameBckDrawStartSize();
			sizeDFrameCode += getCodeFrameBckDrawMidSize();
			sizeDFrameCode += getCodeFrameBckDrawEndSize();			
			
			cyclesEFrameCode = 0;
			cyclesEFrameCode += getCodeFrameEraseStartCycles();			
			cyclesEFrameCode += getCodeFrameEraseEndCycles();

			sizeEFrameCode = 0;
			sizeEFrameCode += getCodeFrameEraseStartSize();			
			sizeEFrameCode += getCodeFrameEraseEndSize();			
		} else {
			// Utilisation du .BIN existant
			sizeDCache = Files.readAllBytes(Paths.get(binBckDrawFileName)).length;
			// Utilisation du .lst existant
			cycleDCache = LWASMUtil.countCycles(lstBckDrawFileName);
			
			// Utilisation du .BIN existant
			sizeECache = Files.readAllBytes(Paths.get(binEraseFileName)).length;
			// Utilisation du .lst existant
			cycleECache = LWASMUtil.countCycles(lstEraseFileName);		
			
			// Lecture de la taille des données de la routine erase
			Path path = Paths.get(lstEraseFileName);
			String content = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);
			
			Pattern pn = Pattern.compile("(Equ)\\s*([0-9a-fA-F]*)\\sDataSize") ;  
			Matcher m = pn.matcher(content);

			while (m.find()) {
				sizeSpriteEData1=Integer.parseInt(m.group(2), 16);			
			}
		}
	}

	public byte[] getCompiledCode() {
		return content;
	}
		
	public String getBckDrawBINFile() {
		return binBckDrawFileName;
	}

	public String getEraseBINFile() {
		return binEraseFileName;
	}		

	public String getDrawBINFile() {
		return binBckDrawFileName;
	}
	
	public void compileCode(String org) {		
		try
		{
			Pattern pt = Pattern.compile("[ \t]*ORG[ \t]*\\$[a-fA-F0-9]{4}");
			Process p;
			ProcessBuilder pb;
			BufferedReader br;
			String line;
			
			// Process BckDraw Code
			// ****************************************************************			
			if (!(BuildDisk.game.useCache && Files.exists(binDFile) && Files.exists(asmDFile) && Files.exists(lstDFile))) {
				Files.deleteIfExists(asmDFile);
				Files.createFile(asmDFile);

				Files.write(asmDFile, getCodeFrameBckDrawStart(org), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmDFile, spriteCode1, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmDFile, getCodeFrameBckDrawMid(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmDFile, spriteCode2, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmDFile, getCodeFrameBckDrawEnd(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
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
			pb = new ProcessBuilder(BuildDisk.game.lwasm, asmBckDrawFileName, "--output=" + binBckDrawFileName, "--list=" + lstBckDrawFileName, "--6809", "--pragma=undefextern,autobranchlength", "--raw");
			pb.redirectErrorStream(true);
			p = pb.start();			
			br = new BufferedReader(new InputStreamReader(p.getInputStream()));

			while((line=br.readLine())!=null){
				logger.debug("\t\t\t" + line);
			}
			p.waitFor();

			// Load binary code
			content = Files.readAllBytes(Paths.get(binBckDrawFileName));	

			// Compte le nombre de cycles du .lst
			int compilerDCycles = LWASMUtil.countCycles(lstBckDrawFileName);
			int compilerDSize = content.length;			
			int computedDCycles = getDCycles();
			int computedDSize = getDSize();
			logger.debug("\t\t\t" +lstBckDrawFileName + " lwasm.exe BCKDRAW cycles: " + compilerDCycles + " computed cycles: " + computedDCycles);
			logger.debug("\t\t\t" +lstBckDrawFileName + " lwasm.exe BCKDRAW size: " + compilerDSize + " computed size: " + computedDSize);

			if (computedDCycles != compilerDCycles || compilerDSize != computedDSize) {
				logger.fatal("\t\t\t" +lstBckDrawFileName + " Ecart de cycles ou de taille entre la version BckDraw compilée par lwasm et la valeur calculée par le générateur de code.", new Exception("Prérequis."));
			}
			
			if (compilerDSize > 16384) {
				logger.fatal("\t\t\t" +lstBckDrawFileName + " Le code généré ("+compilerDSize+" octets) dépasse la taille d'une page", new Exception("Prérequis."));
			}			

			// Process Erase Code
			// ****************************************************************
			if (!(BuildDisk.game.useCache && Files.exists(binEFile) && Files.exists(asmEFile) && Files.exists(lstEFile))) {
				Files.deleteIfExists(asmEFile);
				Files.createFile(asmEFile);
				
				List<String> dataSize = new ArrayList<String>();
				dataSize.add(String.format("DataSize equ $%1$04X", getEraseDataSize() & 0xFFFF));
				
				Files.write(asmEFile, getCodeFrameEraseStart(org), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmEFile, spriteECode2, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmEFile, spriteECode1, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmEFile, getCodeFrameEraseEnd(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmEFile, dataSize, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			} else {
				// change ORG adress in existing ASM file
				String str = new String(Files.readAllBytes(asmEFile), StandardCharsets.UTF_8);
				Matcher m = pt.matcher(str);
				if (m.find()) {
				    str = m.replaceFirst("\tORG \\$"+org);
				}
				Files.write(asmEFile, str.getBytes(StandardCharsets.UTF_8));
			}			
			
			// Delete binary file
			Files.deleteIfExists(binEFile);

			// Generate binary code from assembly code
			pb = new ProcessBuilder(BuildDisk.game.lwasm, asmEraseFileName, "--output=" + binEraseFileName, "--list=" + lstEraseFileName, "--6809", "--pragma=undefextern,autobranchlength", "--raw");			
			pb.redirectErrorStream(true);
			p = pb.start();					
			br = new BufferedReader(new InputStreamReader(p.getInputStream()));
			
			while((line=br.readLine())!=null){
				logger.debug("\t\t\t" +line);
			}
			p.waitFor();

			// Load binary code
			content = Files.readAllBytes(Paths.get(binEraseFileName));	

			// Compte le nombre de cycles du .lst
			int compilerECycles = LWASMUtil.countCycles(lstEraseFileName);
			int compilerESize = content.length;
			int computedECycles = getECycles();
			int computedESize = getESize();
			logger.debug("\t\t\t" +lstEraseFileName + " lwasm.exe ERASE cycles: " + compilerECycles + " computed cycles: " + computedECycles);
			logger.debug("\t\t\t" +lstEraseFileName + " lwasm.exe ERASE size: " + compilerESize + " computed size: " + computedESize);

			if (computedECycles != compilerECycles || compilerESize != computedESize) {
				logger.fatal("\t\t\t" +lstEraseFileName + " Ecart de cycles ou de taille entre la version compilée par lwasm et la valeur calculée par le générateur de code.", new Exception("Prérequis."));
			}
			
			if (compilerDSize > 16384) {
				logger.fatal("\t\t\t" +lstBckDrawFileName + " Le code généré ("+compilerDSize+" octets) dépasse la taille d'une page", new Exception("Prérequis."));
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

	public List<String> getCodeFrameBckDrawStart(String org) {
		List<String> asm = new ArrayList<String>();
		asm.add("\tORG $" + org + "");
		asm.add("\tSETDP $FF");
		asm.add("\tOPT C,CT");
		asm.add("BCKDRAW_" + spriteName + "");
		asm.add("\tSTS SSAV_" + spriteName + "+1,PCR\n");
		asm.add("\tSTD DYN_POS+1,PCR");
		asm.add("\tLEAS ,U");
		asm.add("\tLDU ,Y");

		return asm;
	}

	public int getCodeFrameBckDrawStartCycles() {
		int cycles = 0;
		cycles += Register.costIndexedST[Register.S]+Register.costIndexedOffsetPCR;
		cycles += Register.costIndexedST[Register.D]+Register.costIndexedOffsetPCR;
		cycles += Register.costIndexedLEA;
		cycles += Register.costIndexedLD[Register.U];
		return cycles;
	}

	public int getCodeFrameBckDrawStartSize() {
		int size = 0;
		size += Register.sizeIndexedST[Register.S]+Register.sizeIndexedOffsetPCR;
		size += Register.sizeIndexedST[Register.D]+Register.sizeIndexedOffsetPCR;
		size += Register.sizeIndexedLEA;		
		size += Register.sizeIndexedLD[Register.U];
		return size;
	}

	public List<String> getCodeFrameBckDrawMid() {
		List<String> asm = new ArrayList<String>();
		asm.add("DYN_POS");
		asm.add("\n\tLDU #$0000");		
		return asm;
	}

	public int getCodeFrameBckDrawMidCycles() {
		int cycles = 0;
		cycles += Register.costImmediateLD[Register.U];
		return cycles;
	}

	public int getCodeFrameBckDrawMidSize() {
		int size = 0;
		size += Register.costImmediateLD[Register.U];
		return size;
	}

	public List<String> getCodeFrameBckDrawEnd() {
		List<String> asm = new ArrayList<String>();
		asm.add("\tLEAU ,S");
		asm.add("SSAV_" + spriteName + "");
		asm.add("\tLDS #$0000");
		asm.add("\tRTS\n");
		return asm;
	}

	public int getCodeFrameBckDrawEndCycles() {
		int cycles = 0;
		cycles += Register.costIndexedLEA;
		cycles += Register.costImmediateLD[Register.S];
		cycles += 5; // RTS
		return cycles;
	}

	public int getCodeFrameBckDrawEndSize() {
		int size = 0;
		size += Register.sizeIndexedLEA;
		size += Register.sizeImmediateLD[Register.S];
		size += 1; // RTS
		return size;
	}

	public List<String> getCodeFrameEraseStart(String org) {
		List<String> asm = new ArrayList<String>();
		asm.add("\tORG $" + org + "");
		asm.add("\tSETDP $FF");
		asm.add("\tOPT C,CT");		
		asm.add("ERASE_" + spriteName + "");
		asm.add("\tSTS ERASE_SSAV_" + spriteName + "+1,PCR\n");
		asm.add("\tLEAS ,U");
		asm.add("ERASE_CODE_" + spriteName + "_1");
		return asm;
	}

	public int getCodeFrameEraseStartCycles() {
		int cycles = 0;
		cycles += Register.costIndexedST[Register.S]+Register.costIndexedOffsetPCR;
		cycles += Register.costIndexedLEA;
		return cycles;
	}

	public int getCodeFrameEraseStartSize() {
		int size = 0;
		size += Register.sizeIndexedST[Register.S]+Register.sizeIndexedOffsetPCR;
		size += Register.sizeIndexedLEA;	
		return size;
	}	
	
	public List<String> getCodeFrameEraseEnd() {
		List<String> asm = new ArrayList<String>();
		asm.add("\tLEAU ,S");
		asm.add("ERASE_SSAV_" + spriteName + "");
		asm.add("\tLDS #$0000");
		asm.add("\tRTS\n");
		return asm;
	}

	public int getCodeFrameEraseEndCycles() {
		int cycles = 0;
		cycles += Register.costIndexedLEA;
		cycles += Register.costImmediateLD[Register.S];
		cycles += 5; // RTS
		return cycles;
	}

	public int getCodeFrameEraseEndSize() {
		int size = 0;
		size += Register.sizeIndexedLEA;
		size += Register.sizeImmediateLD[Register.S];	
		size += 1; // RTS
		return size;
	}

	public int getDCycles() {
		return cyclesDFrameCode + cyclesSpriteCode1 + cyclesSpriteCode2 + cycleDCache;
	}

	public int getDSize() {
		return sizeDFrameCode + sizeSpriteCode1 + sizeSpriteCode2 + sizeDCache;
	}
	
	public int getECycles() {
		return cyclesEFrameCode + cyclesSpriteECode1 + cyclesSpriteECode2 + cycleECache;
	}

	public int getESize() {
		return sizeEFrameCode + sizeSpriteECode1 + sizeSpriteECode2 + sizeECache;
	}

	public int getSizeData1() {
		return sizeSpriteEData1;
	}

	public int getSizeData2() {
		return sizeSpriteEData2;
	}
	
	public int getEraseDataSize() {
		return sizeSpriteEData1+sizeSpriteEData2;
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
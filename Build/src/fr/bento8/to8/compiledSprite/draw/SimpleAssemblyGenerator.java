package fr.bento8.to8.compiledSprite.draw;

import java.io.BufferedReader;
import java.io.File;
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
import fr.bento8.to8.build.Game;
import fr.bento8.to8.image.SpriteSheet;
import fr.bento8.to8.util.LWASMUtil;

public class SimpleAssemblyGenerator{

	private static final Logger logger = LogManager.getLogger("log");

	boolean FORWARD = true;
	boolean REARWARD = false;
	public String spriteName;
	public boolean spriteCenterEven;
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
	
	public static void main(String[] args) throws Throwable {
		
		// Unit Test or single image conversion
		// ------------------------------------
		// command line arguments
		//
		// 0: png file name
		// 1: mode (comma separated)
		//            NB0  : no flip, background backup / draw / erase compilated sprite, no x offset
		//            ND0  : no flip, draw compilated sprite, no x offset
		//            NB1  : no flip, background backup / draw / erase compilated sprite, 1px x offset
		//            ND1  : no flip, draw compilated sprite, 1px x offset
		//            XB0  : x flip, background backup / draw / erase compilated sprite, no x offset 
		//            XD0  : x flip, draw compilated sprite, no x offset 
		//            XB1  : x flip, background backup / draw / erase compilated sprite, 1px x offset 
		//            XD1  : x flip, draw compilated sprite, 1px x offset 
		//            YB0  : y flip, background backup / draw / erase compilated sprite, no x offset 
		//            YD0  : y flip, draw compilated sprite, no x offset 
		//            YB1  : y flip, background backup / draw / erase compilated sprite, 1px x offset 
		//            YD1  : y flip, draw compilated sprite, 1px x offset 
		//            XYB0 : xy flip, background backup / draw / erase compilated sprite, no x offset 
		//            XYD0 : xy flip, draw compilated sprite, no x offset 
		//            XYB1 : xy flip, background backup / draw / erase compilated sprite, 1px x offset 
		//            XYD1 : xy flip, draw compilated sprite, 1px x offset
		// 2: output dir
		// 3: sprite name
		// 4: config file
		
		BuildDisk.loadGameConfiguration(args[4]);
		SpriteSheet ss = new SpriteSheet(args[3], args[0], 1, args[1]);
		SimpleAssemblyGenerator sasm = new SimpleAssemblyGenerator(ss, args[2]+args[3], 0);
		sasm.compileCode("A000");
	}

	public SimpleAssemblyGenerator(SpriteSheet spriteSheet, String destDir, int imageNum) throws Exception {
		spriteCenterEven = (spriteSheet.center % 2) == 0;
		spriteName = spriteSheet.getName();
		x1_offset = spriteSheet.getSubImageX1Offset(imageNum);
		y1_offset = spriteSheet.getSubImageY1Offset(imageNum);
		x_size = spriteSheet.getSubImageXSize(imageNum);
		y_size = spriteSheet.getSubImageYSize(imageNum);

		logger.debug("\t\t\tPlanche:"+spriteSheet.getName()+" image:"+imageNum);
		logger.debug("\t\t\tXOffset: "+getX_offset());;
		logger.debug("\t\t\tX1Offset: "+getX1_offset());
		logger.debug("\t\t\tY1Offset: "+getY1_offset());
		logger.debug("\t\t\tXSize: "+getX_size());
		logger.debug("\t\t\tYSize: "+getY_size());	
		logger.debug("\t\t\tCenter: "+spriteSheet.getCenter());
		
		destDir += "/"+spriteName;
		asmDrawFileName = destDir+"_"+spriteSheet.variant+".asm";
		File file = new File (asmDrawFileName);
		file.getParentFile().mkdirs();		
		asmDFile = Paths.get(asmDrawFileName);
		lstDrawFileName = destDir+"_"+spriteSheet.variant+".lst";
		lstDFile = Paths.get(lstDrawFileName);
		binDrawFileName = destDir+"_"+spriteSheet.variant+".bin";
		binDFile = Paths.get(binDrawFileName);

		// Si l'option d'utilisation du cache est activ�e et qu'on trouve les fichiers .bin et .asm
		// on passe la g�n�ration du code de sprite compil�
		if (!(BuildDisk.game.useCache && Files.exists(binDFile) && Files.exists(asmDFile) && Files.exists(lstDFile))) {

			//logger.debug("RAM 0 (val hex 0 � f par pixel, . Transparent):");
			//if (logger.isDebugEnabled())
				//logger.debug(debug80Col(spriteSheet.getSubImagePixels(imageNum, 0)));
			
			PatternFinder cs = new PatternFinder(spriteSheet.getSubImagePixels(imageNum, 0));
			cs.buildCode(REARWARD);
			Solution solution = cs.getSolutions().get(0);

			PatternCluster cluster = new PatternCluster(solution, spriteSheet.getCenter());
			cluster.cluster(REARWARD);

			SolutionOptim regOpt = new SolutionOptim(solution, spriteSheet.getSubImageData(imageNum, 0), BuildDisk.game.maxTries);
			regOpt.build();

			spriteCode1 = regOpt.getAsmCode();
			cyclesSpriteCode1 = regOpt.getAsmCodeCycles();
			sizeSpriteCode1 = regOpt.getAsmCodeSize();

			//logger.debug("\t\t\tRAM 1 (val hex 0  � f par pixel, . Transparent):");
			//if (logger.isDebugEnabled())
				//logger.debug(debug80Col(spriteSheet.getSubImagePixels(imageNum, 1)));

			cs = new PatternFinder(spriteSheet.getSubImagePixels(imageNum, 1));
			cs.buildCode(REARWARD);
			solution = cs.getSolutions().get(0);

			cluster = new PatternCluster(solution, spriteSheet.getCenter());
			cluster.cluster(REARWARD);

			regOpt = new SolutionOptim(solution, spriteSheet.getSubImageData(imageNum, 1), BuildDisk.game.maxTries);
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
			sizeDCache = Files.readAllBytes(Paths.get(binDrawFileName)).length;
			// Utilisation du .lst existant
			cycleDCache = LWASMUtil.countCycles(lstDrawFileName);
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
			Process p;
			ProcessBuilder pb;
			BufferedReader br;
			String line;
			
			// Process Draw Code
			// ****************************************************************			
			if (!(BuildDisk.game.useCache && Files.exists(binDFile) && Files.exists(asmDFile) && Files.exists(lstDFile))) {
				Files.deleteIfExists(asmDFile);
				Files.createFile(asmDFile);

				Files.write(asmDFile, getCodeFrameDrawStart(org), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmDFile, spriteCode1, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmDFile, getCodeFrameDrawMid(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(asmDFile, spriteCode2, Charset.forName("UTF-8"), StandardOpenOption.APPEND);
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
			
			List<String> command = new ArrayList<>(List.of(BuildDisk.game.lwasm,
					asmDrawFileName,
					   "--output=" + binDrawFileName,
					   "--list=" + lstDrawFileName,
					   "--6809",	
					   "--includedir=.",
					   "--raw",
					   Game.pragma				   
					   ));
			
			if (Game.define != null && Game.define.length()>0) command.add(Game.define);
				
			p = new ProcessBuilder(command).inheritIO().start();
			
			int result = p.waitFor();


			// Load binary code
			content = Files.readAllBytes(Paths.get(binDrawFileName));	

			// Compte le nombre de cycles du .lst
			int compilerDCycles = LWASMUtil.countCycles(lstDrawFileName);
			int compilerDSize = content.length;			
			int computedDCycles = getDCycles();
			int computedDSize = getDSize();
			logger.debug("\t\t\t" +lstDrawFileName + " lwasm.exe DRAW cycles: " + compilerDCycles + " computed cycles: " + computedDCycles);
			logger.debug("\t\t\t" +lstDrawFileName + " lwasm.exe DRAW size: " + compilerDSize + " computed size: " + computedDSize);

			if (computedDCycles != compilerDCycles || compilerDSize != computedDSize) {
				throw new Exception("\t\t\t" +lstDrawFileName + " Ecart de cycles ou de taille entre la version Draw compil�e par lwasm et la valeur calcul�e par le g�n�rateur de code.", new Exception("Pr�requis."));
			}
			
			if (compilerDSize > 16384) {
				throw new Exception("\t\t\t" +lstDrawFileName + " Le code g�n�r� ("+compilerDSize+" octets) d�passe la taille d'une page", new Exception("Pr�requis."));
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

	public List<String> getCodeFrameDrawStart(String org) {
		List<String> asm = new ArrayList<String>();
		asm.add("\tINCLUDE \"../../Engine/Constants.asm\"");		
		asm.add("\tORG $" + org + "");
		asm.add("\tSETDP $FF");
		asm.add("\tOPT C,CT");		
		asm.add("DRAW_" + spriteName + "");
		asm.add("\tLDU ,Y");
		return asm;
	}

	public int getCodeFrameDrawStartCycles() throws Exception {
		int cycles = 0;
		cycles += Register.costIndexedLD[Register.U];
		return cycles;
	}

	public int getCodeFrameDrawStartSize() throws Exception {
		int size = 0;
		size += Register.sizeIndexedLD[Register.U];
		return size;
	}

	public List<String> getCodeFrameDrawMid() {
		List<String> asm = new ArrayList<String>();
		asm.add("\n\tLDU Glb_Sprite_Screen_Pos_Part1");		
		return asm;
	}

	public int getCodeFrameDrawMidCycles() {
		int cycles = 0;
		cycles += Register.costExtendedST[Register.U];
		return cycles;
	}

	public int getCodeFrameDrawMidSize() {
		int size = 0;
		size += Register.sizeExtendedST[Register.U];
		return size;
	}

	public List<String> getCodeFrameDrawEnd() {
		List<String> asm = new ArrayList<String>();
		asm.add("\tRTS\n");
		return asm;
	}

	public int getCodeFrameDrawEndCycles() {
		int cycles = 0;
		cycles += 5; // RTS
		return cycles;
	}

	public int getCodeFrameDrawEndSize() {
		int size = 0;
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
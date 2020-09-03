package fr.bento8.to8.build;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.regex.Pattern;

import fr.bento8.to8.boot.Bootloader;
import fr.bento8.to8.compiledSprite.PatternCluster;
import fr.bento8.to8.compiledSprite.CompiledSpriteModeB16;
import fr.bento8.to8.compiledSprite.PatternFinder;
import fr.bento8.to8.compiledSprite.RegisterOptim;
import fr.bento8.to8.disk.FdUtil;
import fr.bento8.to8.image.PngToBottomUpBinB16;
import fr.bento8.to8.image.SpriteSheet;
import fr.bento8.to8.util.knapsack.Item;
import fr.bento8.to8.util.knapsack.Knapsack;
import fr.bento8.to8.util.knapsack.Solution;

public class BuildDisk
{
	private static String tmpFile = "TMP.BIN";
	private static String bootFile;
	private static String mainFile;
	private static String outputFileName;
	private static String tmpDirName;
	private static String compiler;
	private static String drawDirection;
	private static boolean isForward;
	private static String animationTag;
	private static String memoryPages;
	private static int[] pages;
	private static HashMap<String, String[]> animationImages;
	private static HashMap<String, String[]> animationScripts;
	private static String initVideoFile;

	/**
	 * Génère une image de disquette dans les formats .fd et .sd pour 
	 * l'ordinateur Thomson TO8.
	 * L'image de disquette contient un secteur d'amorçage et le code
	 * principal qui sera chargé en mémoire par le code d'amorçage.
	 * Ce programme n'utilise donc pas de système de fichier.
	 * 
	 * Plan d'adressage d'une disquette Thomson TO8 ou format .fd (655360 octets ou 640kiB)
	 * Identifiant des faces: 0-1
	 * Pour chaque face, identifiant des pistes: 0-79
	 * Pour chaque piste, identifiant des secteurs: 1-16
	 * Taille d'un secteur: 256 octets
	 * face=0 piste=0 secteur=1 : octets=0 à 127 (Secteur d'amorçage)
	 * face=0 piste=0 secteur=2 : octets=256 à 16383 (Main ASM)
	 * face=0 piste=4 secteur=1 : octets=16384 à 32767 (init video)
	 * face=0 piste=8 secteur=1 : octets=32768 à x (Pages)
	 * 
	 * Le format .sd (1310720 octets ou 1,25MiB) reprend la même structure que le format .fd mais ajoute
	 * 256 octets à la fin de chaque secteur avec la valeur FF
	 * 
	 * Remarque il est posible dans un fichier .fd ou .sd de concaténer deux disquettes
	 * Cette fonctionnalité n'est pas implémentée ici.
	 * 
	 * 	Mode graphique utilisé: 160x200 (seize couleurs sans contraintes)
	 * 
	 * @param args nom du fichier properties contenant les données de configuration
	 * @throws Exception 
	 */
	public static void main(String[] args) throws Exception
	{
		byte[] binary;
		int nbAllSubImages=0, nbSpriteSheets=0;
		int face=0, track=0, sector=1;
		HashMap<String, String[]> compiledImages = new HashMap<String, String[]>();
		HashMap<String, String> imageAddress = new HashMap<String, String>();

		readProperties(args[0]); // Chargement du fichier de configuration

		FdUtil fd = new FdUtil(); // Initialisation de l'image de disquette en sortie

		if (compile(bootFile) == 0) { // Compilation du code d'initialisation (boot)

			Bootloader bootLoader = new Bootloader(); // Traitement du binaire issu de la compilation et génération du secteur d'amorçage
			byte[] bootLoaderBytes = bootLoader.encodeBootLoader(tmpFile);

			fd.setIndex(0, 0, 1);
			fd.write(bootLoaderBytes);

			PngToBottomUpBinB16 initVideo = new PngToBottomUpBinB16(initVideoFile); // Traitement de l'image pour l'écran de démarrage
			byte[] initVideoBIN = initVideo.getBIN();

			fd.setIndex(0, 4, 1);
			fd.write(initVideoBIN);

			// Génération des sprites compilés et organisation en pages de 16Ko par l'algorithme du sac à dos
			for (String[] line : animationImages.values())
			{
				nbAllSubImages += Integer.parseInt(line[5]); // Compte le nombre total d'images toutes planches confondues (.png)
				nbSpriteSheets++; // Compte le nombre de planches
			}

			Item[] items = new Item[nbAllSubImages]; // initialise un item pour chaque image
			SpriteSheet[] spriteSheets = new SpriteSheet[nbSpriteSheets]; // tableau contenant tous les planches de sprites
			
			int index=0;
			for (String[] i : animationImages.values()) {
				spriteSheets[index++] = new SpriteSheet(i[4], Integer.parseInt(i[5]), i[6]);
			}
			
			for (SpriteSheet spriteSheet : spriteSheets) {
				for (index = 0; index < spriteSheet.getSubImageNb(); index++) {
					System.out.println("RAM 0: "+convertByteTabToString(spriteSheet.getSubImagePixels(index, 0)));
					PatternFinder cs0 = new PatternFinder(spriteSheet.getSubImagePixels(index, 0));
					cs0.buildCode(isForward);
					fr.bento8.to8.compiledSprite.Solution solution = cs0.getSolutions().get(0);
					PatternCluster cluster = new PatternCluster(solution);
					cluster.cluster(isForward);
					cs0.displaySolutions();
					RegisterOptim regOpt = new RegisterOptim(solution, spriteSheet.getSubImagePixels(index, 0));
					regOpt.run(isForward);
					
					System.out.println("RAM 1: "+convertByteTabToString(spriteSheet.getSubImagePixels(index, 1)));
					PatternFinder cs1 = new PatternFinder(spriteSheet.getSubImagePixels(index, 1));
					cs1.buildCode(isForward);
					solution = cs1.getSolutions().get(0);
					cluster = new PatternCluster(solution);
					cluster.cluster(isForward);
					cs1.displaySolutions();
				}
			}
			

//			// Il est nécessaire de faire une première compilation de sprite pour connaitre leur taille
//			for (String[] i : animationImages.values()) { // Compile les sprites
//				int nbImages = Integer.parseInt(i[5]);
//				for (int j=0; j<nbImages; j++ ) {
//					System.out.println("**************** Calcul de la taille pour l'image " + i[1]+":"+j + " ****************");
//					CompiledSpriteModeB16 sprite = new CompiledSpriteModeB16(i[4], i[1]+j, nbImages, j, Integer.parseInt(i[6]));
//					binary = sprite.getCompiledCode("A000");
//
//					if (binary.length>16384)
//					{
//						throw new Exception("Image "+i[1]+":"+j+" trop grande, code compilé :"+binary.length+" octets (max 16384)");
//					}
//
//					compiledImages.put(i[1]+":"+j, new String[] {i[4], i[1]+j, Integer.toString(nbImages), Integer.toString(j), i[6], i[0]});
//					items[nbAllSubImages++] = new Item(i[1]+":"+j, Integer.parseInt(i[2]+String.format("%03d", Integer.parseInt(i[3]))), binary.length); // id, priority, bytes
//					System.out.println(i[1]+":"+j+":"+binary.length+":");
//					for (int idx=0; idx<binary.length; idx++)
//						System.out.print(String.format("%x", Byte.toUnsignedInt(binary[idx])));
//				}
//			}
//
//			face = 0; // 0-1
//			track = 8; // 0-79
//			sector = 1; // 1-16
//			int orgOffset;
//			int org;
//
//			int currentPageIndex = 0;
//			fd.setIndex(face, track, sector);
//
//			while (items.length>0) {
//
//				System.out.println("**************** Oganise les données en pages de 16ko - Page courante : " + pages[currentPageIndex] + " ****************");
//				orgOffset = 40960; // offset A000
//				org = 0; // relative ORG
//
//				if (currentPageIndex >= pages.length) {
//					throw new Exception("Plus de pages disponibles.");
//				}
//
//				// les données sont réparties en pages en fonction de leur taille par un algorithme "sac à dos"
//				Knapsack knapsack = new Knapsack(items, 16384); //16Ko
//				knapsack.display();
//				Solution solution = knapsack.solve();
//				solution.display();
//
//				for (Iterator<Item> iter = solution.items.listIterator(); iter.hasNext(); ) {
//					Item currentItem = iter.next();
//
//					// Seconde passe de compilation avec positionnement des adresses cibles
//					System.out.println("**************** Compile le sprite " + currentItem.name + " ****************");
//					String[] params = compiledImages.get(currentItem.name);
//					CompiledSpriteModeB16 sprite = new CompiledSpriteModeB16(params[0], params[1], Integer.parseInt(params[2]), Integer.parseInt(params[3]), Integer.parseInt(params[4]));
//					binary = sprite.getCompiledCode(String.format("%1$04X",orgOffset+org));
//
//					// référence des adresses pour la construction des scripts d'animation
//					imageAddress.put(currentItem.name, "\n\tFCB $" + String.format("%1$02X",pages[currentPageIndex]) + "\n\tFDB $" + String.format("%1$04X",orgOffset+org) + "\n\tFDB $" + sprite.eraseAddress);
//					org += binary.length;
//
//					fd.write(binary);
//
//					// construit la liste des éléments restants
//					for (int itemIndex=0; itemIndex<items.length; itemIndex++) {
//						if (items[itemIndex].name.contentEquals(currentItem.name)) {
//							Item[] newItems = new Item[items.length-1];
//							for (int l=0; l<itemIndex; l++) {
//								newItems[l]=items[l];
//							}
//							for (int j=itemIndex; j<items.length-1; j++) {
//								newItems[j]=items[j+1];
//							}
//							items = newItems;
//							break;
//						}
//					}
//				}
//				currentPageIndex++;
//				track += 4;
//				if (track > 79) {
//					face += 1;
//					track = 0;
//
//					if (face>1) {
//						throw new Exception("Plus d'espace dans l'image de disquette.");
//					}
//				}
//				fd.setIndex(face, track, sector);
//			}
//
//			// ********** scripts d'animation *******
//			String sAnimationScript = new String();
//			for (String[] animationScript : animationScripts.values()) {
//				sAnimationScript += "\n\n\tFDB $"+(animationScript[2].contentEquals("GSP") ? "01" : "00")+String.format("%1$02X", Integer.parseInt(animationScript[1]));
//				sAnimationScript += "\n"+animationScript[0];
//
//				for (int subImage = 3; subImage < animationScript.length; subImage++) {
//					String subImageAddress = imageAddress.get(animationScript[subImage]);
//					if (subImageAddress != null) {
//						sAnimationScript += subImageAddress;
//					} else if (animationScript[subImage].contentEquals("GO")) {
//						sAnimationScript += "\n\tFCB $FF";
//						subImage++;
//						sAnimationScript += "\n\tFDB "+animationScript[subImage++];
//						sAnimationScript += "\n\tFDB $"+String.format("%1$02X", Integer.parseInt(animationScript[subImage++]))+String.format("%1$02X", Integer.parseInt(animationScript[subImage]));
//					} else {
//						if (animationScript[subImage].contentEquals("RET")){
//							sAnimationScript += "\n\tFCB $FE";
//						} else {
//							throw new Exception("Unknown image: "+animationScript[subImage]+" in animation script: "+animationScript[0]+" position: "+subImage);
//						}
//					}
//				}
//			}
//
//			Path pathMain = Paths.get(mainFile);
//			Path pathMainTmp = Paths.get(mainFile+".TMP");
//			Files.deleteIfExists(pathMainTmp);
//			Charset charset = StandardCharsets.UTF_8;
//
//			// Positionnement des données de script d'animation
//			String content = new String(Files.readAllBytes(pathMain), charset);
//			content = content.replace(animationTag, sAnimationScript);
//			Files.write(pathMainTmp, content.getBytes(charset));
//
//			if (compile(mainFile+".TMP") == 0) { // Compilation du code principal
//				byte[] mainBytes = Files.readAllBytes(Paths.get(tmpFile)); // Ecriture du code principal
//
//				fd.setIndex(0, 0, 2);
//				fd.write(mainBytes);
//
//				fd.save(outputFileName);
//				fd.saveToSd(outputFileName);
//
//				// Affiche l'usage mémoire
//				System.out.print("\nUsed Pages :");
//				for (int usedPagesIndex=0; usedPagesIndex<currentPageIndex; usedPagesIndex++) {
//					System.out.print(pages[usedPagesIndex]+" ($"+String.format("%1$02X",pages[usedPagesIndex])+") ");
//				}
//				System.out.print("("+currentPageIndex*16+"ko)\nFree Pages :");
//				for (int freePagesIndex=currentPageIndex; freePagesIndex<pages.length; freePagesIndex++) {
//					System.out.print(pages[freePagesIndex]+" ($"+String.format("%1$02X",pages[freePagesIndex])+") ");
//				}
//				System.out.print("("+(pages.length-currentPageIndex)*16+" ko)\n");
//			}
		}
	}

	private static void readProperties(String file) {
		try (InputStream input = new FileInputStream(file)) { // Chargement du fichier de configuration

			Properties prop = new Properties();
			prop.load(input);

			bootFile = prop.getProperty("bootfile");
			if (bootFile == null) {
				throw new Exception("Paramètre bootfile manquant dans le fichier "+file);
			}

			mainFile = prop.getProperty("mainfile");
			if (mainFile == null) {
				throw new Exception("Paramètre mainfile manquant dans le fichier "+file);
			}

			outputFileName = prop.getProperty("outputfile");
			if (outputFileName == null) {
				throw new Exception("Paramètre outputfile manquant dans le fichier "+file);
			}

			tmpDirName = prop.getProperty("tmpdir");
			if (tmpDirName == null) {
				throw new Exception("Paramètre tmpdir manquant dans le fichier "+file);
			}

			tmpFile = tmpDirName + "/" + tmpFile;

			compiler = prop.getProperty("compiler");
			if (compiler == null) {
				throw new Exception("Paramètre compiler manquant dans le fichier "+file);
			}
			
			drawDirection = prop.getProperty("drawdirection");
			if (drawDirection == null) {
				throw new Exception("Paramètre drawdirection manquant dans le fichier "+file);
			}
			if (drawDirection.equals("R")) {
				isForward = false;
			} else {
				isForward = true;
			}
			
			animationTag  = prop.getProperty("animation.tag");
			if (animationTag == null) {
				throw new Exception("Paramètre animation.tag manquant dans le fichier "+file);
			}

			memoryPages = prop.getProperty("memorypages");
			if (memoryPages == null) {
				throw new Exception("Paramètre memorypages manquant dans le fichier "+file);
			}

			String[] el = memoryPages.split(";");
			pages = new int[el.length];
			for (int i=0;i<el.length;i++) {
				pages[i]=Integer.parseInt(el[i]);
			}

			animationImages = getPropertyList(prop, "animation.image");
			if (animationImages.isEmpty()) {
				throw new Exception("Paramètre animation.image.x manquant dans le fichier "+file);
			}

			animationScripts = getPropertyList(prop, "animation.script");
			if (animationScripts.isEmpty()) {
				throw new Exception("Paramètre animation.script.x manquant dans le fichier "+file);
			}

			initVideoFile = prop.getProperty("init.video");
			if (initVideoFile == null) {
				throw new Exception("Paramètre init.video manquant dans le fichier "+file);
			}

		} catch (Exception e) {
			System.out.println("Impossible de charger le fichier de configuration: "+file); 
		}
	}

	/**
	 * Effectue la compilation du code assembleur
	 * 
	 * @param asmFile fichier contenant le code assembleur a compiler
	 * @return
	 */
	private static int compile(String asmFile) {
		try {
			// Purge des fichiers temporaires
			Files.deleteIfExists(Paths.get(tmpFile));
			Files.deleteIfExists(Paths.get("codes.lst"));

			// Lancement de la compilation du fichier contenant le code de boot
			System.out.println("**************** COMPILE "+asmFile+" ****************");
			// l'option -bd permet la génération d'un binaire brut (sans entête)
			Process p = new ProcessBuilder(compiler, "-bd", Paths.get(asmFile).toString(), Paths.get(tmpFile).toString()).start();
			BufferedReader br=new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;

			while((line=br.readLine())!=null){
				System.out.println(line);
			}

			int result = p.waitFor();

			// Purge et remplacement de l'ancien fichier lst
			File f = new File("codes.lst"); 
			Path lstFile = Paths.get(tmpDirName+"/"+asmFile+".lst");
			Files.deleteIfExists(lstFile);
			f.renameTo(new File(tmpDirName+"/"+asmFile+".lst"));

			return result;

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e); 
			return -1;
		}
	}

	public static String convertByteTabToString(byte[] b1) {
		StringBuilder strBuilder = new StringBuilder();
		for(byte val : b1) {
			strBuilder.append(String.format("%02x", val&0xff));
		}
		return strBuilder.toString();
	}

	/**
	 * Effectue le chargement d'une liste de propriétés de type key.1, key.2, ...
	 * 
	 * @param Properties propriétés, String nom de la propriété
	 * @return HashMap<String, String[]> La liste des valeurs pour la propriété
	 */
	public static HashMap<String, String[]> getPropertyList(Properties properties, String name) 
	{
		List<String> lignes = new ArrayList<String>();
		HashMap<String, String[]> result = new HashMap<String, String[]>();
		String[] splitedLine;

		for (Entry<Object, Object> entry : properties.entrySet())
		{
			if (((String)entry.getKey()).matches("^" + Pattern.quote(name) + "\\.\\d+$"))
			{
				lignes.add((String) entry.getValue());
			}
		}

		for (String line : lignes)
		{
			splitedLine = line.split(";");
			result.put(splitedLine[0], splitedLine);
		}

		return result;
	}
}

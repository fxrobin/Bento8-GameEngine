package moto.gfx;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Iterator;

import moto.util.knapsack.Item;
import moto.util.knapsack.Knapsack;
import moto.util.knapsack.Solution;

public class BuildDisk
{
	static ReadProperties confProperties;
	static byte[] fdBytes = new byte[655360];
	static byte[] bootLoaderBytes;
	static String tempFile = "TMP.BIN";
	
	public static void main(String[] args)
	{
		byte[] binary;
		int k=0, sector=0, track=0, face=0;
		HashMap<String, String[]> compiledImages = new HashMap<String, String[]>();
		HashMap<String, String> imageAddress = new HashMap<String, String>();

		try {
			confProperties = new ReadProperties(args[0]);
			
			// ********** Load Boot code **********
			
			// Generate binary code from assembly code
			Files.deleteIfExists(Paths.get(tempFile));
			Process p = new ProcessBuilder("c6809.exe", "-oWE", confProperties.bootfile, tempFile).start();
			BufferedReader br=new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line;
			System.out.println("**************** COMPILE BOOT CODE ****************");
			while((line=br.readLine())!=null){
				System.out.println(line);
			}
			p.waitFor();
	                 
			BootLoader bootLoader = new BootLoader();
			bootLoaderBytes = bootLoader.encodeBootLoader(tempFile);
			Files.deleteIfExists(Paths.get(tempFile));
			
			// copy Bootloader to face 0 track 0 sector 1
			for (int i=0; i<bootLoaderBytes.length; i++) {
				fdBytes[i] = bootLoaderBytes[i];
			}
			
			// ********** Compiled Sprites **********
			// Count total images to sort
			for (String[] i : confProperties.animationImages.values()) {
				k += Integer.parseInt(i[5]);
			}
			
			Item[] items = new Item[k];
			k=0;

			// Compile sprites images
			for (String[] i : confProperties.animationImages.values()) {
				int nbImages = Integer.parseInt(i[5]);
				for (int j=0; j<nbImages; j++ ) {
					System.out.println("**************** COMPUTE COMPILED SPRITE LENGTH " + i[1]+":"+j + " ****************");
					CompiledSpriteModeB16v3 sprite = new CompiledSpriteModeB16v3(i[4], i[1]+j, nbImages, j);
					binary = sprite.getCompiledCode("A000");
					compiledImages.put(i[1]+":"+j, new String[] {i[4], i[1]+j, Integer.toString(nbImages), Integer.toString(j), i[0]});
					items[k++] = new Item(i[1]+":"+j, Integer.parseInt(i[2]+String.format("%03d", Integer.parseInt(i[3]))), binary.length); // id, priority, bytes
				}
			}

			face = 0; // 0-1
			track = 4; // 0-79
			sector = 1; // 1-16
			int orgOffset;
			int org;
			int[] pages = confProperties.memorypages; // free usable memory pages
			int currentPageIndex = 0;
			
			// Arrange images in 16ko pages
			while (items.length>0) {
				
				System.out.println("**************** ARRANGE DATA IN 16ko PAGES ****************");
				orgOffset = 40960; // offset A000
				org = 0; // relative ORG
						
				if (currentPageIndex >= pages.length) {
					throw new Exception("No more available pages.");
				}

				if (sector>16) {
					track += 1;
					sector = 1;
					if (track > 79) {
						face += 1;
						track = 0;
						if (face>1) {
							throw new Exception("No more space on fd image.");
						}
					}
				}
				
				Knapsack knapsack = new Knapsack(items, 16384); //16Ko
				knapsack.display();
				Solution solution = knapsack.solve();
				solution.display();

				for (Iterator<Item> iter = solution.items.listIterator(); iter.hasNext(); ) {
					Item currentItem = iter.next();

					System.out.println("**************** COMPILE SPRITE " + currentItem.name + " ****************");
					String[] params = compiledImages.get(currentItem.name);
					CompiledSpriteModeB16v3 sprite = new CompiledSpriteModeB16v3(params[0], params[1], Integer.parseInt(params[2]), Integer.parseInt(params[3]));
					binary = sprite.getCompiledCode(String.format("%1$04X",orgOffset+org));
					imageAddress.put(currentItem.name, "\n\tFCB $" + String.format("%1$02X",pages[currentPageIndex]) + "\n\tFDB $" + String.format("%1$04X",orgOffset+org) + "\n\tFDB $" + String.format("%1$04X",orgOffset+org+binary.length));
					org += binary.length;
					
					for (int i=0; i<compiledImages.get(currentItem.name).length; i++) {
						fdBytes[i+(face*327680)+(track*4096)+((sector-1)*256)] = binary[i];
					}

					for (int itemIndex=0; itemIndex<items.length; itemIndex++) {
						if (items[itemIndex].name.contentEquals(currentItem.name)) {
							Item[] newItems = new Item[items.length-1];
							for (int l=0; l<itemIndex; l++) {
								newItems[l]=items[l];
							}
							for (int j=itemIndex; j<items.length-1; j++) {
								newItems[j]=items[j+1];
							}
							items = newItems;
							break;
						}
					}
				}
				
				currentPageIndex++;
				sector += 4;
			}
			
			// ********** Animation scripts *******
			String sAnimationScript = new String();
			for (String[] animationScript : confProperties.animationScripts.values()) {
				sAnimationScript += "\n\n\tFDB $"+(animationScript[2].contentEquals("GSP") ? "00" : "01")+String.format("%1$02X", Integer.parseInt(animationScript[1]));
				sAnimationScript += "\n"+animationScript[0];
				
				for (int subImage = 3; subImage < animationScript.length; subImage++) {
					String subImageAddress = imageAddress.get(animationScript[subImage]);
					if (subImageAddress != null) {
						sAnimationScript += subImageAddress;
					} else if (animationScript[subImage].contentEquals("GO")) {
						sAnimationScript += "\n\tFCB $FF";
						subImage++;
						sAnimationScript += "\n\tFDB "+animationScript[subImage++];
						sAnimationScript += "\n\tFDB $"+String.format("%1$02X", Integer.parseInt(animationScript[subImage++]))+String.format("%1$02X", Integer.parseInt(animationScript[subImage]));
					} else {
						if (animationScript[subImage].contentEquals("RET")){
							sAnimationScript += "\n\tFCB $FE";
						} else {
							throw new Exception("Unknown image: "+animationScript[subImage]+" in animation script: "+animationScript[0]+" position: "+subImage);
						}
					}
				}
			}
//			System.out.println(sAnimationScript);
			
			Path pathMain = Paths.get(confProperties.mainfile);
			Path pathMainTmp = Paths.get(confProperties.mainfile+".TMP");
			Files.deleteIfExists(pathMainTmp);
			Charset charset = StandardCharsets.UTF_8;

			String content = new String(Files.readAllBytes(pathMain), charset);
			content = content.replace(confProperties.animationTag, sAnimationScript);
			Files.write(pathMainTmp, content.getBytes(charset));
			
			// ********** Load Main code **********

			// Generate binary code from assembly code
			Files.deleteIfExists(Paths.get(tempFile));
			p = new ProcessBuilder("c6809.exe", "-bd", confProperties.mainfile+".TMP", tempFile).start();
			br=new BufferedReader(new InputStreamReader(p.getInputStream()));
			System.out.println("**************** COMPILE MAIN CODE ****************");
			while((line=br.readLine())!=null){
				System.out.println(line);
			}
			p.waitFor();

			// Write Main Code
			face=0;
			track=0;
			sector=2;
			byte[] mainBIN = Files.readAllBytes(Paths.get(tempFile));
			for (int i = 0; i < mainBIN.length; i++) {
				fdBytes[i+(face*327680)+(track*4096)+((sector-1)*256)] = mainBIN[i];
			}

			// Write output file
			Path outputfile = Paths.get(confProperties.outputfile);
			Files.deleteIfExists(outputfile);
			Files.createFile(outputfile);
			Files.write(outputfile, fdBytes);
		}
		catch (Exception e)
		{
			e.printStackTrace(); 
			System.out.println(e); 
		}
	}
	public static String display(byte[] b1) {
		   StringBuilder strBuilder = new StringBuilder();
		   for(byte val : b1) {
		      strBuilder.append(String.format("%02x", val&0xff));
		   }
		   return strBuilder.toString();
		}
}

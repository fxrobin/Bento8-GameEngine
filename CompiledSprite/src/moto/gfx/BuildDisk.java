package moto.gfx;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.lang.ProcessBuilder.Redirect;
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
		String binary;
		int k=0, sector=0, track=0, face=0;
		HashMap<String, String> compiledImages = new HashMap<String, String>();

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
					System.out.println("**************** COMPILE SPRITE " + i[1]+":"+j + " ****************");
					CompiledSpriteModeB16v3 sprite = new CompiledSpriteModeB16v3(i[4], Integer.parseInt(i[0]), i[1]+j, nbImages, j); // todo implementer sous images	
					binary = sprite.getCompiledCode("A000");
					compiledImages.put(i[1]+":"+j, binary);
					items[k++] = new Item(i[1]+":"+j, Integer.parseInt(i[2]+String.format("%03d", Integer.parseInt(i[3]))), binary.length()); // id, priority, bytes
				}
			}

			// Arrange images in 16ko pages
			System.out.println("**************** ARRANGE IMAGES IN 16ko PAGES ****************");
			Knapsack knapsack = new Knapsack(items, 16384); //16Ko
			knapsack.display();
			Solution solution = knapsack.solve();
			solution.display();
			
			// todo retirer items utilisés
//			for (Iterator<String> iter = list.listIterator(); iter.hasNext(); ) {
//			    String a = iter.next();
//			    if (...) {
//			        iter.remove();
//			    }
//			}


			face=0;
			track=4;
			sector=1;
			for (Iterator<Item> iter = solution.items.listIterator(); iter.hasNext(); ) {
				Item a = iter.next();
				for (int i=0; i<compiledImages.get(a.name).getBytes().length; i++) {
					fdBytes[i+(face*327680)+(track*4096)+((sector-1)*256)] = (byte) (256 - compiledImages.get(a.name).getBytes()[i]);
				}
			}
			
			// ********** Load Main code **********
			
			// Generate binary code from assembly code
			Files.deleteIfExists(Paths.get(tempFile));
			p = new ProcessBuilder("c6809.exe", "-bd", confProperties.mainfile, tempFile).start();
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
				fdBytes[i+(face*327680)+(track*4096)+((sector-1)*256)] = (byte) (256 - mainBIN[i]);
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
}

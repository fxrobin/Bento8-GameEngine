package moto.gfx;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.lang.ProcessBuilder.Redirect;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;

import moto.util.knapsack.Item;
import moto.util.knapsack.Knapsack;
import moto.util.knapsack.Solution;

public class BuildDisk
{
	static ReadProperties confProperties;
	static byte[] bootLoaderBytes;
	static String tempFile = "./output/TMP.BIN";
	
	public static void main(String[] args)
	{
		String binary;
		int k=0;
		HashMap<String, String> compiledImages = new HashMap<String, String>();

		try {
			confProperties = new ReadProperties(args[0]);
			
			// ********** Load Boot code **********
			
			// Generate binary code from assembly code
			Files.deleteIfExists(Paths.get(tempFile));
			Process p = new ProcessBuilder("c6809.exe", "-oWE", confProperties.bootfile, tempFile).start();
	        BufferedReader br=new BufferedReader(new InputStreamReader(p.getInputStream()));
	        String line;
	        while((line=br.readLine())!=null){
	        	System.out.println(line);
	        }
	                 
			BootLoader bootLoader = new BootLoader();
			bootLoaderBytes = bootLoader.encodeBootLoader(tempFile);
			Files.deleteIfExists(Paths.get(tempFile));
			
			// Write bootloader to output file
			Path outputfile = Paths.get(confProperties.outputfile);
			Files.deleteIfExists(outputfile);
			Files.createFile(outputfile);
			Files.write(outputfile, bootLoaderBytes);
			
			// ********** Compiled Sprites **********
//			// Count total images to sort
//			for (String[] i : confProperties.animationImages.values()) {
//				k += Integer.parseInt(i[4]);
//			}
//			
//			Item[] items = new Item[k];
//			k=0;
//
//			// Compile sprites images
//			for (String[] i : confProperties.animationImages.values()) {
//				int nbImages = Integer.parseInt(i[4]);
//				for (int j=0; j<nbImages; j++ ) {
//					CompiledSpriteModeB16v3 sprite = new CompiledSpriteModeB16v3(i[3], nbImages, j); // todo implementer sous images	
//					binary = sprite.getCompiledCode();
//					compiledImages.put(i[0]+":"+j, binary);
//					items[k++] = new Item(i[0]+":"+j, Integer.parseInt(i[1]+String.format("%03d", i[2])), binary.length()); // id, priority, bytes
//				}
//			}
//
//			// Arrange images in 16ko pages
//			Knapsack knapsack = new Knapsack(items, 16384); //16Ko
//			knapsack.display();
//			Solution solution = knapsack.solve();
//			solution.display();
//			// todo retirer items utilisés
//			
//			for (Iterator<String> iter = list.listIterator(); iter.hasNext(); ) {
//			    String a = iter.next();
//			    if (...) {
//			        iter.remove();
//			    }
//			}
		}
		catch (Exception e)
		{
			e.printStackTrace(); 
			System.out.println(e); 
		}
	}
}

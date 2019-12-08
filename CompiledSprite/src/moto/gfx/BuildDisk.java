package moto.gfx;

import java.util.HashMap;

import moto.util.knapsack.Item;
import moto.util.knapsack.Knapsack;
import moto.util.knapsack.Solution;

public class BuildDisk
{
	static ReadProperties confProperties;

	public static void main(String[] args)
	{
		String binary;
		int k=0;
		HashMap<String, String> compiledImages = new HashMap<String, String>();

		try {
			confProperties = new ReadProperties();
			
			// Count total images to sort
			for (String[] i : confProperties.animationImages.values()) {
				k += Integer.parseInt(i[4]);
			}
			
			Item[] items = new Item[k];
			k=0;

			// Compile sprites images
			for (String[] i : confProperties.animationImages.values()) {
				int nbImages = Integer.parseInt(i[4]);
				for (int j=0; j<nbImages; j++ ) {
					CompiledSpriteModeB16v3 sprite = new CompiledSpriteModeB16v3(i[3], nbImages, j); // todo implementer sous images	
					binary = sprite.getCompiledCode();
					compiledImages.put(i[0]+":"+j, binary);
					items[k++] = new Item(i[0]+":"+j, Integer.parseInt(i[1]+String.format("%03d", i[2])), binary.length()); // id, priority, bytes
				}
			}

			// Arrange images in 16ko pages
			Knapsack knapsack = new Knapsack(items, 16384); //16Ko
			knapsack.display();
			Solution solution = knapsack.solve();
			solution.display();
			// todo retirer items utilisés
			
			for (Iterator<String> iter = list.listIterator(); iter.hasNext(); ) {
			    String a = iter.next();
			    if (...) {
			        iter.remove();
			    }
			}
			
			// boucler sur pages restantes
		}
		catch (Exception e)
		{
			e.printStackTrace(); 
			System.out.println(e); 
		}
	}
}

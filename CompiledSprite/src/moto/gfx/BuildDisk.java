package moto.gfx;

import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

import moto.util.knapsack.Item;
import moto.util.knapsack.Knapsack;
import moto.util.knapsack.Solution;

public class BuildDisk
{
	static ReadProperties confProperties;

	public static void main(String[] args)
	{
		try {
			confProperties = new ReadProperties();

			for (String[] i : confProperties.animationImages.values()) {
				System.out.println(i[3]);

				// Génération d'un Sprite Compilé à partir d'un PNG
				CompiledSpriteModeB16v3 sprite = new CompiledSpriteModeB16v3(i[3]);		

				Path fichier = Paths.get(sprite.getName().substring(0, Math.min(sprite.getName().length(), 8))+".ASS");
				Files.deleteIfExists(fichier);
				Files.createFile(fichier);

				// Génération d'un fichier BIN a partir d'un PNG
				PngToBinModeB16 background = new PngToBinModeB16(".\\images\\Foret.png");	
				background.writeBIN(background.getName().substring(0, Math.min(background.getName().length(), 7))+".BIN");

				// Ecriture du fichier de sortie
				Files.write(fichier, sprite.getCodeHeader(sprite.drawLabel, 1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(fichier, sprite.getCompiledCode(1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(fichier, sprite.getCodeSwitchData(2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(fichier, sprite.getCompiledCode(2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(fichier, sprite.getCodeFooter(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(fichier, sprite.getCompiledData(1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(fichier, sprite.getCompiledData(2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(fichier, sprite.getCodeDataPos(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);

				Files.write(fichier, sprite.getCodeHeader(sprite.erasePrefix, sprite.eraseLabel, 1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(fichier, sprite.getCompiledECode(1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(fichier, sprite.getCodeSwitchData(sprite.erasePrefix, 2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(fichier, sprite.getCompiledECode(2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(fichier, sprite.getCodeFooter(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(fichier, sprite.getCompiledEData(sprite.erasePrefix, 1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
				Files.write(fichier, sprite.getCompiledEData(sprite.erasePrefix, 2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			}
		}
		catch (Exception e)
		{
			e.printStackTrace(); 
			System.out.println(e); 
		}


///////////////////////////////////////



		Item[] items = {new Item("Elt1", 4, 12), // id, priority, bytes
				new Item("Elt2", 2, 1), 
				new Item("Elt3", 2, 2), 
				new Item("Elt4", 1, 1),
				new Item("Elt5", 10, 4)};

		Knapsack knapsack = new Knapsack(items, 16384); //16Ko
		knapsack.display();
		Solution solution = knapsack.solve();
		solution.display();
		// todo retirer items utilisés
		// boucler sur pages restantes
	}
}

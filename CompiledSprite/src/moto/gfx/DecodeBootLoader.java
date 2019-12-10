package moto.gfx;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class DecodeBootLoader
{
  public static void main(String[] args)
  {
	try
	{
		if (args.length==1) {
			// Decodage d'un bootloader a partir d'une image disquette fd
			BootLoader bootLoader = new BootLoader();
			byte[] bootLoaderBytes = bootLoader.decodeBootLoader(args[0]);

			Path fichier = Paths.get("Bootloader_" + args[0]);
			Files.deleteIfExists(fichier);
			Files.createFile(fichier);
			Files.write(fichier, bootLoaderBytes);
		}
		else {
			System.out.println("Parametres invalides !");
		}
	} 
    catch (Exception e)
    {
        e.printStackTrace(); 
        System.out.println(e); 
    }
  }
}

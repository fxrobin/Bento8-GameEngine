package moto.gfx;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.nio.charset.Charset;

public class CompiledSprite
{
  public static void main(String[] args)
  {
	try
	{
		if (args.length==1) {
			CompiledSpriteModeB16 sprite = new CompiledSpriteModeB16(args[0]);		
			
			Path fichier = Paths.get(sprite.getName().substring(0, Math.min(sprite.getName().length(), 8))+".asm");
			Files.deleteIfExists(fichier);
			Files.createFile(fichier);
						
			// Ecriture du fichier de sortie
			Files.write(fichier, sprite.getCodeStart(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCodeHeader(1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCompiledCode(1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCodeSwitchData(2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCompiledCode(2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCodeFooter(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCompiledData(1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCompiledData(2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCodeDataPos(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);	
			Files.write(fichier, sprite.getCodePalette(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCodeEnd(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
		}
		else {
			System.out.println("Parametres invalides !");
			System.out.println("USAGE: java CompiledSprite <nom du fichier>.png");
			System.out.println("CompiledSprite est un générateur de sprite compilé pour TO8 Thomson mode 160x200 16 couleurs.");			
			System.out.println("Le fichier en entrée doit être de type PNG indexé de profondeur 8bit.");
			System.out.println("Les couleurs 0-15 sont utilisées pour l'image.");
			System.out.println("Les couleurs 16-255 sont utilisées pour la transparence.");
		}
	} 
    catch (Exception e)
    {
        e.printStackTrace(); 
        System.out.println(e); 
    }
  }
}

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
			// GÈnÈration d'un Sprite CompilÈ ‡ partir d'un PNG
			CompiledSpriteModeB16v2 sprite = new CompiledSpriteModeB16v2(args[0]);		
			
			Path fichier = Paths.get(sprite.getName().substring(0, Math.min(sprite.getName().length(), 8))+".asm");
			Files.deleteIfExists(fichier);
			Files.createFile(fichier);
		
			// GÈnÈration d'un fichier BIN a partir d'un PNG
			PngToBinModeB16 background = new PngToBinModeB16(".\\images\\Foret.png");	
			background.writeBIN(background.getName().substring(0, Math.min(background.getName().length(), 7))+".BIN");
			
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
			Files.write(fichier, sprite.getCodeEREFLabel("E1", "E2"), Charset.forName("UTF-8"), StandardOpenOption.APPEND);

			Files.write(fichier, sprite.getCodeHeader("E1", 1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCompiledCode(1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCodeSwitchData("E1", 2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCompiledCode(2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCodeFooter(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCompiledData("E1", 1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCompiledData("E1", 2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCodeDataPos("E1"), Charset.forName("UTF-8"), StandardOpenOption.APPEND);	

			Files.write(fichier, sprite.getCodeHeader("E2", 1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCompiledCode(1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCodeSwitchData("E2", 2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCompiledCode(2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCodeFooter(), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCompiledData("E2", 1), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCompiledData("E2", 2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
			Files.write(fichier, sprite.getCodeDataPos("E2"), Charset.forName("UTF-8"), StandardOpenOption.APPEND);	
			
			Files.write(fichier, sprite.getCodePalette(background.getColorModel(),2), Charset.forName("UTF-8"), StandardOpenOption.APPEND);
		}
		else {
			System.out.println("Parametres invalides !");
			System.out.println("USAGE: java CompiledSprite <nom du fichier>.png");
			System.out.println("CompiledSprite est un g√©n√©rateur de sprite compil√© pour TO8 Thomson mode 160x200 16 couleurs.");			
			System.out.println("Le fichier en entr√©e doit √™tre de type PNG index√© de profondeur 8bit.");
			System.out.println("Les couleurs 0-15 sont utilis√©es pour l'image.");
			System.out.println("Les couleurs 16-255 sont utilis√©es pour la transparence.");
		}
	} 
    catch (Exception e)
    {
        e.printStackTrace(); 
        System.out.println(e); 
    }
  }
}

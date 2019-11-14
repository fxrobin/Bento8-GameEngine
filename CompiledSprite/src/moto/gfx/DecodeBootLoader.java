package moto.gfx;

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
			System.out.print("bootLoader: <");
			for (int i = 0; i < bootLoaderBytes.length; i++) {
				System.out.print(String.format("%02X", (0xFF & bootLoaderBytes[i])));
			}
			System.out.println(">");
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

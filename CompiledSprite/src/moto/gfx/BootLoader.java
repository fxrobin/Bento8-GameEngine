package moto.gfx;

import java.nio.file.Files;
import java.nio.file.Paths;

public class BootLoader {
// BOOTLOADER type
//	***************************************
//	* Boot loader. Il charge le 2eme
//	* secteur de la diskette de boot en
//	* $6300 et saute a cette adresse.
//	***************************************
//	(main)bootld.ASS
//	   setdp $60
//	   org $6200
//
//	init
//	   lda #$02
//	   sta <$6048 * DK.OPC $02 Operation - Lecture d un secteur
//	   sta <$604C * DK.SEC $02 Secteur a lire
//	   ldd $1E    * 
//	   std ,s     * 
//	   ldd #$6300 * Destination des donnees lues
//	   std <$604F * DK.BUF Destination des donnees lues
//	   jsr $E82A  * DKFORM Appel 
//	   stb <$6080 * Semaphore du controle de presence du controleur de disque
//	   bcs exit   * Si Erreur C=1 alors branchement exit
//	   jmp $6300  * Sinon Execution en $6300
//	exit
//	   rts        * Retour au programme residant
//	   end init
	
	// TODO
	// Ecrire un decrypteur de bootloader :
	// recherche de BASIC2 pour localiser dans le fichier .fd

	byte[] signature = {0x42, 0x41, 0x53, 0x49, 0x43, 0x32, 0x00}; // "BASIC2 "

	public BootLoader() {
	}
	
	public byte[] encodeBootLoader(String file) {
		byte[] bootLoader = new byte[128];
		int i;
		try {
			byte[] bootLoaderBIN = Files.readAllBytes(Paths.get(file));
			// Le fichier BIN a charger dans le bootloader doit être d'une taille max de 121 octets
			// TODO : verifier adresse implantation du bootloader pour ajout controle
			if (bootLoaderBIN[0] ==  (byte) 0x00 && bootLoaderBIN[1] ==  (byte) 0x00 && bootLoaderBIN[2] <=  (byte) 0x79) {
				bootLoader[127] = (byte) 0x55; // CHKSUM
				for (i = 0; i < bootLoaderBIN[2]; i++) {
					bootLoader[i] = (byte) (256 - bootLoaderBIN[i+5]);
					bootLoader[127] = (byte) (bootLoader[127] - bootLoader[i]);
				}
				
				while (i <= 119 ) {
					bootLoader[i++] = (byte) 0x00;
				}
				
				while (i <= 126 ) {
					bootLoader[i] = signature [i-120];
					bootLoader[127] = (byte) (bootLoader[127] - bootLoader[i++]);
				}
			} else {
				System.out.println("Le fichier BIN pour le bootloader doit contenir un code de 121 octets maximum. Taille actuelle: " + Integer.toHexString(bootLoaderBIN[1]) + Integer.toHexString(bootLoaderBIN[2]));
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e);
		}
		return bootLoader;
	}

	public byte[] decodeBootLoader(String file) {
		byte[] decodedBootLoader = new byte[128];
		int i;
		try {
			byte[] fd = Files.readAllBytes(Paths.get(file));

			for (i = 0; i < fd.length-signature.length; i++) {
				if (fd[i] == signature[0] && fd[i+1] == signature[1] && fd[i+2] == signature[2] && fd[i+3] == signature[3] && fd[i+4] == signature[4] && fd[i+5] == signature[5] && fd[i+6] == signature[6]) {
					for (int j = i-121, k = 0; j < i; j++) {
						decodedBootLoader[k++] = (byte) (256 - fd[j]);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e);
		}
		return decodedBootLoader;
	}
}

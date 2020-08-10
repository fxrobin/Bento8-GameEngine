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

//
//	Le
//
//	boot-block est situé en face 0,piste 0,secteur 1 de chaque disquette Thomson.il est chargé en memoire centrale et analysé lorsqu on choisit un Basic
//
//	au menu du TO8.Selon les cas il se comporte soit comme un secteur normalsoit comme un secteur d amorçagePour prendre la main avec un secteur de Boot
//
//	executable(après choix Basic 512 au menu -> 1 ou B)1)le boot doit contenir la chaine "BASIC2" sur les positions 120 à 125.2) les 127 premiers
//
//	octets du boot doivent etre complementés à 23) le systeme verifie alors sila valeur du 128 eme octet est egal à (somme des 127 premiers +$55) AND
//
//	255si oui alors le boot est executési non le basic est chargé.
	//http://silicium.org/forum/viewtopic.php?f=38&t=858
	

//10 'SAVE "MKBOOT",A
//20 CLEAR 1000,&HA1FF
//30 DEFINT A-Z
//40 M=-&H6000+&H200 '&HA200
//50 FORI=0 TO 255:POKEM+I,0:NEXT
//60 F$=DSKI$(1,20,2)
//70 IF MID$(F$,2,1)<>CHR$(255) THEN INPUT "Boot block occupBe, continuer? (oui/non) ", R$: IF R$<>"oui" THEN PRINT"Abandon":END
//80 'reservation FAT
//90 MID$(F$,2,1) = CHR$(254)
//100 DSKO$ 1,20,2,F$
//110 'boot
//120 LOADM "bootldr.BIN",M-&H6200
//140 'signature + checksum
//150 FOR I=0 TO 126:POKE M+I,255 AND -PEEK(M+I):NEXT
//160 POKE M+120,"BASIC2"
//170 S=&H55:FOR I=0 TO 126:S=(S-PEEK(M+I))AND255:NEXT:PRINT "checksum="+HEX$(S)
//180 POKE M+127,S
//190 ' sauvegarde bootloader
//200 DSKO$ 1,0,1,"":POKE &H604F,MKI$(M):EXEC &HE82A
//210 'lecture code a charger
//220 LOADM "TO-ale.BIN",M-&H6300
//230 'ecriture code
//240 DSKO$ 1,0,2,"":POKE &H604F,MKI$(M):EXEC &HE82A
	//http://www.pulsdemos.com/toale.html
	
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
			// BIN Format :
			//			00    ==> bloc binaire
			//			00 01 ==> de 1 octet
			//			e7 c3 ==> à charger à partir de $E7C3
			//			65    ==> on écrit donc $65 en $E7C3
			//			00    ==> nouveau bloc binaire
			//			1f 80 ==> de longueur $1F80=8000
			//			a0 00 ==> à charger en $A000
			//			.. .. ==> 8000 octets à suivre
			//
			//			$FF   --> fin de fichier
			//			$0000 --> pas de données
			//			$EXEC --> adresse d'exec ($0000 si indéfini)
			// http://www.logicielsmoto.com/phpBB/viewtopic.php?f=3&t=571&hilit=bin&start=150
					
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
					for (int j = i-120, k = 0; j < i; j++) {
						decodedBootLoader[k++] = (byte) (256 - fd[j]);
					}
					break;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e);
		}
		return decodedBootLoader;
	}
}

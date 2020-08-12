package fr.bento8.to8.boot;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;

/**
 * @author Beno�t Rousseau
 * @version 1.0
 *
 */
public class Bootloader {

	public byte[] signature = {0x42, 0x41, 0x53, 0x49, 0x43, 0x32}; // "BASIC2"
	public byte signatureSum = (byte) 0x6C; // (256-(66+65+83+73+67+50)%256)) Somme de contr�le de la signature

	public Bootloader() {
	}
	
	/**
	 * Encode le secteur d'amor�age d'une disquette Thomson TO8
	 * 
	 * Le secteur d'amor�age est pr�sent en face=0 piste=0 secteur=1 octets=0-127 
	 * 
	 * Le code a ex�cuter est contenu en position 0 � 119 (encod� par un compl�ment � 2 sur chaque octet)
	 * Le secteur d'amor�age contient "BASIC2" en position 120 � 125
	 * Le secteur d'amor�age contient la somme de contr�le en position 127
	 * 
	 * La somme de contr�le est v�rifi�e au chargement par le TO8 en effectuant :
	 *    - un compl�ment � 2 sur tous les octets 0-126 (code+signature)
	 *    - une somme de ces octets
	 *    - l'ajout de la valeur 0x55
	 *      
	 * Il faut donc calculer la somme de contr�le en effectuant:
	 *    - la somme des octets du code (0-119) avant leur compl�ment � 2
	 *    - ajouter la somme des octets (avec compl�ment � 2) de la signature
	 *    - ajouter 0x55
	 * 
	 * Au lancement du basic (Touche 1, B, 2 ou C) le syst�me execute la lecture du secteur d'amor�age (point d'entr�e $E007)
	 * S'il est pr�sent, le TO8 charge le code d'amor�age � l'adresse $6200, sinon il execute le Basic
	 * 
	 * Quand on boot par C, il bascule en "compatibilit� TO7/70" et la commutation m�moire doit se faire via le PIA (comme sur TO9 et TO7/70). Il faut alors modifier le registre syst�me pour restaurer la commutation de bank rapide comme sur TO8. D'ailleurs dans le BootLoader fait par Pr�histo pour la d�mo "In the Shadow of the thomson", il y a ceci:
	 * Dans le cas du lancement par C mettre en place ce code :
	 * (lda #2)
 	 * ...
 	 **PIA memory switch
	 *boot1  cmpa   >$fff0  ! Error if not
     *  beq    boot2   ! TO9/8/D/9+
     *  ldb    #$ff-$10 !
     *  andb   <$6081   ! PIA switch
     *  stb    <$6081   ! RAM mode
     *  stb    >$e7e7   !
     **Initialize system
	 *boot2
	 *
	 * @param file fichier binaire contenant le code compil� d'amor�age
	 * @return
	 */
	public byte[] encodeBootLoader(String file) {
		byte[] bootLoader = new byte[128];
		Arrays.fill(bootLoader, (byte) 0x00);
		int i,j=0;
		
		try {
			byte[] bootLoaderBIN = Files.readAllBytes(Paths.get(file));
			
			// Taille maximum de 120 octets pour le bootloader
			if (bootLoaderBIN.length <= 120) {
				
				// Initialisation de la somme de controle
				bootLoader[127] = (byte) 0x55;
				
				for (i = 0; i < bootLoaderBIN.length; i++) {
					// Ajout de l'octet courant (avant compl�ment � 2) � la somme de contr�le
					bootLoader[127] = (byte) (bootLoader[127] + bootLoaderBIN[i]);
					
					// Encodage de l'octet par compl�ment � 2
					bootLoader[i] = (byte) (256 - bootLoaderBIN[i]);
				}
				
				for (i = 120; i <= 125; i++) {
					// Copie de la signature (SANS compl�ment � 2)
					bootLoader[i] = signature[j++];
				}
				
				// Ajout de la somme de la signature � la somme de contr�le
				bootLoader[127] = (byte) (bootLoader[127] + signatureSum);
				
			} else {
				System.out.println("Le fichier BIN pour le bootloader doit contenir un code de 120 octets maximum. Taille actuelle: " + bootLoaderBIN.length);
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e);
		}
		return bootLoader;
	}
}
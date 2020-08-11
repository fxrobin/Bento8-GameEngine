package fr.bento8.to8.boot;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;

/**
 * @author Benoît Rousseau
 * @version 1.0
 *
 */
public class Bootloader {

	public byte[] signature = {0x42, 0x41, 0x53, 0x49, 0x43, 0x32}; // "BASIC2"
	public byte signatureSum = (byte) 0x6C; // (256-(66+65+83+73+67+50)%256)) Somme de contrôle de la signature

	public Bootloader() {
	}
	
	/**
	 * Encode le secteur d'amorçage d'une disquette Thomson TO8
	 * 
	 * Le secteur d'amorçage est présent en face=0 piste=0 secteur=1 octets=0-127 
	 * 
	 * Le code a exécuter est contenu en position 0 à 119 (encodé par un complément à 2 sur chaque octet)
	 * Le secteur d'amorçage contient "BASIC2" en position 120 à 125
	 * Le secteur d'amorçage contient la somme de contrôle en position 127
	 * 
	 * La somme de contrôle est vérifiée au chargement par le TO8 en effectuant :
	 *    - un complément à 2 sur tous les octets 0-126 (code+signature)
	 *    - une somme de ces octets
	 *    - l'ajout de la valeur 0x55
	 *      
	 * Il faut donc calculer la somme de contrôle en effectuant:
	 *    - la somme des octets du code (0-119) avant leur complément à 2
	 *    - ajouter la somme des octets (avec complément à 2) de la signature
	 *    - ajouter 0x55
	 * 
	 * Au lancement du basic (Touche 1, B, 2 ou C) le système execute la lecture du secteur d'amorçage (point d'entrée $E007)
	 * S'il est présent, le TO8 charge le code d'amorçage à l'adresse $6200, sinon il execute le Basic
	 * 
	 * @param file fichier binaire contenant le code compilé d'amorçage
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
					// Ajout de l'octet courant (avant complément à 2) à la somme de contrôle
					bootLoader[127] = (byte) (bootLoader[127] + bootLoaderBIN[i]);
					
					// Encodage de l'octet par complément à 2
					bootLoader[i] = (byte) (256 - bootLoaderBIN[i]);
				}
				
				for (i = 120; i <= 125; i++) {
					// Copie de la signature (SANS complément à 2)
					bootLoader[i] = signature[j++];
				}
				
				// Ajout de la somme de la signature à la somme de contrôle
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
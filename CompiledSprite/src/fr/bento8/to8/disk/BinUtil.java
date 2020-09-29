package fr.bento8.to8.disk;

/**
 * @author Beno�t Rousseau
 * @version 1.0
 *
 */
public class BinUtil
{
	public BinUtil() {
	}

	/**
	 * Format BIN
	 * Header: $00, Taille des donn�es sur 16bits, Adresse de chargement sur 16bits
	 * Trailer: $FF $00 $00 $00 $00
	 * ex: compilation -bh (hybride)
	 * 00 00 80 B5 42 => Le header est r�p�t� tous les 128 octets, la taille est fixe, l'adresse �volue
	 * ex: compilation -bl (lineaire)
	 * 00 06 CE B5 42 => Le header est mentionn� uniquement au d�but
	 * ex: compilation -bd (donnees)
	 * Pas de header ni de trailer
	 */
}
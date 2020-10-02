package fr.bento8.to8.disk;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * @author Beno�t Rousseau
 * @version 1.0
 *
 */
public class FdUtil
{
	private static final Logger logger = LogManager.getLogger("log");
	
	private final byte[] fdBytes = new byte[655360];
	private int index = 0;

	public FdUtil() {
	}

	/**
	 * Positionne l'index d'�criture sur un secteur dans une image fd
	 * en fonction d'une unit�, d'une piste et d'un num�ro de secteur
	 * Un TO8 g�re jusqu'a 4 unit�s (t�tes de lecture) soit deux lecteurs double face
	 * L'image fd permet le stockage de deux disquettes double face en un seul fichier
	 * 
	 * @param unit� num�ro de l'unit� (0-3)
	 * @param piste num�ro de la piste (0-79)
	 * @param secteur num�ro du secteur (1-16)
	 */
	public void setIndex(int unite, int piste, int secteur) {
		if (unite < 0 || unite > 3 || piste < 0 || piste > 79 || secteur < 1 || secteur > 16) {
			logger.debug("DiskUtil.getIndex: param�tres incorrects");
			logger.debug("unit� (0-3):"+unite+" piste (0-79):"+piste+" secteur (1-16):"+secteur);
		} else {
			index = (unite*327680)+(piste*4096)+((secteur-1)*256);
		}
	}

	/**
	 * Positionne l'index d'�criture � une valeur donn�e
	 * 
	 * @param position Index d'�criture
	 */
	public void setIndex(int position) {
		index = position;
	}
	
	/**
	 * Eciture de donn�es � l'index courant dans le fichier fd mont� en m�moire
	 * 
	 * @param bytes donn�es � copier
	 */
	public void write(byte[] bytes) {
		logger.debug("Ecriture Disquette en :"+index+" ($"+String.format("%1$04X",index)+")");
		int i;
		for (i=0; i<bytes.length; i++) {
			fdBytes[index+i] = bytes[i];
		}
		index+=i;
	}
	
	/**
	 * Eciture de donn�es � l'index courant dans le fichier fd mont� en m�moire
	 * 
	 * @param bytes donn�es � copier
	 */
	public void write(byte[] bytes, int start, int length) {
		logger.debug("Ecriture Disquette en :"+index+" ($"+String.format("%1$04X",index)+")");
		int i;
		for (i=start; i<start+length; i++) {
			fdBytes[index+i-start] = bytes[i];
		}
		index+=i;
	}

	/**
	 * Eciture (et remplacement) du fichier fd
	 * 
	 * @param outputFileName nom du fichier a �crire
	 */
	public void save(String outputFileName) {
		Path outputFile = Paths.get(outputFileName+".fd");
		try {
			Files.deleteIfExists(outputFile);
			Files.createFile(outputFile);
			Files.write(outputFile, fdBytes);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Eciture (et remplacement) du fichier sd
	 * 
	 * @param outputFileName nom du fichier a �crire
	 */
	public void saveToSd(String outputFileName) {
		final byte[] sdBytes = new byte[1310720];

		// G�n�ration des donn�es au format .sd
		for (int ifd=0, isd=0; ifd<fdBytes.length; ifd++) {
			// copie des donn�es fd
			sdBytes[isd] = fdBytes[ifd];
			isd++;
			// a chaque intervalle de 256 octets on ajoute 256 octets de valeur FF
			if ((ifd+1) % 256 == 0)
				for (int i=0; i<256; i++)
					sdBytes[isd++] = (byte) 0xFF;
		}

		Path outputFile = Paths.get(outputFileName+".sd");
		try {
			Files.deleteIfExists(outputFile);
			Files.createFile(outputFile);
			Files.write(outputFile, sdBytes);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
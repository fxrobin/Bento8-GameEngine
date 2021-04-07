package fr.bento8.to8.storage;

/**
 * @author Benoît Rousseau
 * @version 1.0
 *
 */
public class T2Util
{
    public static int NB_PAGES = 128;	
    public static int PAGE_SIZE = 0x4000;	
	public final byte[][] t2Bytes;

	public T2Util() {
		t2Bytes = new byte[NB_PAGES][PAGE_SIZE];
	}
}
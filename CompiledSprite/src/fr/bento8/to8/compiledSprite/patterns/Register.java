package fr.bento8.to8.compiledSprite.patterns;

public class Register {
	public static final String[] name = new String[] {"A", "B", "D", "X", "U", "Y", "S"};
	public static final int[] size = new int[] {1, 1, 2, 2, 2, 2, 2};

	public static final int[] costDirectST = new int[] {4, 4, 5, 5, 5, 6, 6};
	public static final int[] costIndexedST= new int[] {4, 4, 5, 5, 5, 6, 6};
	public static final int[] costExtendedST= new int[] {5, 5, 6, 6, 6, 7, 7};
	
	public static final int[] costImmediateLD = new int[] {2, 2, 3, 3, 3, 4, 4};
	public static final int[] costDirectLD = new int[] {4, 4, 5, 5, 5, 6, 6};
	public static final int[] costIndexedLD = new int[] {4, 4, 5, 5, 5, 6, 6};
	public static final int[] costExtendedLD= new int[] {5, 5, 6, 6, 6, 7, 7};
	
	public static final int[] costImmediateAND = new int[] {2, 2};
	public static final int[] costDirectAND = new int[] {4, 4};
	public static final int[] costIndexedAND = new int[] {4, 4};
	public static final int[] costExtendedAND= new int[] {5, 5};
	
	public static final int[] costImmediateOR = new int[] {2, 2};
	public static final int[] costDirectOR = new int[] {4, 4};
	public static final int[] costIndexedOR = new int[] {4, 4};
	public static final int[] costExtendedOR= new int[] {5, 5};

	public static final int[] costIndexedOffset = new int[] {0, 1, 1, 4};
	public static final int[] rangeMinIndexedOffset = new int[] {0, -16, -128, -32768};
	public static final int[] rangeMaxIndexedOffset = new int[] {0, 15, 127, 32767};

	public static int getPreLoadedRegister(int nbByte, byte[] data, int position, byte[][] registerValues) {
		for (int i = 0; i < registerValues.length; i++) {
			if (size[i] == nbByte && registerValues[i][0]==data[position]) {
				return i;
			}	
			if (size[i] == nbByte && registerValues[i][0]==data[position] && registerValues[i][1]==data[position]) {
				return i;
			}	
		}
		return -1;
	}

	public static int getIndexedOffsetCost(int offset) throws Exception {
		int cost = -1;
		for (int i = 0; i < costIndexedOffset.length; i++) {
			if (offset <= rangeMaxIndexedOffset[i] && offset >= rangeMinIndexedOffset[i]) {
				cost = costIndexedOffset[i];
				break;
			}
		}

		if (cost < 0) {
			throw new Exception("Offset: "+offset+" en dehors de la plage autorisée.");
		}

		return cost;
	}

}
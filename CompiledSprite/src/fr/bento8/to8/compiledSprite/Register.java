package fr.bento8.to8.compiledSprite;

public class Register {
	public static final String[] name = new String[] {"A", "B", "D", "X", "U", "Y", "S"};
	public static final int[] size = new int[] {1, 1, 2, 2, 2, 2, 2};
	
	public static final int A = 0;
	public static final int B = 1;
	public static final int D = 2;
	public static final int X = 3;
	public static final int U = 4;
	public static final int Y = 5;
	public static final int S = 6;

	public static final int[] costDirectST = new int[] {4, 4, 5, 5, 5, 6, 6};
	public static final int[] costIndexedST= new int[] {4, 4, 5, 5, 5, 6, 6};
	public static final int[] costExtendedST= new int[] {5, 5, 6, 6, 6, 7, 7};
	
	public static final int[] sizeDirectST = new int[] {2, 2, 2, 2, 2, 3, 3};
	public static final int[] sizeIndexedST= new int[] {2, 2, 2, 2, 2, 3, 3};
	public static final int[] sizeExtendedST= new int[] {3, 3, 3, 3, 3, 4, 4};
	
	public static final int[] costImmediateLD = new int[] {2, 2, 3, 3, 3, 4, 4};
	public static final int[] costDirectLD = new int[] {4, 4, 5, 5, 5, 6, 6};
	public static final int[] costIndexedLD = new int[] {4, 4, 5, 5, 5, 6, 6};
	public static final int[] costExtendedLD= new int[] {5, 5, 6, 6, 6, 7, 7};

	public static final int[] sizeImmediateLD = new int[] {2, 2, 3, 3, 3, 4, 4};
	public static final int[] sizeDirectLD = new int[] {2, 2, 2, 2, 2, 3, 3};
	public static final int[] sizeIndexedLD = new int[] {2, 2, 2, 2, 2, 3, 3};
	public static final int[] sizeExtendedLD= new int[] {2, 2, 3, 3, 3, 4, 4};
	
	public static final int[] costImmediateAND = new int[] {2, 2};
	public static final int[] costDirectAND = new int[] {4, 4};
	public static final int[] costIndexedAND = new int[] {4, 4};
	public static final int[] costExtendedAND= new int[] {5, 5};
	
	public static final int[] sizeImmediateAND = new int[] {2, 2};
	public static final int[] sizeDirectAND = new int[] {2, 2};
	public static final int[] sizeIndexedAND = new int[] {2, 2};
	public static final int[] sizeExtendedAND= new int[] {3, 3};
	
	public static final int[] costImmediateADD = new int[] {2, 2, 4};
	public static final int[] costDirectADD = new int[] {4, 4, 6};
	public static final int[] costIndexedADD = new int[] {4, 4, 6};
	public static final int[] costExtendedADD= new int[] {5, 5, 7};

	public static final int[] sizeImmediateADD = new int[] {2, 2, 3};
	public static final int[] sizeDirectADD = new int[] {2, 2, 2};
	public static final int[] sizeIndexedADD = new int[] {2, 2, 2};
	public static final int[] sizeExtendedADD= new int[] {3, 3, 3};

	public static final int[] costImmediateOR = new int[] {2, 2};
	public static final int[] costDirectOR = new int[] {4, 4};
	public static final int[] costIndexedOR = new int[] {4, 4};
	public static final int[] costExtendedOR= new int[] {5, 5};

	public static final int[] sizeImmediateOR = new int[] {2, 2};
	public static final int[] sizeDirectOR = new int[] {2, 2};
	public static final int[] sizeIndexedOR = new int[] {2, 2};
	public static final int[] sizeExtendedOR= new int[] {3, 3};
	
	public static final int[] costIndexedOffset = new int[] {0, 1, 1, 4};
	public static final int[] sizeIndexedOffset = new int[] {0, 1, 1, 2};
	public static final int[] rangeMinIndexedOffset = new int[] {0, -16, -128, -32768};
	public static final int[] rangeMaxIndexedOffset = new int[] {0, 15, 127, 32767};
	
	public static final int sizeImmediatePULPSH = 2;
	public static int getCostImmediatePULPSH(int nbByte) {
		return 5+nbByte;
	}

//	public static int[] getPreLoadedRegister(int nbByte, byte[] data, int position, byte[][] registerValues) {
//		int result[] = null;
//		
//		switch (nbByte) {
//		case 1:
//			
//			// Recherche des registres déjà chargés avec la valeur recherchée
//			for (int i = 0; i < registerValues.length; i++) {
//				if (size[i] == 1 && registerValues[i][0] == data[position]) {
//					result = new int[] {i};
//				}	
//			}
//			
//			// Sinon on cherche des registres vides (Limite à A, B, D, X en attendant un nouvel algo)
//			for (int i = 0; i < 4; i++) {
//				if (size[i] == 1 && registerValues[i][0] == -1) {
//					result = new int[] {i};
//				}	
//			}
//			
//			if (result == null) {
//				result = new int[] {A};
//			}
//			break;
//			
//		case 2:
//			
//			// Recherche des registres déjà chargés avec la valeur recherchée
//			for (int i = 0; i < registerValues.length; i++) {
//				if (size[i] == 2 && registerValues[i][0] == data[position] && registerValues[i][1] == data[position+1]) {
//					return new int[] {i};
//				}	
//			}
//			
//			// Sinon on cherche des registres vides (Limite à A, B, D, X en attendant un nouvel algo)
//			for (int i = 0; i < 4; i++) {
//				if (size[i] == 2 && registerValues[i][0] == -1 && registerValues[i][1] == -1) {
//					return new int[] {i};
//				}	
//			}
//			
//			if (result == null) {
//				result = new int[] {D};
//			}
//			break;
//			
//		case 3:
//			// AX, BX, AY (+1c), BY (+1c)
//			result = new int[] {A,X};
//			break;
//			
//		case 4:
//			// DX, DY (+1c), XY (+1c)
//			result = new int[] {D,X};
//			break;
//			
//		case 5:
//			// AXY, BXY (+1c)
//			result = new int[] {A,X,Y};
//			break;
//			
//		case 6:
//			
//			result = new int[] {D,X,Y};
//			break;
//			
//		default:
//			result = new int[] {-1};
//		}
//		
//		return result;
//	}
//	
//	public static void initRegisters(byte[][] registerValues) {
//		for (int i = 0; i < registerValues.length; i++) {
//			registerValues[i][0] = -1;
//			registerValues[i][1] = -1;
//		}
//	}
//	
//	public static void initRegister(byte[][] registerValues, int i) {
//		registerValues[i][0] = -1;
//		registerValues[i][1] = -1;
//	}

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
	
	public static int getIndexedOffsetSize(int offset) throws Exception {
		int size = -1;
		for (int i = 0; i < sizeIndexedOffset.length; i++) {
			if (offset <= rangeMaxIndexedOffset[i] && offset >= rangeMinIndexedOffset[i]) {
				size = sizeIndexedOffset[i];
				break;
			}
		}

		if (size < 0) {
			throw new Exception("Offset: "+offset+" en dehors de la plage autorisée.");
		}

		return size;
	}
}
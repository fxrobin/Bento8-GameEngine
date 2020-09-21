package fr.bento8.to8.compiledSprite;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import fr.bento8.to8.InstructionSet.Register;
import fr.bento8.to8.compiledSprite.patterns.Pattern;

public class SolutionOptim{

	private static final Logger logger = LogManager.getLogger("log");

	private Solution solution;
	private byte[] data;
	int sizeSaveS;

	int i, j, k;
	List<String> asmCode = new ArrayList<String>(); // Contient le code de sauvegarde du fond et du dessin de sprite
	List<String> asmECode = new ArrayList<String>(); // Contient le code d'effacement du sprite (restauration du fond)

	private int asmCodeCycles;
	private int asmCodeSize;
	private int asmECodeCycles;
	private int asmECodeSize;

	int lastLeas;		
	boolean[] regSet, regSetSave;
	byte[][] regVal, regValSave;

	// Variables pour le code de retablissement du fond
	List<Integer> nbBytesE = new ArrayList<Integer>();
	List<Integer> offsetE = new ArrayList<Integer>();
	List<Integer> asmCodeSIdx = new ArrayList<Integer>();

	List<Integer> patternGrp1 = new ArrayList<Integer>();
	List<Integer> patternGrp2 = new ArrayList<Integer>();
	List<Integer> patternGrp3 = new ArrayList<Integer>();

	public SolutionOptim(Solution solution, byte[] data) {
		this.solution = solution;
		this.data = data;
	}

	public void Optimize(List<Integer> patterns) throws Exception {

		if (patterns.size() > 1) {

			// Diminution du nombre de combinaisons � tester :
			// - en regroupant le valeurs �gales pour un pattern
			// - en isolant de la recherche combinatoire les valeurs uniques, qui ne peuvent donc pas b�n�ficier d'un cache registre sur le noeud
			int pos;
			long value;

			// Contient pour un pattern une liste des toutes les combinaisons de donn�es rang�es par registre
			HashMap<Integer, List<Long>> patternData = new HashMap<Integer, List<Long>>();

			// S�paration en deux groupes
			List<List<Integer>> patternOptim = new ArrayList<List<Integer>>();
			List<Long> patternOptimL = new ArrayList<Long>();
			List<Integer> patternNonOptim = new ArrayList<Integer>();

			for (int id : patterns) {

				// Parcours des combinaisons possibles de registres pour le pattern
				for (j = 0; j < solution.patterns.get(id).getRegisterCombi().size(); j++) {
					pos = solution.positions.get(id)*2;
					value = 0;

					// Parcours des registres de la combinaison
					for (k = 0; k < solution.patterns.get(id).getRegisterCombi().get(j).length; k++) {

						if (solution.patterns.get(id).getRegisterCombi().get(j)[k]) {
							// Le registre est utilis� dans la combinaison
							switch(k) {
							case Register.A: value += (((0xFL) << 60)   |(data[pos++] & 0xFFL) << 44) | ((data[pos++] & 0xFFL) << 40); break;
							case Register.B: value += (((0xFL) << 56)   |(data[pos++] & 0xFFL) << 36) | ((data[pos++] & 0xFFL) << 32); break;
							case Register.D: value += (((0xFFL) << 56) |(data[pos++] & 0xFFL) << 44) | ((data[pos++] & 0xFFL) << 40) | ((data[pos++] & 0xFFL) << 36) | ((data[pos++] & 0xFFL) << 32); break;
							case Register.X: value += (((0xFL) << 52)   |(data[pos++] & 0xFFL) << 28) | ((data[pos++] & 0xFFL) << 24) | ((data[pos++] & 0xFFL) << 20) | ((data[pos++] & 0xFFL) << 16); break;
							case Register.Y: value += (((0xFL) << 48)   |(data[pos++] & 0xFFL) << 12) | ((data[pos++] & 0xFFL) << 8)  | ((data[pos++] & 0xFFL) << 4)  | ((data[pos++] & 0xFFL) << 0); break;
							}
						}
					}

					logger.debug("\tPattern: "+id+" Combi: "+j+" Valeur " + String.format("%016x", value));

					// Ajout de la combinaison de pixels pour le pattern
					List<Long> l = new ArrayList<Long>();
					if (!patternData.containsKey(id)) {
						l = new ArrayList<Long>();
						patternData.put(id, l);
					} else {
						l = patternData.get(id);
					}
					l.add(value);
				}
			}

			// Construction des groupes de pattern pour l'optimisation
			// Chaque groupe est compos� de patterns ayant un motif strictement identique
			// Un groupe qui ne contient qu'un pattern doit avoir un motif commun sur un des 4 registres A, B, X, Y avec un autre groupe
			boolean match, matchExact;
			Long matchVal = 0L;
			List<Integer> p;
			for (int id : patterns) {
				match = false;
				matchExact = false;
				outerloop:
					for (long val : patternData.get(id)) {
						for (int idSub : patterns) {
							if (id != idSub) {
								for (long idVal : patternData.get(idSub)) {
									if (val == idVal) {
										if (!patternOptimL.contains(val)) {
											p = new ArrayList<Integer>();
											p.add(id);
											patternOptim.add(p);
											patternOptimL.add(val);
										} else {
											patternOptim.get(patternOptimL.indexOf(val)).add(id);
										}
										logger.debug("\t\tMatch Exact ("+id+", "+idSub+")");
										matchExact = true;
										match = false;
										break outerloop;
									} else if (((val & 0xF000000000000000L) >>> 60 == 0xFL   && (idVal & 0xF000000000000000L) >>> 60 == 0xFL   && (val & 0x0000FF0000000000L) >>> 40 == (idVal & 0x0000FF0000000000L) >>> 40) ||
											((val & 0x0F00000000000000L) >>> 56 == 0xFL   && (idVal & 0x0F00000000000000L) >>> 56 == 0xFL   && (val & 0x000000FF00000000L) >>> 32 == (idVal & 0x000000FF00000000L) >>> 32) ||
											((val & 0xFF00000000000000L) >>> 56 == 0xFFL  && (idVal & 0xFF00000000000000L) >>> 56 == 0xFFL  && (val & 0x0000FFFF00000000L) >>> 32 == (idVal & 0x0000FFFF00000000L) >>> 32) ||
											((val & 0x00F0000000000000L) >>> 52 == 0xFL   && (idVal & 0x00F0000000000000L) >>> 52 == 0xFL   && (val & 0x00000000FFFF0000L) >>> 16 == (idVal & 0x00000000FFFF0000L) >>> 16) ||
											((val & 0x000F000000000000L) >>> 48 == 0xFL   && (idVal & 0x000F000000000000L) >>> 48 == 0xFL   && (val & 0x000000000000FFFFL) >>> 0  == (idVal & 0x000000000000FFFFL) >>> 0)){
										logger.debug("\t\tMatch ("+id+", "+idSub+"): "+ String.format("%016x", val) + " "+ String.format("%016x", idVal));
										match = true;
										matchVal = val;
									}
								}
							}
						}
					}
				if (!matchExact) {
					if (match) {
						p = new ArrayList<Integer>();
						p.add(id);
						patternOptim.add(p);
						patternOptimL.add(matchVal);
					} else {
						patternNonOptim.add(id);
					}
				}
			}

			logger.debug("\tOptim: "+patternOptim+" NonOptim: "+patternNonOptim);

			if (patternOptim.size() > 1) {
				if (patternOptim.size() > 9) {
					OptimizeRandom(patternOptim);
				} else {
					OptimizeFactorial(patternOptim);
				}	
			}

			patterns.clear();
			patterns.addAll(patternNonOptim);

			for(List<Integer> patternGroup : patternOptim) {
				patterns.addAll(patternGroup);
			}

			logger.debug("\tSortie Optim: "+patterns);
		}
	}

	public void OptimizeFactorial(List<List<Integer>> pattern) throws Exception {

		// Sauvegarde de l'�tat des registres
		for (int i = 0; i < regSet.length; i++) {
			regSetSave[i] = regSet[i];
		}

		for (int i = 0; i < regVal.length; i++) {
			for (int j = 0; j < regVal[0].length; j++) {
				regValSave[i][j] = regVal[i][j];	
			}
		}

		// Initialisation de la solution
		List<Snippet> testSolution = new ArrayList<Snippet>();
		List<Snippet> bestSolution = new ArrayList<Snippet>();
		List<List<Integer>> bestPatterns = new ArrayList<List<Integer>>();

		// Test des combinaisons		
		int[] indexes = new int[pattern.size()];
		for (int i = 0; i < pattern.size(); i++) {
			indexes[i] = 0;
		}

		int idx = 0;
		int score = 0, bestScore = Integer.MAX_VALUE;

		while (idx < pattern.size()) {
			if (indexes[idx] < idx) {
				Collections.swap(pattern, idx % 2 == 0 ?  0: indexes[idx], idx);

				// Compute proposition
				score = 0;
				for (List<Integer> p : pattern) {
					for (int id : p) {
						testSolution.add(processPatternDraw(id, false));
						score += testSolution.get(testSolution.size()-1).getCycles();
					}
				}

				if (score < bestScore) {
					bestScore = score;
					logger.debug("score: "+score);
					bestSolution.clear();
					bestSolution.addAll(testSolution);
					bestPatterns.clear();
					bestPatterns.addAll(pattern);
				}

				testSolution.clear();

				// Restauration de l'�tat des registres
				for (int i = 0; i < regSet.length; i++) {
					regSet[i] = regSetSave[i];
				}

				for (int i = 0; i < regVal.length; i++) {
					for (int j = 0; j < regVal[0].length; j++) {
						regVal[i][j] = regValSave[i][j];	
					}
				}

				indexes[idx]++;
				idx = 0;
			}
			else {
				indexes[idx] = 0;
				idx++;
			}
		}

		// Positionne la solution
		pattern.clear();
		for(List<Integer> p : bestPatterns) {
			pattern.add(p);
		}
	}

	public static int fact (int n) {
		if (n==0) return(1);
		else return(n*fact(n-1));
	}

	public void OptimizeRandom(List<List<Integer>> pattern) throws Exception {

		// Sauvegarde de l'�tat des registres
		for (int i = 0; i < regSet.length; i++) {
			regSetSave[i] = regSet[i];
		}

		for (int i = 0; i < regVal.length; i++) {
			for (int j = 0; j < regVal[0].length; j++) {
				regValSave[i][j] = regVal[i][j];	
			}
		}

		// Initialisation de la solution
		List<Snippet> testSolution = new ArrayList<Snippet>();
		List<Snippet> bestSolution = new ArrayList<Snippet>();
		List<List<Integer>> bestPatterns = new ArrayList<List<Integer>>();

		// Test des combinaisons		
		int essais = (pattern.size()>9?fact(9):fact(pattern.size()));

		int score = 0, bestScore = Integer.MAX_VALUE;
		int a, b;
		Random rand = new Random();
		while (essais-- > 0) {
			a = rand.nextInt(pattern.size());
			b = rand.nextInt(pattern.size());
			Collections.swap(pattern, a, b);

			// Compute proposition
			score = 0;
			for (List<Integer> p : pattern) {
				for (int id : p) {
					testSolution.add(processPatternDraw(id, false));
					score += testSolution.get(testSolution.size()-1).getCycles();
				}
			}

			if (score < bestScore) {
				bestScore = score;
				logger.debug("score: "+score);
				bestSolution.clear();
				bestSolution.addAll(testSolution);
				bestPatterns.clear();
				bestPatterns.addAll(pattern);
			} else {
				Collections.swap(pattern, a, b);
			}

			testSolution.clear();

			// Restauration de l'�tat des registres
			for (int i = 0; i < regSet.length; i++) {
				regSet[i] = regSetSave[i];
			}

			for (int i = 0; i < regVal.length; i++) {
				for (int j = 0; j < regVal[0].length; j++) {
					regVal[i][j] = regValSave[i][j];	
				}
			}
		}

		// Positionne la solution
		pattern.clear();
		for(List<Integer> p : bestPatterns) {
			pattern.add(p);
		}
	}

	public void build() {
		asmCode.clear();
		asmECode.clear();
		asmCodeCycles = 0;
		asmCodeSize = 0;
		asmECodeCycles = 0;
		asmECodeSize = 0;
		regSet = new boolean[] {false, false, false, false, false, false, false};
		regVal = new byte[7][4];
		regSetSave = new boolean[] {false, false, false, false, false, false, false};
		regValSave = new byte[7][4];

		lastLeas = Integer.MAX_VALUE;	
		int currentNode = 0;
		boolean saveS;
		sizeSaveS = 0;

		try {
			// Parcours de tous les patterns
			i = 0;
			
			// Au d�but de l'image on sauvegarde S m�me s'il n'y a pas de LEAS
			saveS = true;
			
			while (i < solution.patterns.size()) {
				patternGrp1.clear();
				patternGrp2.clear();
				patternGrp3.clear();

				currentNode = solution.computedNodes.get(i);
				while (i < solution.patterns.size() && currentNode == solution.computedNodes.get(i)) {

					// Ecriture du LEAS				
					if (currentNode != lastLeas // le noeud courant est diff�rent de celui du dernier LEAS
							&& solution.computedLeas.containsKey(solution.computedNodes.get(i)) // Le noeud courant est un noeud de LEAS
							&& solution.computedLeas.get(solution.computedNodes.get(i)) != 0) { // Ignore les LEAS avec offset de 0
						asmCode.add("\tLEAS "+solution.computedLeas.get(solution.computedNodes.get(i))+",S");
						asmCodeCycles += Register.costIndexedLEA + Register.getIndexedOffsetCost(solution.computedLeas.get(solution.computedNodes.get(i)));
						asmCodeSize += Register.sizeIndexedLEA + Register.getIndexedOffsetSize(solution.computedLeas.get(solution.computedNodes.get(i)));
						lastLeas = solution.computedNodes.get(i);
						saveS = true; // On enregistre le fait qu'un LEAS a �t� produit pour ce noeud
					}

					// Constitution des groupes
					if (!solution.patterns.get(i).isBackgroundBackupAndDrawDissociable() && solution.patterns.get(i).useIndexedAddressing()) {
						patternGrp1.add(i);
					} else if (!solution.patterns.get(i).useIndexedAddressing()) {
						patternGrp2.add(i);
					} else {
						patternGrp3.add(i);
					}

					i++;
				}

				logger.debug("Noeud: "+currentNode+" Grp1: "+patternGrp1+" Grp2: "+patternGrp2+" Grp3: "+patternGrp3);
				
				// Parcours des patterns dans l'ordre des groupes 1, 3 puis 2
				for (int id : patternGrp1) {
					processPatternBackgroundBackup(id, saveS, true);
					processPatternDraw(id, true);
					asmCode.add("");
				}

				for (int id : patternGrp3) {
					processPatternBackgroundBackup(id, saveS, true);
					asmCode.add("");
				}

				Optimize(patternGrp3);

				for (int id : patternGrp3) {
					processPatternDraw(id, true);
					asmCode.add("");
				}

				// Le groupe 2 doit �tre positionn� en fin de noeud pour �tre ex�cut� en d�but de r�tablissement de fond
				// en particulier il doit �tre jou� juste apr�s le premier PULU ...,S car le PSHS va d�caler le pointeur S
				// et le poisitonner correctement pour les acc�s m�moire index�es.
				// Si on veut le positionner ailleurs il faut recalculer les offsets : c'est r�alisable.
				for (int id : patternGrp2) {
					processPatternBackgroundBackup(id, saveS, true);
					processPatternDraw(id, true);
					asmCode.add("");
				}

				// Ecriture du code de r�tablissement du fond
				if (saveS) {
					asmCodeCycles += 2; // Ajout pour la sauvegarde du S
					sizeSaveS += 2; // Agrandissement de la zone data pour la sauvegarde du S
				}
				
				asmECode.addAll(0, Pattern.getEraseCodeBuf(nbBytesE, offsetE, asmCode, asmCodeSIdx));
				asmECodeCycles += Pattern.getEraseCodeBufCycles(nbBytesE, offsetE, asmCodeSIdx);
				asmECodeSize += Pattern.getEraseCodeBufSize(nbBytesE, offsetE, asmCodeSIdx);

				logger.debug("Size Code E:"+asmECodeSize);
				
				nbBytesE.clear();
				offsetE.clear();
				asmCodeSIdx.clear();
			}
			
			saveS = false;

		} catch (Exception e) {
			logger.fatal("", e);
		}
	}

	public void processPatternBackgroundBackup(int id, boolean saveS, boolean process) throws Exception {

		// Recherche pour chaque combinaison de registres d'un pattern,
		// celle qui a le cout le moins �lev� en fonction des registres d�j� charg�s

		int cycles, selectedCombi, minCycles;
		List<Integer> currentReg = new ArrayList<Integer>();
		List<Integer> selectedReg = new ArrayList<Integer>();
		AtomicInteger lineNumS = new AtomicInteger(0);

		selectedCombi = -1;
		minCycles = Integer.MAX_VALUE;

		// Parcours des combinaisons possibles de registres pour le pattern
		for (j = 0; j < solution.patterns.get(id).getRegisterCombi().size(); j++) {
			cycles = 0;
			currentReg.clear();

			// Parcours des registres de la combinaison
			for (k = 0; k < solution.patterns.get(id).getRegisterCombi().get(j).length; k++) {

				if (solution.patterns.get(id).getRegisterCombi().get(j)[k]) {
					// Le registre est utilis� dans la combinaison
					currentReg.add(k);
				}
			}

			// Calcul du nombre de cycles de la solution courante
			cycles = solution.patterns.get(id).getBackgroundBackupCodeCycles(currentReg, solution.computedOffsets.get(id));

			// Sauvegarde de la meilleure solution
			if (cycles < minCycles) {
				selectedCombi = j;
				minCycles = cycles;
				selectedReg.clear();
				selectedReg.addAll(currentReg);
			}
		}

		if (selectedCombi == -1) {
			logger.fatal("Aucune combinaison de registres pour le pattern en position: "+solution.positions.get(id));
		}

		lineNumS.set(asmCode.size());
		asmCode.addAll(solution.patterns.get(id).getBackgroundBackupCode(selectedReg, solution.computedOffsets.get(id), lineNumS));
		asmCodeCycles += solution.patterns.get(id).getBackgroundBackupCodeCycles(selectedReg, solution.computedOffsets.get(id));
		asmCodeSize += solution.patterns.get(id).getBackgroundBackupCodeSize(selectedReg, solution.computedOffsets.get(id));

		// Si on a besoin de stocker S
		if (saveS) {
			asmCodeSIdx.add(lineNumS.get()); // enregistrement du num�ro de ligne contenant le PULU pour ajout ult�rieur du ,S par Pattern.getEraseCodeBuf
		}

		solution.patterns.get(id).addToEraseBuf(selectedReg, solution.computedOffsets.get(id), nbBytesE, offsetE);

		// R�initialisation des registres utilis�s par l'�criture du fond
		for (int r : selectedReg) {
			regSet[r] = false;
			if (r == Register.A || r == Register.B) {
				regSet[Register.D] = false;
			}
			if (r == Register.D) {
				regSet[Register.A] = false;
				regSet[Register.B] = false;
			}
		}
	}

	public Snippet processPatternDraw(int id, boolean process) throws Exception {

		// Recherche pour chaque combinaison de registres d'un pattern,
		// celle qui a le cout le moins �lev� en fonction des registres d�j� charg�s

		int cycles, selectedCombi, minCycles, pos;
		byte b1, b2, b3 = 0x00, b4 = 0x00;
		List<Integer> currentReg = new ArrayList<Integer>();
		List<Boolean> currentLoadMask = new ArrayList<Boolean>();
		List<Integer> selectedReg = new ArrayList<Integer>();
		List<Boolean> selectedLoadMask = new ArrayList<Boolean>();
		Snippet snippet = null;

		selectedCombi = -1;
		minCycles = Integer.MAX_VALUE;

		// Parcours des combinaisons possibles de registres pour le pattern
		for (j = 0; j < solution.patterns.get(id).getRegisterCombi().size(); j++) {
			cycles = 0;
			pos = solution.positions.get(id)*2;
			currentReg.clear();
			currentLoadMask.clear();

			// Parcours des registres de la combinaison
			for (k = 0; k < solution.patterns.get(id).getRegisterCombi().get(j).length; k++) {

				if (solution.patterns.get(id).getRegisterCombi().get(j)[k]) {
					// Le registre est utilis� dans la combinaison

					currentReg.add(k);

					if (regSet[k] && (solution.patterns.get(id).getResetRegisters().size() <= j || (solution.patterns.get(id).getResetRegisters().size() > j && solution.patterns.get(id).getResetRegisters().get(j)[k] == false))) {
						// Le registre contient une valeur et n'est pas concern� par un reset dans le pattern

						// Chargement des donn�es du sprite
						b1 = data[pos++];
						b2 = data[pos++];
						if (Register.size[k] == 2) {
							b3 = data[pos++];
							b4 = data[pos++];
						}

						if (k == Register.D && (regVal[k][0] != b1 || regVal[k][1] != b2) && regVal[k][2] == b3 && regVal[k][3] == b4) {
							// Correspondance partielle sur D avec B mais pas A, on charge A
							currentLoadMask.set(Register.A, true);
							currentLoadMask.set(Register.B, false);
							currentLoadMask.add(null);

						} else if (k == Register.D && regVal[k][0] == b1 && regVal[k][1] == b2 && (regVal[k][2] != b3 || regVal[k][3] != b4)) {
							// Correspondance partielle sur D avec A mais pas B, on charge B
							currentLoadMask.set(Register.A, false);
							currentLoadMask.set(Register.B, true);
							currentLoadMask.add(null);

						} else if (regVal[k][0] == b1 && regVal[k][1] == b2 && (Register.size[k] == 1 || (Register.size[k] == 2 && regVal[k][2] == b3 && regVal[k][3] == b4))){
							// Le registre contient d�j� la valeur, on ne charge rien
							currentLoadMask.add(false);

						} else {
							// Le registre contient une valeur diff�rente, on le charge
							currentLoadMask.add(true);
						}
					} else {
						// Le registre ne contient pas de valeur, on le charge
						currentLoadMask.add(true);
					}
				} else {
					// Le registre n'est pas utilis� dans la combinaison
					currentLoadMask.add(null);
				}
			}

			// Calcul du nombre de cycles de la solution courante
			cycles = solution.patterns.get(id).getDrawCodeCycles(currentReg, currentLoadMask, solution.computedOffsets.get(id));

			// Sauvegarde de la meilleure solution
			if (cycles < minCycles) {
				selectedCombi = j;
				minCycles = cycles;
				selectedReg.clear();
				selectedReg.addAll(currentReg);
				selectedLoadMask.clear();
				selectedLoadMask.addAll(currentLoadMask);
			}
		}

		if (selectedCombi == -1) {
			logger.fatal("Aucune combinaison de registres pour le pattern en position: "+solution.positions.get(id));
		}

		if (process) {
			asmCode.addAll(solution.patterns.get(id).getDrawCode(data, solution.positions.get(id)*2, selectedReg, selectedLoadMask, solution.computedOffsets.get(id)));
			asmCodeCycles += solution.patterns.get(id).getDrawCodeCycles(selectedReg, selectedLoadMask, solution.computedOffsets.get(id));
			asmCodeSize += solution.patterns.get(id).getDrawCodeSize(selectedReg, selectedLoadMask, solution.computedOffsets.get(id));
		} else {
			snippet = new Snippet(solution.patterns.get(id), data, solution.positions.get(id)*2, selectedReg, selectedLoadMask, solution.computedOffsets.get(id));
		}

		// Sauvegarde les valeurs charg�es en cache
		pos = solution.positions.get(id)*2;
		for (j = 0; j < solution.patterns.get(id).getRegisterCombi().get(selectedCombi).length; j++) {

			if (solution.patterns.get(id).getRegisterCombi().get(selectedCombi)[j] &&
					(solution.patterns.get(id).getResetRegisters().size() <= selectedCombi ||
					(solution.patterns.get(id).getResetRegisters().size() > selectedCombi &&
							!solution.patterns.get(id).getResetRegisters().get(selectedCombi)[j]))) {

				// On ne charge qui si le registre est dans la combinaison
				// et qu'il n'a pas �t� r�initialis� dans le pattern

				regSet[j] = true;
				regVal[j][0] = data[pos++];
				regVal[j][1] = data[pos++];
				if (Register.size[j] == 2) {
					regVal[j][2] = data[pos++];
					regVal[j][3] = data[pos++];
				}

				// Cas particulier de A, on valorise D
				if (j == Register.A && (regSet[Register.B] == true &&
						((solution.patterns.get(id).getResetRegisters().size() <= selectedCombi ||
						(solution.patterns.get(id).getResetRegisters().size() > selectedCombi &&
								!solution.patterns.get(id).getResetRegisters().get(selectedCombi)[Register.B]))))) {
					regSet[Register.D] = true;
					regVal[Register.D][0] = regVal[j][0];
					regVal[Register.D][1] = regVal[j][1];
				}

				// Cas particulier de B, on valorise D
				if (j == Register.B && (regSet[Register.A] == true && 
						((solution.patterns.get(id).getResetRegisters().size() <= selectedCombi ||
						(solution.patterns.get(id).getResetRegisters().size() > selectedCombi &&
								!solution.patterns.get(id).getResetRegisters().get(selectedCombi)[Register.A]))))) {
					regSet[Register.D] = true;
					regVal[Register.D][2] = regVal[j][0];
					regVal[Register.D][3] = regVal[j][1];
				}

				// Cas particulier de D, on valorise A et B
				if (j == Register.D) {
					if ((solution.patterns.get(id).getResetRegisters().size() <= selectedCombi ||
							(solution.patterns.get(id).getResetRegisters().size() > selectedCombi &&
									!solution.patterns.get(id).getResetRegisters().get(selectedCombi)[Register.A]))) {
						regSet[Register.A] = true;
						regVal[Register.A][0] = regVal[j][0];
						regVal[Register.A][1] = regVal[j][1];
					}

					if ((solution.patterns.get(id).getResetRegisters().size() <= selectedCombi ||
							(solution.patterns.get(id).getResetRegisters().size() > selectedCombi &&
									!solution.patterns.get(id).getResetRegisters().get(selectedCombi)[Register.B]))) {				
						regSet[Register.B] = true;
						regVal[Register.B][0] = regVal[j][2];
						regVal[Register.B][1] = regVal[j][3];
					}

					if (regSet[Register.A] != true || regSet[Register.B] != true ) {
						regSet[Register.D] = false;
					}
				}
			}
		}

		// R�initialisation des registres �cras�s par le pattern
		// N�cessaire si le dernier pattern a b�n�fici� du cache mais �crase les registres
		if (solution.patterns.get(id).getResetRegisters().size() > selectedCombi) {
			for (j = 0; j < solution.patterns.get(id).getResetRegisters().get(selectedCombi).length; j++) {
				if (solution.patterns.get(id).getResetRegisters().get(selectedCombi)[j]) {
					regSet[j] = false;
				}
			}
		}		

		return snippet;
	}

	public List<String> getAsmCode() {
		return asmCode;
	}

	public List<String> getAsmECode() {
		return asmECode;
	}

	public int getDataSize() {
		int size = 0;
		for (Pattern pattern : solution.patterns) {
			size += pattern.getNbBytes();
		}
		size += sizeSaveS;

		return size;
	}

	public void setSolution(Solution solution) {
		this.solution = solution;
	}

	public void setData(byte[] data) {
		this.data = data;
	}

	public int getAsmCodeCycles() {
		return asmCodeCycles;
	}

	public int getAsmCodeSize() {
		return asmCodeSize;
	}

	public int getAsmECodeCycles() {
		return asmECodeCycles;
	}

	public int getAsmECodeSize() {
		return asmECodeSize;
	}
}
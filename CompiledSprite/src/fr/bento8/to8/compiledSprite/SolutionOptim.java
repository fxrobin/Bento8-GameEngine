package fr.bento8.to8.compiledSprite;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import fr.bento8.to8.InstructionSet.Register;
import fr.bento8.to8.compiledSprite.patterns.Pattern;

public class SolutionOptim{

	private static final Logger logger = LogManager.getLogger("log");

	private int[] fact = new int[]{1, 1, 4, 10, 40, 150, 800, 6000, 40000, 360000, 3600000};

	private Solution solution;
	private byte[] data;
	int sizeSaveS;

	List<String> asmCode = new ArrayList<String>(); // Contient le code de sauvegarde du fond et du dessin de sprite
	List<String> asmECode = new ArrayList<String>(); // Contient le code d'effacement du sprite (restauration du fond)

	private int asmCodeCycles;
	private int asmCodeSize;
	private int asmECodeCycles;
	private int asmECodeSize;

	int lastLeas;
	// les variables Save sont pour les essais de solutions
	boolean[] regSet, regSetSave;
	byte[][] regVal, regValSave;

	// Variables pour le code de sauvegarde du fond
	List<List<Integer>> pshuGroup = new ArrayList<List<Integer>>();

	public SolutionOptim(Solution solution, byte[] data) {
		this.solution = solution;
		this.data = data;
	}

	private void saveState() {
		// Sauvegarde de l'état des registres
		for (int i = 0; i < regSet.length; i++) {
			regSetSave[i] = regSet[i];
		}

		for (int i = 0; i < regVal.length; i++) {
			for (int j = 0; j < regVal[0].length; j++) {
				regValSave[i][j] = regVal[i][j];	
			}
		}
	}

	private void restoreState() {
		// Rétablissement de l'état des registres
		for (int i = 0; i < regSet.length; i++) {
			regSet[i] = regSetSave[i];
		}

		for (int i = 0; i < regVal.length; i++) {
			for (int j = 0; j < regVal[0].length; j++) {
				regVal[i][j] = regValSave[i][j];	
			}
		}
	}

	public List<Snippet> OptimizeFactorial(List<Integer[]> pattern, Integer lastPattern, boolean saveS) throws Exception {

		saveState();

		// Initialisation de la solution
		Snippet s;
		List<Snippet> testSolution = new ArrayList<Snippet>();
		List<Snippet> bestSolution = new ArrayList<Snippet>();

		// Initialisation des contraintes
		HashMap<Integer, Boolean> constaints = new HashMap<Integer, Boolean>();
		Boolean isValidSolution = true;

		// Initialisation des combinaisons		
		int[] indexes = new int[pattern.size()];
		for (int i = 0; i < pattern.size(); i++) {
			indexes[i] = 0;
		}

		int idx = 0, score = 0, bestScore = Integer.MAX_VALUE, maxCombi = 1;

		// Initialisation de la meilleure solution
		for (Integer[] p : pattern) {
			if (p[0] != null) {
				bestSolution.add(processPatternBackgroundBackup(p[0], saveS));
				maxCombi *= solution.patterns.get(p[0]).getRegisterCombi().size();
			}
			if (p[1] != null) {
				bestSolution.add(processPatternDraw(p[1]));
			}
		}

		if (lastPattern != null) {
			bestSolution.add(processPatternBackgroundBackup(lastPattern, saveS));
			maxCombi *= solution.patterns.get(lastPattern).getRegisterCombi().size();
			bestSolution.add(processPatternDraw(lastPattern));
		}

		System.out.println("COMBI:"+maxCombi);
		if (maxCombi > 5) {
			maxCombi = 5;
		}
		restoreState();

		// Optimisation de la liste
		while (idx < pattern.size()) {
			if (indexes[idx] < idx) {
				Collections.swap(pattern, idx % 2 == 0 ?  0: indexes[idx], idx);

				// Vérification des contraintes
				for (Integer[] p : pattern) {
					if (p[0] != null) {
						constaints.put(p[0], true);
					}
					if (p[1] != null && !constaints.containsKey(p[1])) {
						isValidSolution = false;
						break;
					}
				}

				if (isValidSolution) {

					// Recherche combinatoire pour les combinaisons de registres
					for (int ic = 0; ic < maxCombi; ic++) {
						// Calcul de la proposition
						score = 0;

						// TODO Ajouter une boucle de n tests (a calculer en fonction du nb de combi
						// en faisant varier les combi utilisés pour les BB
						// le combi essayé est déterminé par random dans la mthode process

						for (Integer[] p : pattern) {
							if (p[0] != null) {
								s = processPatternBackgroundBackup(p[0], saveS);
								testSolution.add(s);
								score += s.getCycles();		
							}
							if (p[1] != null) {
								s = processPatternDraw(p[1]);
								testSolution.add(s);
								score += s.getCycles();		
							}
						}

						if (lastPattern != null) {
							s = processPatternBackgroundBackup(lastPattern, saveS);
							testSolution.add(s);
							score += s.getCycles();

							s = processPatternDraw(lastPattern);
							testSolution.add(s);
							score += s.getCycles();
						}

						score += Pattern.getEraseCodeBufCycles(saveS, testSolution);

						if (score < bestScore) {
							bestScore = score;
							logger.debug("score: "+score);
							bestSolution.clear();
							bestSolution.addAll(testSolution);
						}

						testSolution.clear();
						restoreState();
					}
				}

				constaints.clear();
				isValidSolution = true;

				indexes[idx]++;
				idx = 0;
			}
			else {
				indexes[idx] = 0;
				idx++;
			}
		}

		return bestSolution;
	}

	public List<Snippet> OptimizeRandom(List<Integer[]> pattern, Integer lastPattern, boolean saveS) throws Exception {

		saveState();

		// Initialisation de la solution
		Snippet s;
		List<Snippet> testSolution = new ArrayList<Snippet>();
		List<Snippet> bestSolution = new ArrayList<Snippet>();

		// Initialisation des contraintes
		HashMap<Integer, Boolean> constaints = new HashMap<Integer, Boolean>();
		Boolean isValidSolution = true;
		
		int maxCombi = 1;

		// Initialisation de la meilleure solution
		for (Integer[] p : pattern) {
			if (p[0] != null) {
				bestSolution.add(processPatternBackgroundBackup(p[0], saveS));
				maxCombi *= solution.patterns.get(p[0]).getRegisterCombi().size();
			}
			if (p[1] != null) {
				bestSolution.add(processPatternDraw(p[1]));
			}
		}

		if (lastPattern != null) {
			bestSolution.add(processPatternBackgroundBackup(lastPattern, saveS));
			maxCombi *= solution.patterns.get(lastPattern).getRegisterCombi().size();
			bestSolution.add(processPatternDraw(lastPattern));
		}

		System.out.println("COMBI:"+maxCombi);
		if (maxCombi > 5) {
			maxCombi = 5;
		}
		restoreState();

		// Test des combinaisons		
		int essais = (pattern.size()>9?fact[9]:fact[pattern.size()]);

		int score = 0, bestScore = Integer.MAX_VALUE;
		int a=0, b=0;
		Random rand = new Random();
		while (essais-- > 0) {
			if (pattern.size() > 0) {
				a = rand.nextInt(pattern.size());
				b = rand.nextInt(pattern.size());
				Collections.swap(pattern, a, b);
			}

			// Vérification des contraintes
			for (Integer[] p : pattern) {
				if (p[0] != null) {
					constaints.put(p[0], true);
				}
				if (p[1] != null && !constaints.containsKey(p[1])) {
					isValidSolution = false;
					break;
				}
			}

			if (isValidSolution) {

				// Recherche combinatoire pour les combinaisons de registres
				for (int ic = 0; ic < maxCombi; ic++) {
					// Calcul de la proposition
					score = 0;
					for (Integer[] p : pattern) {
						if (p[0] != null) {
							s = processPatternBackgroundBackup(p[0], saveS);
							testSolution.add(s);
							score += s.getCycles();		
						}
						if (p[1] != null) {
							s = processPatternDraw(p[1]);
							testSolution.add(s);
							score += s.getCycles();		
						}
					}

					if (lastPattern != null) {
						s = processPatternBackgroundBackup(lastPattern, saveS);
						testSolution.add(s);
						score += s.getCycles();

						s = processPatternDraw(lastPattern);
						testSolution.add(s);
						score += s.getCycles();
					}

					score += Pattern.getEraseCodeBufCycles(saveS, testSolution);

					if (score < bestScore) {
						bestScore = score;
						logger.debug("score: "+score);
						bestSolution.clear();
						bestSolution.addAll(testSolution);
					} else {
						// Meilleurs résultats si ligne suivante commentée
						// Collections.swap(pattern, a, b);
					}

					testSolution.clear();
					restoreState();
				}

			} else {
				// Meilleurs résultats si ligne suivante commentée
				// Collections.swap(pattern, a, b);
			}

			constaints.clear();
			isValidSolution = true;
		}

		return bestSolution;
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

		List<Snippet> bestSolution = new ArrayList<Snippet>();
		List<Integer[]> patterns = new ArrayList<Integer[]>();
		Integer lastPattern;

		lastLeas = Integer.MAX_VALUE;	
		int currentNode = 0;
		boolean saveS;
		sizeSaveS = 0;

		try {
			// Parcours de tous les patterns
			int i = 0;

			// Au début de l'image on sauvegarde S même s'il n'y a pas de LEAS
			saveS = true;

			while (i < solution.patterns.size()) {
				patterns.clear();
				lastPattern = null;

				currentNode = solution.computedNodes.get(i);
				while (i < solution.patterns.size() && currentNode == solution.computedNodes.get(i)) {

					// Ecriture du LEAS				
					if (currentNode != lastLeas // le noeud courant est différent de celui du dernier LEAS
							&& solution.computedLeas.containsKey(solution.computedNodes.get(i)) // Le noeud courant est un noeud de LEAS
							&& solution.computedLeas.get(solution.computedNodes.get(i)) != 0) { // Ignore les LEAS avec offset de 0
						asmCode.add("\tLEAS "+solution.computedLeas.get(solution.computedNodes.get(i))+",S");
						asmCode.add("");
						asmCodeCycles += Register.costIndexedLEA + Register.getIndexedOffsetCost(solution.computedLeas.get(solution.computedNodes.get(i)));
						asmCodeSize += Register.sizeIndexedLEA + Register.getIndexedOffsetSize(solution.computedLeas.get(solution.computedNodes.get(i)));
						lastLeas = solution.computedNodes.get(i);
						saveS = true; // On enregistre le fait qu'un LEAS a été produit pour ce noeud
					}

					// Constitution des groupes
					if (!solution.patterns.get(i).isBackgroundBackupAndDrawDissociable() && solution.patterns.get(i).useIndexedAddressing()) {
						patterns.add(new Integer[] {i, i});
					} else if (!solution.patterns.get(i).useIndexedAddressing()) {
						// Le stack blast doit être positionné en fin de noeud pour être exécuté en début de rétablissement de fond
						// en particulier il doit être joué juste après le premier PULU ...,S car le PSHS va décaler le pointeur S
						// et le poisitonner correctement pour les accès mémoire indexées.
						// Si on veut le positionner ailleurs il faut recalculer les offsets : c'est réalisable ... mais risque d'être long à coder
						lastPattern = i;
					} else {
						patterns.add(new Integer[] {i, null});
						patterns.add(new Integer[] {null, i});
					}

					i++;
				}

				logger.debug("Noeud: "+currentNode+" nb. patterns: "+patterns.size());

				// Optimisation combinatoire
				if (patterns.size() < 2 || patterns.size() > 7) {
					bestSolution = OptimizeRandom(patterns, lastPattern, saveS);
				} else {
					bestSolution = OptimizeFactorial(patterns, lastPattern, saveS);
				}	

				// Enrichissement de la solution avec le positionnement de la sauvegarde du S
				Pattern.optimEraseCodeBuf(saveS, bestSolution);
				if (saveS)
					sizeSaveS += 2;

				// Execution de la solution optimisée
				for (Snippet s : bestSolution) {
					asmCode.addAll(s.call());
					asmCodeCycles += s.getCycles();
					asmCodeSize += s.getSize();
				}

				asmECode.addAll(0, Pattern.getEraseCodeBuf(saveS, bestSolution));
				asmECodeCycles += Pattern.getEraseCodeBufCycles(saveS, bestSolution);
				asmECodeSize += Pattern.getEraseCodeBufSize(saveS, bestSolution);
			}

			saveS = false;

		} catch (Exception e) {
			logger.fatal("", e);
		}
	}

	public Snippet processPatternBackgroundBackup(int id, boolean saveS) throws Exception {

		List<Integer> selectedReg = new ArrayList<Integer>();
		Snippet snippet = null;

		// Choix d'une combinaison de registres au hasard
		Random rand = new Random();
		//logger.debug(solution.patterns.get(id).getClass().getName()+" "+solution.patterns.get(id).getRegisterCombi().size());
		int j = rand.nextInt(solution.patterns.get(id).getRegisterCombi().size());

		// Parcours des registres de la combinaison
		for (int k = 0; k < solution.patterns.get(id).getRegisterCombi().get(j).length; k++) {

			if (solution.patterns.get(id).getRegisterCombi().get(j)[k]) {
				// Le registre est utilisé dans la combinaison
				selectedReg.add(k);
			}
		}

		// Sauvegarde de la méthode a exécuter
		snippet = new Snippet(solution.patterns.get(id), selectedReg, solution.computedOffsets.get(id));

		// Réinitialisation des registres utilisés par l'écriture du fond
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

		return snippet;
	}

	public Snippet processPatternDraw(int id) throws Exception {

		// Recherche pour chaque combinaison de registres d'un pattern,
		// celle qui a le cout le moins élevé en fonction des registres déjà chargés

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
		for (int j = 0; j < solution.patterns.get(id).getRegisterCombi().size(); j++) {
			cycles = 0;
			pos = solution.positions.get(id)*2;
			currentReg.clear();
			currentLoadMask.clear();

			// Parcours des registres de la combinaison
			for (int k = 0; k < solution.patterns.get(id).getRegisterCombi().get(j).length; k++) {

				if (solution.patterns.get(id).getRegisterCombi().get(j)[k]) {
					// Le registre est utilisé dans la combinaison

					currentReg.add(k);

					if (regSet[k] && (solution.patterns.get(id).getResetRegisters().size() <= j || (solution.patterns.get(id).getResetRegisters().size() > j && solution.patterns.get(id).getResetRegisters().get(j)[k] == false))) {
						// Le registre contient une valeur et n'est pas concerné par un reset dans le pattern

						// Chargement des données du sprite
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
							// Le registre contient déjà la valeur, on ne charge rien
							currentLoadMask.add(false);

						} else {
							// Le registre contient une valeur différente, on le charge
							currentLoadMask.add(true);
						}
					} else {
						// Le registre ne contient pas de valeur, on le charge
						currentLoadMask.add(true);
					}
				} else {
					// Le registre n'est pas utilisé dans la combinaison
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

		// Sauvegarde de la méthode a exécuter
		snippet = new Snippet(solution.patterns.get(id), data, solution.positions.get(id)*2, selectedReg, selectedLoadMask, solution.computedOffsets.get(id));

		// Sauvegarde les valeurs chargées en cache
		pos = solution.positions.get(id)*2;
		for (int j = 0; j < solution.patterns.get(id).getRegisterCombi().get(selectedCombi).length; j++) {

			if (solution.patterns.get(id).getRegisterCombi().get(selectedCombi)[j] &&
					(solution.patterns.get(id).getResetRegisters().size() <= selectedCombi ||
					(solution.patterns.get(id).getResetRegisters().size() > selectedCombi &&
							!solution.patterns.get(id).getResetRegisters().get(selectedCombi)[j]))) {

				// On ne charge qui si le registre est dans la combinaison
				// et qu'il n'a pas été réinitialisé dans le pattern

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

		// Réinitialisation des registres écrasés par le pattern
		// Nécessaire si le dernier pattern a bénéficié du cache mais écrase les registres
		if (solution.patterns.get(id).getResetRegisters().size() > selectedCombi) {
			for (int j = 0; j < solution.patterns.get(id).getResetRegisters().get(selectedCombi).length; j++) {
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
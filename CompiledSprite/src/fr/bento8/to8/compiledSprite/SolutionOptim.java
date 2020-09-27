package fr.bento8.to8.compiledSprite;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;
import java.util.Random;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import fr.bento8.to8.InstructionSet.Register;
import fr.bento8.to8.compiledSprite.patterns.Pattern;

public class SolutionOptim{

	private static final Logger logger = LogManager.getLogger("log");

	private int[] fact = new int[]{1, 1, 4, 10, 40, 150, 800, 6000, 40000, 5000000};

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
	boolean[] regBBSet = new boolean[7];
	Integer[] offsetBBSet = new Integer[7];
	int regBBIdx = -1;

	// Variables pour le code de sauvegarde du fond
	List<List<Integer>> pshuGroup = new ArrayList<List<Integer>>();

	// Variables pour le code de retablissement du fond
	List<Integer> regE = new ArrayList<Integer>(), regEBest = new ArrayList<Integer>();
	List<Integer> offsetE = new ArrayList<Integer>(), offsetEBest = new ArrayList<Integer>();

	public SolutionOptim(Solution solution, byte[] data) {
		this.solution = solution;
		this.data = data;
	}

	private void saveState() {
		// Sauvegarde de l'�tat des registres
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

		regBBIdx = -1;
		for (int i = 0; i < regBBSet.length; i++) {
			regBBSet[i] = false;
			offsetBBSet[i] = null;
		}

		regE.clear();
		offsetE.clear();

		// R�tablissement de l'�tat des registres
		for (int i = 0; i < regSet.length; i++) {
			regSet[i] = regSetSave[i];
		}

		for (int i = 0; i < regVal.length; i++) {
			for (int j = 0; j < regVal[0].length; j++) {
				regVal[i][j] = regValSave[i][j];	
			}
		}
	}

	public List<Snippet> OptimizeUFactorial(List<List<Integer[]>> pattern, Integer lastPattern, boolean saveS, int[] ind) throws Exception {

		saveState();

		// Initialisation de la solution
		Snippet s = null;
		List<Snippet> testSolution = new ArrayList<Snippet>();
		List<Snippet> bestSolution = new ArrayList<Snippet>();

		// Initialisation des contraintes
		HashMap<Integer, Boolean> constaints = new HashMap<Integer, Boolean>();
		Boolean isValidSolution = true;

		// Gestion des combinaisons		
		boolean has_next = true;

		int score = 0, bestScore = Integer.MAX_VALUE;

		//log.printf("> Processed %d/%d\r", ++yourCounter, maxCounter)

		// Initialisation de la meilleure solution
		logger.debug("patterns: ");
		for (List<Integer[]> pl : pattern) {
			logger.debug(".");
			for (Integer[] p : pl) {
				logger.debug("("+(p[0] != null?p[0]:"null")+","+(p[1] != null?p[1]:"null")+")");
				if (p[0] != null) {
					s = processPatternBackgroundBackup(p[0], saveS, s);
					bestSolution.add(s);
				}
				if (p[1] != null) {
					bestSolution.add(processPatternDraw(p[1], s));
				}
			}
		}
		logger.debug("groupes: "+Arrays.toString(ind));

		if (lastPattern != null) {
			s = processPatternBackgroundBackup(lastPattern, saveS, s);
			bestSolution.add(s);
			bestSolution.add(processPatternDraw(lastPattern, s));
		}

		// flush du pr�c�dent pattern et purge des registres
		for (int i = regBBSet.length-1; i >= 0; i--) {
			if (regBBSet[i]) {
				s.addRegisterPSH(i);

				// Pour chaque registre sauvegard� dans les donn�es du fond
				// On enregistre l'id du registre et l'offset associ�
				// dans le cas d'un stack blast, on enregistre un index null
				regE.add(i);
				offsetE.add(offsetBBSet[i]);
			}
			regBBSet[i] = false;
			offsetBBSet[i] = null;
		}
		regBBIdx = -1;

		regEBest.clear();
		regEBest.addAll(regE);
		offsetEBest.clear();
		offsetEBest.addAll(offsetE);

		restoreState();

		// Optimisation de la liste
		while(has_next) {
			has_next = false;

			// V�rification des contraintes
			for (List<Integer[]> pl : pattern) {
				for (Integer[] p : pl) {
					if (p[0] != null) {
						constaints.put(p[0], true);
					}
					if (p[1] != null && !constaints.containsKey(p[1])) {
						isValidSolution = false;
						break;
					}
				}
			}

			if (isValidSolution) {

				// Calcul de la proposition
				score = 0;
				s = null;
				for (List<Integer[]> pl : pattern) {
					for (Integer[] p : pl) {
						if (p[0] != null) {
							s = processPatternBackgroundBackup(p[0], saveS, s);
							testSolution.add(s);
						}
						if (p[1] != null) {
							testSolution.add(processPatternDraw(p[1], s));
						}
					}
				}

				if (lastPattern != null) {
					s = processPatternBackgroundBackup(lastPattern, saveS, s);
					testSolution.add(s);
					testSolution.add(processPatternDraw(lastPattern, s));
				}

				// flush du pr�c�dent pattern et purge des registres
				for (int i = regBBSet.length-1; i >= 0; i--) {
					if (regBBSet[i]) {
						s.addRegisterPSH(i);

						// Pour chaque registre sauvegard� dans les donn�es du fond
						// On enregistre l'id du registre et l'offset associ�
						// dans le cas d'un stack blast, on enregistre un index null
						regE.add(i);
						offsetE.add(offsetBBSet[i]);
					}
					regBBSet[i] = false;
					offsetBBSet[i] = null;
				}
				regBBIdx = -1;

				// Calcul des cycles pour la solution
				for (Snippet ts : testSolution) {
					score += ts.getCycles();
				}

				score += Pattern.getEraseCodeBufCycles(testSolution, regE, offsetE);

				if (score < bestScore) {
					bestScore = score;
					logger.debug("score: "+score);
					bestSolution.clear();
					bestSolution.addAll(testSolution);
					regEBest.clear();
					regEBest.addAll(regE);
					offsetEBest.clear();
					offsetEBest.addAll(offsetE);
				}

				testSolution.clear();
				restoreState();
			}

			constaints.clear();
			isValidSolution = true;

			// G�n�ration de combinaisons uniques
			// Ne permute pas les �l�ments d'un m�me groupe
			for(int tail = ind.length - 1;tail > 0;tail--) {
				if (ind[tail - 1] < ind[tail]) {

					// trouve le dernier �l�ment qui ne d�passe pas ind[tail-1]
					int l = ind.length - 1;
					while(ind[tail-1] >= ind[l])
						l--;

					swap(ind, tail-1, l);
					Collections.swap(pattern, tail-1, l);

					// inverse l'ordre en fin de tableau
					for(int i = tail, j = ind.length - 1; i < j; i++, j--){
						swap(ind, i, j);
						Collections.swap(pattern, i, j);
					}
					has_next = true;
					break;
				}
			}
		}

		return bestSolution;
	}

	private void swap(int[] arr, int i, int j){
		int t = arr[i];
		arr[i] = arr[j];
		arr[j] = t;
	}

	public List<Snippet> OptimizeRandom(List<List<Integer[]>> pattern, Integer lastPattern, boolean saveS) throws Exception {

		saveState();

		// Initialisation de la solution
		Snippet s = null;
		List<Snippet> testSolution = new ArrayList<Snippet>();
		List<Snippet> bestSolution = new ArrayList<Snippet>();

		// Initialisation des contraintes
		HashMap<Integer, Boolean> constaints = new HashMap<Integer, Boolean>();
		Boolean isValidSolution = true;

		// Initialisation de la meilleure solution
		for (List<Integer[]> pl : pattern) {
			for (Integer[] p : pl) {
				if (p[0] != null) {
					s = processPatternBackgroundBackup(p[0], saveS, s);
					bestSolution.add(s);
				}
				if (p[1] != null) {
					bestSolution.add(processPatternDraw(p[1], s));
				}
			}
		}

		if (lastPattern != null) {
			s = processPatternBackgroundBackup(lastPattern, saveS, s);
			bestSolution.add(s);
			bestSolution.add(processPatternDraw(lastPattern, s));
		}

		// flush du pr�c�dent pattern et purge des registres
		for (int i = regBBSet.length-1; i >= 0; i--) {
			if (regBBSet[i]) {
				s.addRegisterPSH(i);

				// Pour chaque registre sauvegard� dans les donn�es du fond
				// On enregistre l'id du registre et l'offset associ�
				// dans le cas d'un stack blast, on enregistre un index null
				regE.add(i);
				offsetE.add(offsetBBSet[i]);
			}
			regBBSet[i] = false;
			offsetBBSet[i] = null;
		}
		regBBIdx = -1;

		regEBest.clear();
		regEBest.addAll(regE);
		offsetEBest.clear();
		offsetEBest.addAll(offsetE);

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

			// V�rification des contraintes
			for (List<Integer[]> pl : pattern) {
				for (Integer[] p : pl) {
					if (p[0] != null) {
						constaints.put(p[0], true);
					}
					if (p[1] != null && !constaints.containsKey(p[1])) {
						isValidSolution = false;
						break;
					}
				}
			}

			if (isValidSolution) {

				// Calcul de la proposition
				score = 0;
				s = null;
				for (List<Integer[]> pl : pattern) {
					for (Integer[] p : pl) {
						if (p[0] != null) {
							s = processPatternBackgroundBackup(p[0], saveS, s);
							testSolution.add(s);
						}
						if (p[1] != null) {
							testSolution.add(processPatternDraw(p[1], s));
						}
					}
				}

				if (lastPattern != null) {
					s = processPatternBackgroundBackup(lastPattern, saveS, s);
					testSolution.add(s);
					testSolution.add(processPatternDraw(lastPattern, s));
				}

				// flush du pr�c�dent pattern et purge des registres
				for (int i = regBBSet.length-1; i >= 0; i--) {
					if (regBBSet[i]) {
						s.addRegisterPSH(i);

						// Pour chaque registre sauvegard� dans les donn�es du fond
						// On enregistre l'id du registre et l'offset associ�
						// dans le cas d'un stack blast, on enregistre un index null
						regE.add(i);
						offsetE.add(offsetBBSet[i]);
					}
					regBBSet[i] = false;
					offsetBBSet[i] = null;
				}
				regBBIdx = -1;

				// Calcul des cycles pour la solution
				for (Snippet ts : testSolution) {
					score += ts.getCycles();
				}

				score += Pattern.getEraseCodeBufCycles(testSolution, regE, offsetE);

				if (score < bestScore) {
					bestScore = score;
					logger.debug("score: "+score);
					bestSolution.clear();
					bestSolution.addAll(testSolution);
					regEBest.clear();
					regEBest.addAll(regE);
					offsetEBest.clear();
					offsetEBest.addAll(offsetE);
				} else {
					// Meilleurs r�sultats si ligne suivante comment�e
					// Collections.swap(pattern, a, b);
				}

				testSolution.clear();
				restoreState();
			} else {
				// Meilleurs r�sultats si ligne suivante comment�e
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
		List<List<Integer[]>> patterns = new ArrayList<List<Integer[]>>();
		Integer lastPattern;

		lastLeas = Integer.MAX_VALUE;	
		int currentNode = 0;
		boolean saveS;
		sizeSaveS = 0;

		int[] ind;
		HashMap<Integer, Integer> hm = new HashMap<Integer, Integer>();

		try {
			// Parcours de tous les patterns
			int i = 0;

			// Au d�but de l'image on sauvegarde S m�me s'il n'y a pas de LEAS
			saveS = true;
			Integer hash;

			while (i < solution.patterns.size()) {
				patterns.clear();
				lastPattern = null;

				currentNode = solution.computedNodes.get(i);
				hm.clear();
				int g = 0;
				Integer value1 = null, value2 = null, value3 = null, value4 = null;
				while (i < solution.patterns.size() && currentNode == solution.computedNodes.get(i)) {

					// Ecriture du LEAS				
					if (currentNode != lastLeas // le noeud courant est diff�rent de celui du dernier LEAS
							&& solution.computedLeas.containsKey(solution.computedNodes.get(i)) // Le noeud courant est un noeud de LEAS
							&& solution.computedLeas.get(solution.computedNodes.get(i)) != 0) { // Ignore les LEAS avec offset de 0
						asmCode.add("\tLEAS "+solution.computedLeas.get(solution.computedNodes.get(i))+",S");
						asmCode.add("");
						asmCodeCycles += Register.costIndexedLEA + Register.getIndexedOffsetCost(solution.computedLeas.get(solution.computedNodes.get(i)));
						asmCodeSize += Register.sizeIndexedLEA + Register.getIndexedOffsetSize(solution.computedLeas.get(solution.computedNodes.get(i)));
						lastLeas = solution.computedNodes.get(i);
						saveS = true; // On enregistre le fait qu'un LEAS a �t� produit pour ce noeud
					}

					// Parcours des patterns et assignation d'un groupe
					// Split des patterns en deux (sauvegadre fond et �criture)
					if (!solution.patterns.get(i).isBackgroundBackupAndDrawDissociable() && solution.patterns.get(i).useIndexedAddressing()) {
						value1 = null;
						value2 = null;
						value3 = null;
						value4 = null;
						hash = Objects.hash(0, solution.patterns.get(i).getNbBytes(),
								solution.patterns.get(i).isBackgroundBackupAndDrawDissociable(),
								Arrays.deepToString(solution.patterns.get(i).getResetRegisters().toArray()), value1, value2, value3, value4);
						Integer n = hm.get(hash);
						if (n == null){
							hm.put(hash, g);
							n = g;
							patterns.add(new ArrayList<Integer[]>());
							g++;
						}
						patterns.get(n).add(new Integer[] {i, i});

					} else if (!solution.patterns.get(i).useIndexedAddressing()) {
						// Le stack blast doit �tre positionn� en fin de noeud pour �tre ex�cut� en d�but de r�tablissement de fond
						// en particulier il doit �tre jou� juste apr�s le premier PULU ...,S car le PSHS va d�caler le pointeur S
						// et le poisitonner correctement pour les acc�s m�moire index�es.
						// Si on veut le positionner ailleurs il faut recalculer les offsets : c'est r�alisable ... mais risque d'�tre long � coder
						lastPattern = i;
					} else {
						value1 = null;
						value2 = null;
						value3 = null;
						value4 = null;
						//						hash = Objects.hash(0, solution.patterns.get(i).getNbBytes(),
						//								solution.patterns.get(i).isBackgroundBackupAndDrawDissociable(),
						//								Arrays.deepToString(solution.patterns.get(i).getResetRegisters().toArray()), value1, value2, value3, value4);
						//						Integer n = hm.get(hash);
						Integer n = null;
						if (n == null){
							//hm.put(hash, g);
							n = g;
							patterns.add(new ArrayList<Integer[]>());
							g++;
						}
						patterns.get(n).add(new Integer[] {i, null});

						if (solution.patterns.get(i).getNbBytes() == 1) {
							value1 = (int)data[(solution.positions.get(i)*2)];
							value2 = (int)data[(solution.positions.get(i)*2)+1];
							value3 = null;
							value4 = null;
						} else {
							value1 = (int)data[(solution.positions.get(i)*2)];
							value2 = (int)data[(solution.positions.get(i)*2)+1];
							value3 = (int)data[(solution.positions.get(i)*2)+2];
							value4 = (int)data[(solution.positions.get(i)*2)+3];
						}

						hash = Objects.hash(1, solution.patterns.get(i).getNbBytes(),
								solution.patterns.get(i).isBackgroundBackupAndDrawDissociable(),
								Arrays.deepToString(solution.patterns.get(i).getResetRegisters().toArray()), value1, value2, value3, value4);
						n = hm.get(hash);
						if (n == null){
							hm.put(hash, g);
							n = g;
							patterns.add(new ArrayList<Integer[]>());
							g++;
						}
						patterns.get(n).add(new Integer[] {null, i});
					}

					i++;
				}		

				int nbPatterns = 0;
				ind = new int[patterns.size()];
				for (int j = 0; j < ind.length; j++) {
					ind[j] = j;
					nbPatterns += patterns.get(j).size();
				}

				logger.debug("Noeud: "+currentNode+" nb. patterns: "+nbPatterns+" nb. groupes: "+ind.length);

				// Optimisation combinatoire
				if (ind.length < 10) {
					bestSolution = OptimizeUFactorial(patterns, lastPattern, saveS, ind);
				} else {
					bestSolution = OptimizeRandom(patterns, lastPattern, saveS);
				}	

				// Enrichissement de la solution avec le positionnement de la sauvegarde du S
				Pattern.placeS(saveS, bestSolution, regEBest, offsetEBest);
				if (saveS)
					sizeSaveS += 2;

				// Execution de la solution optimis�e
				for (Snippet s : bestSolution) {
					asmCode.addAll(s.call());
					asmCodeCycles += s.getCycles();
					asmCodeSize += s.getSize();
				}

				logger.debug("Cycles: "+asmCodeCycles);

				asmECode.addAll(0, Pattern.getEraseCodeBuf(bestSolution, regEBest, offsetEBest));
				asmECodeCycles += Pattern.getEraseCodeBufCycles(bestSolution, regEBest, offsetEBest);
				asmECodeSize += Pattern.getEraseCodeBufSize(bestSolution, regEBest, offsetEBest);

				logger.debug("CyclesE: "+asmECodeCycles);
			}

			saveS = false;

		} catch (Exception e) {
			logger.fatal("", e);
		}
	}

	public Snippet processPatternBackgroundBackup(int id, boolean saveS, Snippet lastSnippet) throws Exception {

		List<Integer> selectedRegPUL = new ArrayList<Integer>();
		List<Integer> selectedRegPSH = new ArrayList<Integer>();
		Snippet snippet = null;

		int bestCombi = -1;
		int minIdx = 8;
		int bestMinIdx = 8;
		int bestMaxIdx = -1;
		int maxIdx = -1;
		boolean isValid = true;

		// TODO gestion erase de registres en fonction des instructions pass�es

		// Parcours des combinaisons possibles
		// Selection de la combinaison qui satisfait les registres d�j� occup�s
		// et laisse un maximum de registres libres � droite
		for (int j = 0; j < solution.patterns.get(id).getRegisterCombi().size() ; j++) {
			for (int k = 0; k < solution.patterns.get(id).getRegisterCombi().get(j).length; k++) {
				if (solution.patterns.get(id).getRegisterCombi().get(j)[k]) {
					if (k <= regBBIdx || (k == Register.D && regBBIdx <= Register.B)) {
						isValid = false;
						break;
					}
					if (k > maxIdx) {
						maxIdx = k;
					}
					if (k < minIdx) {
						minIdx = k;
					}
				}
			}
			if (isValid && minIdx < bestMinIdx) {
				bestMinIdx = minIdx;
				bestMaxIdx = maxIdx;
				bestCombi = j;
			}
			isValid = true;
			minIdx = solution.patterns.get(id).getRegisterCombi().size()+1;
			maxIdx = -1;
		}

		if (bestCombi == -1) {
			// Il n'y plus la place pour une nouvelle combinaison
			// On rejoue la s�lection mais sans la contrainte des pr�c�dents registres

			// flush du pr�c�dent pattern et purge des registres
			for (int i = regBBSet.length-1; i >= 0; i--) {
				if (regBBSet[i]) {
					lastSnippet.addRegisterPSH(i);

					// Pour chaque registre sauvegard� dans les donn�es du fond
					// On enregistre l'id du registre et l'offset associ�
					// dans le cas d'un stack blast, on enregistre un index null
					regE.add(i);
					offsetE.add(offsetBBSet[i]);
				}
				regBBSet[i] = false;
				offsetBBSet[i] = null;
			}
			regBBIdx = -1;

			for (int j = 0; j < solution.patterns.get(id).getRegisterCombi().size() ; j++) {
				for (int k = 0; k < solution.patterns.get(id).getRegisterCombi().get(j).length; k++) {
					if (solution.patterns.get(id).getRegisterCombi().get(j)[k]) {
						if (k > maxIdx) {
							maxIdx = k;
						}
						if (k < minIdx) {
							minIdx = k;
						}
					}
				}
				if (minIdx < bestMinIdx) {
					bestMinIdx = minIdx;
					bestMaxIdx = maxIdx;
					bestCombi = j;
				}
				minIdx = solution.patterns.get(id).getRegisterCombi().size()+1;
				maxIdx = -1;
			}
		}

		regBBIdx = bestMaxIdx;

		// Parcours des registres de la combinaison
		for (int k = 0; k < solution.patterns.get(id).getRegisterCombi().get(bestCombi).length; k++) {
			if (solution.patterns.get(id).getRegisterCombi().get(bestCombi)[k]) {
				// Le registre est utilis� dans la combinaison
				selectedRegPUL.add(k);
				regBBSet[k] = true;
				offsetBBSet[k] = solution.computedOffsets.get(id);
			}
		}

		// Sauvegarde de la m�thode a ex�cuter
		snippet = new Snippet(solution.patterns.get(id), selectedRegPUL, selectedRegPSH, solution.computedOffsets.get(id), bestCombi);

		// R�initialisation des registres utilis�s par l'�criture du fond
		for (int r : selectedRegPUL) {
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

	public Snippet processPatternDraw(int id, Snippet lastSnippet) throws Exception {

		// Recherche pour chaque combinaison de registres d'un pattern,
		// celle qui a le cout le moins �lev� en fonction des registres d�j� charg�s

		int cycles, selectedCombi, minCycles, pos;
		byte b1, b2, b3 = 0x00, b4 = 0x00;
		List<Integer> currentReg = new ArrayList<Integer>();
		List<Boolean> currentLoadMask = new ArrayList<Boolean>();
		List<Integer> selectedReg = new ArrayList<Integer>();
		List<Boolean> selectedLoadMask = new ArrayList<Boolean>();
		Snippet snippet = null;
		List<boolean[]> combiList = new ArrayList<boolean[]>();

		selectedCombi = -1;
		minCycles = Integer.MAX_VALUE;

		// Parcours des combinaisons possibles de registres pour le pattern
		// Cas particulier:
		// Gestion des patterns non dissociables, on doit utiliser la m�me
		// combinaison que celle utilis�e pour la sauvegarde du fond
		if (!solution.patterns.get(id).isBackgroundBackupAndDrawDissociable() && solution.patterns.get(id).useIndexedAddressing()) {
			combiList.add(solution.patterns.get(id).getRegisterCombi().get(lastSnippet.getCombiIdx()));
		} else {
			combiList = solution.patterns.get(id).getRegisterCombi();
		}

		for (int j = 0; j < combiList.size(); j++) {
			cycles = 0;
			pos = solution.positions.get(id)*2;
			currentReg.clear();
			currentLoadMask.clear();

			// Parcours des registres de la combinaison
			for (int k = 0; k < combiList.get(j).length; k++) {

				if (combiList.get(j)[k]) {
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

		// Sauvegarde de la m�thode a ex�cuter
		snippet = new Snippet(solution.patterns.get(id), data, solution.positions.get(id)*2, selectedReg, selectedLoadMask, solution.computedOffsets.get(id), selectedCombi);

		// Sauvegarde les valeurs charg�es en cache
		pos = solution.positions.get(id)*2;
		for (int j = 0; j < combiList.get(selectedCombi).length; j++) {

			if (combiList.get(selectedCombi)[j] &&
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

		boolean flush = false;
		// R�initialisation des registres �cras�s par le pattern
		// N�cessaire si le dernier pattern a b�n�fici� du cache mais �crase les registres
		if (solution.patterns.get(id).getResetRegisters().size() > selectedCombi) {
			for (int j = 0; j < solution.patterns.get(id).getResetRegisters().get(selectedCombi).length; j++) {
				if (solution.patterns.get(id).getResetRegisters().get(selectedCombi)[j]) {
					regSet[j] = false;
					if (regBBSet[j] || ((j == Register.A || j == Register.B) && regBBSet[Register.D] == true ) || (j == Register.D && (regBBSet[Register.A] == true || regBBSet[Register.B] == true))) {
						flush = true;
					}
				}
			}
		}		

		for (int i = 0; i < selectedReg.size(); i++) {
			if (regBBSet[selectedReg.get(i)] || ((selectedReg.get(i) == Register.A || selectedReg.get(i) == Register.B) && regBBSet[Register.D] == true ) || (selectedReg.get(i) == Register.D && (regBBSet[Register.A] == true || regBBSet[Register.B] == true))) {
				flush = true;
			}
		}

		if (flush) {
			// flush du pr�c�dent pattern et purge des registres
			for (int i = regBBSet.length-1; i >= 0; i--) {
				if (regBBSet[i]) {
					lastSnippet.addRegisterPSH(i);

					// Pour chaque registre sauvegard� dans les donn�es du fond
					// On enregistre l'id du registre et l'offset associ�
					// dans le cas d'un stack blast, on enregistre un index null
					regE.add(i);
					offsetE.add(offsetBBSet[i]);
				}
				regBBSet[i] = false;
				offsetBBSet[i] = null;
			}
			regBBIdx = -1;
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
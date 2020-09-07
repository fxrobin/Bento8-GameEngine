package fr.bento8.to8.compiledSprite;

import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import fr.bento8.to8.InstructionSet.Register;

public class RegisterOptim{
	// 
	// <Decrire fonctionnement actuel>
	//
	// TODO :
	// Construit le code à partir des patterns et des noeuds trouvés
	// Cherche toutes les combinaisons pour chaque noeud:
	// - Ordre de patterns mobiles
	// - Différents registres
	// L'objectif est de limiter les rechargements de registres avec les données de l'image source

	//	- Parcourir la solution dans l'ordre et compter le nombre de cycles, sauvegarder la solution dans computed Pattern
	//
	//	*** Ci dessous : permet de trouver des solutions qui offrent un gain en enchainant les noeuds
	//	- parcourir tous les noeuds
	//	- pour chaque noeud établir les combinaisons possibles :
	//
	//	0. ecrire le LEAS
	//	1. GROUPE 1: parcourir les patterns et prendre les patterns non dissosicables (complets)
	//	   si un des resetRegisters n'est pas null:
	//	      - etablir toutes les combinaisons qui positionnent seulement 1 fois chaque pattern ou resetRegisters n'est pas null en fin de groupe (ex: 3 patterns ou resetRegisters n'est pas null = 3 combinaisons)
	//	   si resetRegisters est null:
	//	      - pour tous ces patterns on a deux solutions possibles : utilisation de A seulement ou utilisation de B seulement
	//	3. GROUPE 2: parcourir les patterns et prendre le pattern principal (complet)
	//	4. GROUPE 3: créer des ensembles avec :
	//	   les patterns dissociables (11, 1111) partie ecriture de sprite, tri et regroupement des patterns identiques (pattern+pixels) (Permet de limiter les combinaisons dans les cas extremes)
	//	   patterns dissociables (11, 1111) partie backup background
	//	   etablir tt combinaisons possibles
	//	5. créer des combinatoire avec GROUPE 1, GROUPE 2 et GROUPE 3 (*6)
	//
	//	Première passe: Calcul de la meilleure combinaison (juste pour le noeud) et sauvegarde de la solution pour le noeud dans la solution globale
	//	Passes suivantes: pour chaque combinaison de noeud, refaire un calcul global du nb de cycles de la solution
	//	- si le nombre de cycles baisse, sauver la solution et le nombre de cycles total et poursuivre l'optim au noeud suivant
	//	- s'arrêter lorsqu'il n'y a plus d'améliorations après un parcours complet de tous les noeuds (afficher le nombre de passes à l'écran)

	private static final Logger logger = LogManager.getLogger("log");

	private Solution solution;
	private byte[] data;

	int i, j, k;
	List<String> asmCode = new ArrayList<String>();
	int lastLeas = Integer.MAX_VALUE;		
	boolean[] regSet = new boolean[] {false, false, false, false, false, false, false};
	byte[][] regVal = new byte[7][4];
	int cost, selectedCombi, minCost;
	List<Integer> selectedReg = new ArrayList<Integer>();
	List<Boolean> selectedloadMask = new ArrayList<Boolean>();
	List<Integer> patternGrp1 = new ArrayList<Integer>();
	List<Integer> patternGrp2 = new ArrayList<Integer>();
	List<Integer> patternGrp3 = new ArrayList<Integer>();

	public RegisterOptim(Solution solution, byte[] data) {
		this.solution = solution;
		this.data = data;
	}

	public void run(boolean isForward) {
		int i, j, c, r, k, totalCombi = 1;
		String line;

		logger.debug("Node;Pattern;Variation;A;B;D;X;Y");

		for (i=0; i<solution.patterns.size(); i++) {
			c = 0;
			for (boolean[] combi : solution.patterns.get(i).getRegisterCombi()) {
				k = solution.positions.get(i)*2;
				line = solution.computedNodes.get(i)+";"+solution.patterns.get(i).getClass().getSimpleName()+";"+c+";";
				c++;
				for (r = 0; r <= 4; r++) {
					if (combi[r]) {
						for (j=0; j<Register.size[r]; j++) {
							line += String.format("%02x%02x", data[k++]&0xff, data[k++]&0xff);
						}
					}
					if (r!=4) {
						line += ";";
					}
				}
				logger.debug(line);
			}
			totalCombi = totalCombi * (c+1);
		}
		logger.debug("Total Combi:"+totalCombi);
	}

	public void build() {
		int currentNode = 0;

		logger.debug("Code ASM:");
		try {
			// Parcours de tous les patterns
			i = 0;
			while (i < solution.patterns.size()) {
				patternGrp1.clear();
				patternGrp2.clear();
				patternGrp3.clear();

				currentNode = solution.computedNodes.get(i);
				while (i < solution.patterns.size() && currentNode == solution.computedNodes.get(i)) {

					// Ecriture du LEAS				
					if (currentNode != lastLeas // le noeud courant est différent de celui du dernier LEAS
							&& solution.computedLeas.containsKey(solution.computedNodes.get(i)) // Le noeud courant est un noeud de LEAS
							&& solution.computedLeas.get(solution.computedNodes.get(i)) != 0) { // Ignore les LEAS avec offset de 0
						asmCode.add("\tLEAS "+solution.computedLeas.get(solution.computedNodes.get(i))+",S");
						lastLeas = solution.computedNodes.get(i);
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

				//				logger.debug("patternGrp1: "+patternGrp1);
				//				logger.debug("patternGrp2: "+patternGrp2);
				//				logger.debug("patternGrp3: "+patternGrp3);

				if (i < solution.patterns.size()) {
					// Parcours des patterns dans l'ordre des groupes 1, 2 puis 3
					for (int id : patternGrp1) {
						processPatternBackgroundBackup(id);
						processPatternDraw(id);
						asmCode.add("");
					}

					for (int id : patternGrp2) {
						processPatternBackgroundBackup(id);
						processPatternDraw(id);
						asmCode.add("");
					}

					for (int id : patternGrp3) {
						processPatternBackgroundBackup(id);
						asmCode.add("");
					}

					for (int id : patternGrp3) {
						processPatternDraw(id);
						asmCode.add("");
					}
				}
			}

			for (String line : asmCode) logger.debug(line);

		} catch (Exception e) {
			logger.fatal("", e);
		}
	}

	public void processPatternBackgroundBackup(int id) throws Exception {

		selectRegisterBackgroundBackup(id);
		asmCode.add("* n:"+id + " Sauvegarde Fond");
		asmCode.addAll(solution.patterns.get(id).getBackgroundBackupCode(selectedReg, solution.computedOffsets.get(id)));

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
	}

	public void processPatternDraw(int id) throws Exception {
		selectRegisterDraw(id);
		asmCode.add("* n:" + id + " x: " + ((solution.positions.get(id) - ((int) Math.floor(solution.positions.get(id)/40)*40))*2+1) + " y: " + ((int) Math.floor(solution.positions.get(id)/40)+1) + " Ecriture sprite");
		asmCode.addAll(solution.patterns.get(id).getDrawCode(data, solution.positions.get(id)*2, selectedReg, selectedloadMask, solution.computedOffsets.get(id)));

		// Réinitialisation des registres pour certain patterns
		if (solution.patterns.get(id).getResetRegisters() != null) {
			for (j = 0; j < solution.patterns.get(id).getResetRegisters().length; j++) {
				if (solution.patterns.get(id).getResetRegisters()[j]) {
					regSet[j] = false;
				}
			}
		}
	}

	public void selectRegisterBackgroundBackup(int id) {

		// DEBUG : registres
		String regDisp = "Registres: ";
		for (j = 0; j < regSet.length; j++) {
			if (regSet[j]) {
				regDisp += " " + Register.name[j] + ":" + String.format("%01x%01x", regVal[j][0]&0xff, regVal[j][1]&0xff);
				if (Register.size[j] == 2) {
					regDisp += String.format("%01x%01x", regVal[j][2]&0xff, regVal[j][3]&0xff);
				}
			} else {
				regDisp += " " + Register.name[j] + ":-";
			}
		}
		asmCode.add(regDisp);

		// Recherche pour chaque combinaison de registres d'un pattern,
		// celle qui a le cout le moins élevé en fonction des registres déjà chargés

		selectedCombi = -1;
		minCost = Integer.MAX_VALUE;

		for (j = 0; j < solution.patterns.get(id).getRegisterCombi().size(); j++) {
			cost = 0;
			for (k = 0; k < solution.patterns.get(id).getRegisterCombi().get(j).length; k++) {
				if (solution.patterns.get(id).getRegisterCombi().get(j)[k]) {
					if (k == Register.Y) { // TODO rendre paramétrable
						cost += 1;
					}
					if (!regSet[k]) { // TODO ajout condition il faudrait vérifier que la valeur en cache sur D ou X est utile pour justifier Y
						cost -= 1;
					}
				}
			}
			//			logger.debug("cout:"+cost);
			if (cost < minCost
					&& !(solution.patterns.get(id).getNbBytes() == 2	// dans le cas de l'effacement on élimine les solutions A, B pour privilégier D
							&& solution.patterns.get(id).getRegisterCombi().get(j)[0] == true
							&& solution.patterns.get(id).getRegisterCombi().get(j)[1] == true)) {
				selectedCombi = j;
				minCost = cost;
			}
		}

		if (selectedCombi == -1) {
			logger.fatal("Aucune combinaison de registres pour le pattern en position: "+solution.positions.get(id));
		}

		// Pour la combinaison choisie, création de la liste des registres et du masque de chargement des registres
		selectedReg.clear();
		selectedloadMask.clear();
		for (j = 0; j < solution.patterns.get(id).getRegisterCombi().get(selectedCombi).length; j++) {
			if (solution.patterns.get(id).getRegisterCombi().get(selectedCombi)[j]) {
				selectedReg.add(j);
			}
		}
	}

	public void selectRegisterDraw(int id) {

		// DEBUG : registres
		String regDisp = "Registres: ";
		for (j = 0; j < regSet.length; j++) {
			if (regSet[j]) {
				regDisp += " " + Register.name[j] + ":" + String.format("%01x%01x", regVal[j][0]&0xff, regVal[j][1]&0xff);
				if (Register.size[j] == 2) {
					regDisp += String.format("%01x%01x", regVal[j][2]&0xff, regVal[j][3]&0xff);
				}
			} else {
				regDisp += " " + Register.name[j] + ":-";
			}
		}
		asmCode.add(regDisp);

		// Recherche pour chaque combinaison de registres d'un pattern,
		// celle qui a le cout le moins élevé en fonction des registres déjà chargés

		selectedCombi = -1;
		minCost = Integer.MAX_VALUE;

		for (j = 0; j < solution.patterns.get(id).getRegisterCombi().size(); j++) {
			cost = 0;
			for (k = 0; k < solution.patterns.get(id).getRegisterCombi().get(j).length; k++) {
				// TODO ATTENTION VERIFIER le CAS de plusieurs REGISTRES, peut être faire avancer le curseur des datas !!!!!
				// ******************************
				if (solution.patterns.get(id).getRegisterCombi().get(j)[k]
						&& !(regSet[k] && regVal[k][0] == data[solution.positions.get(id)*2] && regVal[k][1] == data[(solution.positions.get(id)*2)+1]
								&& (Register.size[k] == 1 || (Register.size[k] == 2 && regVal[k][2] == data[(solution.positions.get(id)*2)+2] && regVal[k][3] == data[(solution.positions.get(id)*2)+3])))) {
					cost += solution.patterns.get(id).getCostRegDraw(k);
				}
			}
			asmCode.add("combi: "+j+" cout:"+cost);
			if (cost < minCost) {
				selectedCombi = j;
				minCost = cost;
			}
		}

		if (selectedCombi == -1) {
			logger.fatal("Aucune combinaison de registres pour le pattern en position: "+solution.positions.get(id));
		}
		
		asmCode.add("choix combi: "+selectedCombi);

		// Pour la combinaison choisie, création de la liste des registres et du masque de chargement des registres
		selectedReg.clear();
		selectedloadMask.clear();
		for (j = 0; j < solution.patterns.get(id).getRegisterCombi().get(selectedCombi).length; j++) {
			if (solution.patterns.get(id).getRegisterCombi().get(selectedCombi)[j]) {
				selectedReg.add(j);
				// TODO ATTENTION VERIFIER le CAS de plusieurs REGISTRES, peut être faire avancer le curseur des datas !!!!!
				// ******************************
				if (regSet[j] && regVal[j][0] == data[solution.positions.get(id)*2] && regVal[j][1] == data[(solution.positions.get(id)*2)+1] && (Register.size[j] == 1 || (Register.size[j] == 2 && regVal[j][2] == data[(solution.positions.get(id)*2)+2] && regVal[j][3] == data[(solution.positions.get(id)*2)+3]))) {
					selectedloadMask.add(false);
				} else {
					selectedloadMask.add(true);
				}
			} else {
				selectedloadMask.add(false);
			}
		}

		// DEBUG : combinaison
		//		logger.debug("Combinaison: " + selectedCombi);
		//		logger.debug("selectedReg: " + selectedReg);
		//		logger.debug("selectedloadMask: " + selectedloadMask);

		// Sauvegarde les valeurs en cache
		int pos = solution.positions.get(id)*2;
		for (j = 0; j < solution.patterns.get(id).getRegisterCombi().get(selectedCombi).length; j++) {
			if (solution.patterns.get(id).getRegisterCombi().get(selectedCombi)[j]) {
				regSet[j] = true;
				regVal[j][0] = data[pos++];
				regVal[j][1] = data[pos++];
				if (Register.size[j] == 2) {
					regVal[j][2] = data[pos++];
					regVal[j][3] = data[pos++];
				}

				// Cas particulier de A, on valorise D
				if (j == Register.A) {
					if (regSet[Register.B] == true) {
						regSet[Register.D] = true;
					}
					regVal[Register.D][0] = regVal[j][0];
					regVal[Register.D][1] = regVal[j][1];
				}

				// Cas particulier de B, on valorise D
				if (j == Register.B) {
					if (regSet[Register.A] == true) {
						regSet[Register.D] = true;
					}
					regVal[Register.D][2] = regVal[j][0];
					regVal[Register.D][3] = regVal[j][1];
				}

				// Cas particulier de D, on valorise A et B
				if (j == Register.D) {
					regSet[Register.A] = true;
					regVal[Register.A][0] = regVal[j][0];
					regVal[Register.A][1] = regVal[j][1];

					regSet[Register.B] = true;
					regVal[Register.B][0] = regVal[j][2];
					regVal[Register.B][1] = regVal[j][3];
				}
			}
		}
	}
}
package fr.bento8.to8.compiledSprite;

import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import fr.bento8.to8.InstructionSet.Register;
import fr.bento8.to8.compiledSprite.patterns.Pattern;

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
	int sizeSaveS;
	
	int i, j, k;
	List<String> asmCode = new ArrayList<String>(); // Contient le code de sauvegarde du fond et du dessin de sprite
	List<String> asmECode = new ArrayList<String>(); // Contient le code d'effacement du sprite (restauration du fond)
	
	private int asmCodeCycles;
	private int asmCodeSize;
	private int asmECodeCycles;
	private int asmECodeSize;
	
	int lastLeas;		
	boolean[] regSet;
	byte[][] regVal;
	List<Integer> patternGrp1 = new ArrayList<Integer>();
	List<Integer> patternGrp2 = new ArrayList<Integer>();
	List<Integer> patternGrp3 = new ArrayList<Integer>();

	public RegisterOptim(Solution solution, byte[] data) {
		this.solution = solution;
		this.data = data;
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
		
		lastLeas = Integer.MAX_VALUE;	
		int currentNode = 0;
		boolean leasAtThisNode, saveS; // Lors du rétablissement du fond, demande le chargement de S depuis la zone DATA
		int nbPatternsInThisNode;
		sizeSaveS = 0;

		logger.debug("Code ASM:");
		try {
			// Parcours de tous les patterns
			i = 0;
			while (i < solution.patterns.size()) {
				patternGrp1.clear();
				patternGrp2.clear();
				patternGrp3.clear();
				
				saveS = false;
				leasAtThisNode = false;
				nbPatternsInThisNode = 0;

				currentNode = solution.computedNodes.get(i);
				while (i < solution.patterns.size() && currentNode == solution.computedNodes.get(i)) {

					// Ecriture du LEAS				
					if (currentNode != lastLeas // le noeud courant est différent de celui du dernier LEAS
							&& solution.computedLeas.containsKey(solution.computedNodes.get(i)) // Le noeud courant est un noeud de LEAS
							&& solution.computedLeas.get(solution.computedNodes.get(i)) != 0) { // Ignore les LEAS avec offset de 0
						asmCode.add("\tLEAS "+solution.computedLeas.get(solution.computedNodes.get(i))+",S");
						asmCodeCycles += Register.costIndexedLEA + Register.getIndexedOffsetCost(solution.computedLeas.get(solution.computedNodes.get(i)));
						asmCodeSize += Register.sizeIndexedLEA + Register.getIndexedOffsetSize(solution.computedLeas.get(solution.computedNodes.get(i)));
						lastLeas = solution.computedNodes.get(i);
						leasAtThisNode = true; // On enregistre le fait qu'un LEAS a été produit pour ce noeud
					}

					// Constitution des groupes
					if (!solution.patterns.get(i).isBackgroundBackupAndDrawDissociable() && solution.patterns.get(i).useIndexedAddressing()) {
						patternGrp1.add(i);
					} else if (!solution.patterns.get(i).useIndexedAddressing()) {
						patternGrp2.add(i);
					} else {
						patternGrp3.add(i);
					}
					nbPatternsInThisNode++;

					i++;
				}

//				logger.debug("patternGrp1: "+patternGrp1);
//				logger.debug("patternGrp2: "+patternGrp2);
//				logger.debug("patternGrp3: "+patternGrp3);

				// Parcours des patterns dans l'ordre des groupes 1, 2 puis 3
				int iPattern = 0;
				for (int id : patternGrp1) {
					if ((currentNode == 0 && iPattern == nbPatternsInThisNode-1) || (currentNode != 0 && iPattern == nbPatternsInThisNode-1 && leasAtThisNode)) {
						saveS = true;
						sizeSaveS += 2; // Agrandissement de la zone data pour sauvegarde du S
					}
					processPatternBackgroundBackup(id, saveS);
					processPatternDraw(id);
					asmCode.add("");
					saveS = false;
					iPattern++;
				}

				for (int id : patternGrp3) {
					if ((currentNode == 0 && iPattern == nbPatternsInThisNode-1) || (currentNode != 0 && iPattern == nbPatternsInThisNode-1 && leasAtThisNode)) {
						saveS = true;
						sizeSaveS += 2; // Agrandissement de la zone data pour sauvegarde du S
					}
					processPatternBackgroundBackup(id, saveS);
					asmCode.add("");
					saveS = false;
					iPattern++;
				}

				for (int id : patternGrp3) {
					processPatternDraw(id);
					asmCode.add("");
				}
				
				// Pour pouvoir positionner le Groupe 2 ailleurs qu'en fin de Noeud, il faut modifier
				// la gestion des offsets. A la lecture des données d'effacement sur un groupe 2
				// Un push est fait sur S ce qui décale la position de S et les offset ne sont plus bons
				// 
				for (int id : patternGrp2) {
					if ((currentNode == 0 && iPattern == nbPatternsInThisNode-1) || (currentNode != 0 && iPattern == nbPatternsInThisNode-1 && leasAtThisNode)) {
						saveS = true;
						sizeSaveS += 2; // Agrandissement de la zone data pour sauvegarde du S
					}
					processPatternBackgroundBackup(id, saveS);
					processPatternDraw(id);
					asmCode.add("");
					saveS = false;
					iPattern++;
				}
			}

			for (String line : asmCode) logger.debug(line);

		} catch (Exception e) {
			logger.fatal("", e);
		}
	}

	public void processPatternBackgroundBackup(int id, boolean saveS) throws Exception {

		// Recherche pour chaque combinaison de registres d'un pattern,
		// celle qui a le cout le moins élevé en fonction des registres déjà chargés

		//asmCode.add(getRegState(regSet, regVal));

		int cycles, selectedCombi, minCycles;
		List<Integer> currentReg = new ArrayList<Integer>();
		List<Integer> selectedReg = new ArrayList<Integer>();

		selectedCombi = -1;
		minCycles = Integer.MAX_VALUE;

		// Parcours des combinaisons possibles de registres pour le pattern
		for (j = 0; j < solution.patterns.get(id).getRegisterCombi().size(); j++) {
			cycles = 0;
			currentReg.clear();

			// Parcours des registres de la combinaison
			for (k = 0; k < solution.patterns.get(id).getRegisterCombi().get(j).length; k++) {

				if (solution.patterns.get(id).getRegisterCombi().get(j)[k]) {
					// Le registre est utilisé dans la combinaison
					currentReg.add(k);
				}
			}

			// Calcul du nombre de cycles de la solution courante
			cycles = solution.patterns.get(id).getBackgroundBackupCodeCycles(currentReg, solution.computedOffsets.get(id), true);
			//asmCode.add("combi: "+j+" cycles:"+cycles);

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

		//asmCode.add("choix combi: "+selectedCombi);	
		//asmCode.add("* n:"+id + " Sauvegarde Fond");
		asmCode.addAll(solution.patterns.get(id).getBackgroundBackupCode(selectedReg, solution.computedOffsets.get(id), saveS));
		asmCodeCycles += solution.patterns.get(id).getBackgroundBackupCodeCycles(selectedReg, solution.computedOffsets.get(id), saveS);
		asmCodeSize += solution.patterns.get(id).getBackgroundBackupCodeSize(selectedReg, solution.computedOffsets.get(id));
		
		asmECode.addAll(0, solution.patterns.get(id).getEraseCode(saveS, solution.computedOffsets.get(id)));
		asmECodeCycles += solution.patterns.get(id).getEraseCodeCycles(saveS, solution.computedOffsets.get(id));
		asmECodeSize += solution.patterns.get(id).getEraseCodeSize(saveS, solution.computedOffsets.get(id));

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

		// Recherche pour chaque combinaison de registres d'un pattern,
		// celle qui a le cout le moins élevé en fonction des registres déjà chargés

		//asmCode.add(getRegState(regSet, regVal));

		int cycles, selectedCombi, minCycles, pos;
		byte b1, b2, b3 = 0x00, b4 = 0x00;
		List<Integer> currentReg = new ArrayList<Integer>();
		List<Boolean> currentLoadMask = new ArrayList<Boolean>();
		List<Integer> selectedReg = new ArrayList<Integer>();
		List<Boolean> selectedLoadMask = new ArrayList<Boolean>();

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
			//asmCode.add("combi: "+j+" cycles:"+cycles);

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

		//asmCode.add("choix combi: "+selectedCombi);	
		//asmCode.add("* n:" + id + " x: " + ((solution.positions.get(id) - ((int) Math.floor(solution.positions.get(id)/40)*40))*2+1) + " y: " + ((int) Math.floor(solution.positions.get(id)/40)+1) + " Ecriture sprite");
		asmCode.addAll(solution.patterns.get(id).getDrawCode(data, solution.positions.get(id)*2, selectedReg, selectedLoadMask, solution.computedOffsets.get(id)));
		asmCodeCycles += solution.patterns.get(id).getDrawCodeCycles(selectedReg, selectedLoadMask, solution.computedOffsets.get(id));
		asmCodeSize += solution.patterns.get(id).getDrawCodeSize(selectedReg, selectedLoadMask, solution.computedOffsets.get(id));
		
		// Sauvegarde les valeurs chargées en cache
		pos = solution.positions.get(id)*2;
		for (j = 0; j < solution.patterns.get(id).getRegisterCombi().get(selectedCombi).length; j++) {

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
			for (j = 0; j < solution.patterns.get(id).getResetRegisters().get(selectedCombi).length; j++) {
				if (solution.patterns.get(id).getResetRegisters().get(selectedCombi)[j]) {
					regSet[j] = false;
				}
			}
		}		
	}

	public String getRegState(boolean[] regSet, byte[][] regVal) {
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
		return regDisp;
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
		logger.debug("Taille de la zone data pour les pixels: "+size);
		
		size += sizeSaveS;
		logger.debug("Taille de la zone data pour les positions: "+sizeSaveS);
		logger.debug("Taille de la zone data: "+size);
		
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
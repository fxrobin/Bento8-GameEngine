package fr.bento8.to8.compiledSprite;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.InstructionSet.Register;

public class RegisterOptim{
	// Construit le code � partir des patterns et des noeuds trouv�s
	// Cherche toutes les combinaisons pour chaque noeud:
	// - Ordre de patterns mobiles
	// - Diff�rents registres
	// L'objectif est de limiter les rechargements de registres avec les donn�es de l'image source

	//	- Parcourir la solution dans l'ordre et compter le nombre de cycles, sauvegarder la solution dans computed Pattern
	//
	//	*** Ci dessous : permet de trouver des solutions qui offrent un gain en enchainant les noeuds
	//	- parcourir tous les noeuds
	//	- pour chaque noeud �tablir les combinaisons possibles :
	//
	//	0. ecrire le LEAS
	//	1. GROUPE 1: parcourir les patterns et prendre les patterns non dissosicables (complets)
	//	   si un des resetRegisters n'est pas null:
	//	      - etablir toutes les combinaisons qui positionnent seulement 1 fois chaque pattern ou resetRegisters n'est pas null en fin de groupe (ex: 3 patterns ou resetRegisters n'est pas null = 3 combinaisons)
	//	   si resetRegisters est null:
	//	      - pour tous ces patterns on a deux solutions possibles : utilisation de A seulement ou utilisation de B seulement
	//	3. GROUPE 2: parcourir les patterns et prendre le pattern principal (complet)
	//	4. GROUPE 3: cr�er des ensembles avec :
	//	   les patterns dissociables (11, 1111) partie ecriture de sprite, tri et regroupement des patterns identiques (pattern+pixels) (Permet de limiter les combinaisons dans les cas extremes)
	//	   patterns dissociables (11, 1111) partie backup background
	//	   etablir tt combinaisons possibles
	//	5. cr�er des combinatoire avec GROUPE 1, GROUPE 2 et GROUPE 3 (*6)
	//
	//	Premi�re passe: Calcul de la meilleure combinaison (juste pour le noeud) et sauvegarde de la solution pour le noeud dans la solution globale
	//	Passes suivantes: pour chaque combinaison de noeud, refaire un calcul global du nb de cycles de la solution
	//	- si le nombre de cycles baisse, sauver la solution et le nombre de cycles total et poursuivre l'optim au noeud suivant
	//	- s'arr�ter lorsqu'il n'y a plus d'am�liorations apr�s un parcours complet de tous les noeuds (afficher le nombre de passes � l'�cran)

	private Solution solution;
	private byte[] data;

	public RegisterOptim(Solution solution, byte[] data) {
		this.solution = solution;
		this.data = data;
	}

	public void run(boolean isForward) {
		int i, j, c, r, k, totalCombi = 1;
		System.out.println("Node;Pattern;Variation;A;B;D;X;Y");
		for (i=0; i<solution.patterns.size(); i++) {
			c = 0;
			for (boolean[] combi : solution.patterns.get(i).getRegisterCombi()) {
				k = solution.positions.get(i)*2;
				System.out.print(solution.computedNodes.get(i)+";"+solution.patterns.get(i).getClass().getSimpleName()+";"+c+";");
				c++;
				for (r = 0; r <= 4; r++) {
					if (combi[r]) {
						for (j=0; j<Register.size[r]; j++) {
							System.out.print(String.format("%02x%02x", data[k++]&0xff, data[k++]&0xff));
						}
					}
					if (r!=4) {
						System.out.print(";");
					}
				}
				System.out.println("");
			}
			totalCombi = totalCombi * (c+1);
		}
		System.out.println("Total Combi:"+totalCombi);
	}

	public void build() {
		int i, lastLeas = Integer.MAX_VALUE;
		List<String> asmCode = new ArrayList<String>();
		try {
			for (i = 0; i < solution.patterns.size(); i++) {
				if (lastLeas != solution.computedNodes.get(i) && solution.computedLeas.containsKey(solution.computedNodes.get(i)) && solution.computedLeas.get(solution.computedNodes.get(i)) != 0) {
					asmCode.add("\tLEAS "+solution.computedLeas.get(solution.computedNodes.get(i))+",S");
					lastLeas = solution.computedNodes.get(i);
				}
				asmCode.addAll(solution.patterns.get(i).getBackgroundBackupCode(getRegisterIndexes(solution.patterns.get(i).getRegisterCombi().get(0)), solution.computedOffsets.get(i)));
				asmCode.addAll(solution.patterns.get(i).getDrawCode(data, solution.positions.get(i)*2, getRegisterIndexes(solution.patterns.get(i).getRegisterCombi().get(0)), getLoadMask(solution.patterns.get(i).getRegisterCombi().get(0)), solution.computedOffsets.get(i)));
				asmCode.add("");
			}

			for (String line : asmCode) System.out.println(line);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public List<Integer> getRegisterIndexes(boolean[] combi) {
		List<Integer> registers = new ArrayList<Integer>();

		for (int i = 0; i < combi.length; i++) {
			if (combi[i]) {
				registers.add(i);
			}
		}
		return registers;
	}
	
	public List<Boolean> getLoadMask(boolean[] combi) {
		List<Boolean> loadMask = new ArrayList<Boolean>();

		for (int i = 0; i < combi.length; i++) {
			if (combi[i]) {
				loadMask.add(true);
			}
		}
		return loadMask;
	}
}
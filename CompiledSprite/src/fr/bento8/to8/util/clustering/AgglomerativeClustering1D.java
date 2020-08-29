package fr.bento8.to8.util.clustering;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import fr.bento8.to8.compiledSprite.patterns.Snippet;
import fr.bento8.to8.compiledSprite.patterns.Solution;

public class AgglomerativeClustering1D{
	public Solution solution;
	private List<Integer> AssignedPatterns;

	public AgglomerativeClustering1D(Solution solution) {
		this.solution = solution;
		AssignedPatterns = new ArrayList<Integer>();
	}

	public void cluster(boolean isForward) {
		if (initAssignmentStep()) {
			clusterPatternsToExistingNodes(isForward);
			createNewNodesAndClusterRemainingPatterns();
		}
	}

	private boolean initAssignmentStep() {
		boolean result = false;

		// S'il n'y a pas de pattern utilisant l'adressage indexé, on n'utilise pas le clustering
		// Initialisation à -1 des patterns utilisant l'adressage indexé
		// Initialisation avec la valeur d'offset pour les autres patterns

		for (int i=0; i<solution.patterns.size(); i++) {
			solution.computedNodes.add(solution.offsets.get(i));
			if (solution.patterns.get(i).useIndexedAddressing()) {
				AssignedPatterns.add(-1);
				result=true;
			} else {
				AssignedPatterns.add(solution.offsets.get(i));
			}
		}

		return result;
	}

	private void clusterPatternsToExistingNodes(boolean isForward) {	   
		int distance;

		// Traite les noeuds fixes imposés par les patterns n'utilisant pas l'indexation
		// Cherche pour chacun tous les pattern indexés pouvant s'y rattacher (-128 +127)
		for (int i = 1; i < solution.computedNodes.size(); i++) {
			if (!solution.patterns.get(i).useIndexedAddressing()) {
				solution.computedLeas.put(i, solution.offsets.get(i));
				for (int j = 0; j < solution.computedNodes.size(); j++) {
					if (solution.patterns.get(j).useIndexedAddressing() && AssignedPatterns.get(j) == -1) {
						if (isForward) {
							distance = solution.computedNodes.get(j) - solution.computedNodes.get(i);
						} else {
							distance = solution.computedNodes.get(i) - solution.computedNodes.get(j);
						}
						if ( -128 <= distance && distance <= 127) {
							AssignedPatterns.set(j, i);
							solution.computedNodes.set(j, i);
						}
					}
				}
			}
		}
		displayDebug();
	}

	private void createNewNodesAndClusterRemainingPatterns() {	 
		
		List<Integer> minMaxI = new ArrayList<Integer>();
		int i = 0, j;
		
		//  Selecion des patterns à regrouper en noeuds
		while (i < solution.computedNodes.size()) {
			while (i < solution.computedNodes.size() && AssignedPatterns.get(i) != -1) {
				i++;
			}
			minMaxI.add(i);

			while (i < solution.computedNodes.size() && AssignedPatterns.get(i) == -1) {
				i++;
			}
			minMaxI.add(i-1);
		}
		
		// Regroupement
		ListIterator<Integer> it1 = minMaxI.listIterator();
		int start, end, node;

		while (it1.hasNext()) {
			start = it1.next();
			end = it1.next();
			i = start;

			while (i <= end) {
				
				while (i++ < end && Math.abs(solution.offsets.get(start) - solution.offsets.get(i)) < 256) {
				}

				node = ((Math.abs(solution.offsets.get(start) - solution.offsets.get(i-1))+1) / 2) + solution.offsets.get(start);
				solution.computedLeas.put(start, node);
				
				for (j = start; j < i; j++) {
					solution.computedOffsets.set(j, solution.offsets.get(j)-node);
				}
				
				start = i;
			}
		}
		displayDebug();
	}
	
	public void displayDebug() {
		ListIterator<Integer> it1 = solution.offsets.listIterator();
		ListIterator<Integer> it2 = AssignedPatterns.listIterator();
		ListIterator<Integer> it3 = solution.computedNodes.listIterator();
		int i=0;
		for (Snippet snippet : solution.patterns) {
			System.out.println("("+i+":"+it1.next()+":"+it2.next()+":"+it3.next()+":"+snippet.getClass().getSimpleName()+")");
			i++;
		}
		System.out.println("LEAS contains: "+solution.computedLeas);
		System.out.println("");
	}
}
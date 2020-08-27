package fr.bento8.to8.util.clustering;

import java.util.List;

import fr.bento8.to8.compiledSprite.patterns.Snippet;
import fr.bento8.to8.compiledSprite.patterns.Solution;

public class AgglomerativeClustering1D{
   public Solution solution;
   
   public AgglomerativeClustering1D(Solution solution) {
	   this.solution = solution;
   }
   
   public void cluster() {
	   initAssignmentStep();

	   while (deleteOneNode()) { // efface un noeud par regroupement
		   assignmentStep();    // assigne l'element sans noeud au noeud le plus proche
		   updateStep();        // mise à jour des noeuds
	   }
   }

   private void initAssignmentStep() {
	   // On affecte son propre noeud à chaque pattern
	   for (int i=0; i<solution.patterns.size(); i++) {
		   solution.computedNodes.add(i);
	   }
   }
   
   private boolean deleteOneNode() {	   
	   int distance;
	   int indexToDelete = -1;
	   int minDistance = Integer.MAX_VALUE;
	   
	   // recherche des noeuds avec la distance la plus courte
	   for (int i = 1; i < solution.computedNodes.size(); i++) {
		   if (solution.computedNodes.get(i) == i) {
			   for (int j = 1; j < solution.computedNodes.size(); j++) {
				   if (i != j && solution.computedNodes.get(j) == j) {
					   distance = Math.abs(solution.offsets.get(i) - solution.offsets.get(j));
					   if (distance < minDistance) {
						   minDistance = distance;
						   indexToDelete = i;
					   }
				   }
			   }
		   }
	   }
	   
	   // Création d'un noeud central entre les deux noeuds et rattachement des deux paterns à ce noeud central
	   // Tenir compte des noeuds inamovibles (pas de noeud central dans ce cas)
	   
	   if (indexToDelete == -1 || minDistance > ) {
		   return false;
	   }
	   
	   for (i = 0; i < o; i++) {
	   		if (assignment[i] == indexToDelete) {
	   			lonelyAssignment[i] = true;
	   			//System.out.println("lonely:"+i);
	   		}
	   		if (assignment[i] > indexToDelete) {
	   			assignment[i] = assignment[i]-1;
	   		}
	   }

	   double[][] newCentroids = new double[centroids.length-1][centroids[0].length];
	   for (i = 0; i < centroids.length-1; i++) {
		   if (i < indexToDelete) {
			   for (j = 0; j < centroids[i].length; j++) {
				   newCentroids[i][j] = centroids[i][j];
			   }
		   } else {
			   for (j = 0; j < centroids[i+1].length; j++) {
				   newCentroids[i][j] = centroids[i+1][j];
			   }
		   }
	   }
	   centroids = newCentroids;
   }
   
   /** 
    * Assigns lonely data point the nearest centroid.
    */
   private void assignmentStep() {
	  //System.out.println("assignmentStep");
	   //assignment = new int[o];

	   double tempDist;
	   double minValue;
	   int minLocation;

	   for (int i = 0; i < o; i++) {
		   if (lonelyAssignment[i]) { 
			   minLocation = 0;
			   minValue = Double.POSITIVE_INFINITY;
			   for (int j = 0; j < centroids.length; j++) {
				   tempDist = distance(weightedPoints[i], centroids[j]);
				   if (tempDist < minValue) {
					   minValue = tempDist;
					   minLocation = j;
				   }
			   }
			   //System.out.println("Assign i:"+i+" found:"+minLocation+" value:"+minValue);
			   assignment[i] = minLocation;
		   }

	   }
   }

   /** 
    * Updates the centroids
    */
   private void updateStep() {
	  //System.out.println("updateStep");
	   
	   for (int i = 0; i < centroids.length; i++)
		   for (int j = 0; j < n+1; j++)
			   centroids[i][j] = 0;

	   double[] clustSize = new double[centroids.length];
	   // sum points assigned to each cluster + sum of weight
	   for (int i = 0; i < o; i++) {
		   clustSize[assignment[i]] += weightedPoints[i][3]*globalDistinctPixels;
		   centroids[assignment[i]][3] += weightedPoints[i][3];
		   for (int j = 0; j < n; j++) {
			   centroids[assignment[i]][j] += weightedPoints[i][j]*(weightedPoints[i][3]*globalDistinctPixels);
		   }
	   }

	   // divide to get averages -> centroids
	   for (int i = 0; i < centroids.length; i++) {
		   for (int j = 0; j < n; j++)
			   centroids[i][j] /= clustSize[i];
	   		if (centroids[assignment[i]][0] == weightedPoints[i][0] && centroids[assignment[i]][1] == weightedPoints[i][1] && centroids[assignment[i]][2] == weightedPoints[i][2]) {
	   			lonelyAssignment[i] = false;
	   		} else {
	   			lonelyAssignment[i] = true;
	   		}
	   }
	   
   }
}
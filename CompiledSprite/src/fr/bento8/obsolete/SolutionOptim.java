package fr.bento8.obsolete;

public class SolutionOptim{

//	public void Optimize(List<Integer> patterns) throws Exception {
//		// Methode obsolete, permet de regrouper ou d'isoler des patterns en fonction des valeurs de pixel
//
//		if (patterns.size() > 1) {
//
//			// Diminution du nombre de combinaisons à tester :
//			// - en regroupant le valeurs égales pour un pattern
//			// - en isolant de la recherche combinatoire les valeurs uniques, qui ne peuvent donc pas bénéficier d'un cache registre sur le noeud
//			int pos;
//			long value;
//
//			// Contient pour un pattern une liste des toutes les combinaisons de données rangées par registre
//			HashMap<Integer, List<Long>> patternData = new HashMap<Integer, List<Long>>();
//
//			// Séparation en deux groupes
//			List<List<Integer>> patternOptim = new ArrayList<List<Integer>>();
//			List<Long> patternOptimL = new ArrayList<Long>();
//			List<Integer> patternNonOptim = new ArrayList<Integer>();
//
//			for (int id : patterns) {
//
//				// Parcours des combinaisons possibles de registres pour le pattern
//				for (j = 0; j < solution.patterns.get(id).getRegisterCombi().size(); j++) {
//					pos = solution.positions.get(id)*2;
//					value = 0;
//
//					// Parcours des registres de la combinaison
//					for (k = 0; k < solution.patterns.get(id).getRegisterCombi().get(j).length; k++) {
//
//						if (solution.patterns.get(id).getRegisterCombi().get(j)[k]) {
//							// Le registre est utilisé dans la combinaison
//							switch(k) {
//							case Register.A: value += (((0xFL) << 60)   |(data[pos++] & 0xFFL) << 44) | ((data[pos++] & 0xFFL) << 40); break;
//							case Register.B: value += (((0xFL) << 56)   |(data[pos++] & 0xFFL) << 36) | ((data[pos++] & 0xFFL) << 32); break;
//							case Register.D: value += (((0xFFL) << 56) |(data[pos++] & 0xFFL) << 44) | ((data[pos++] & 0xFFL) << 40) | ((data[pos++] & 0xFFL) << 36) | ((data[pos++] & 0xFFL) << 32); break;
//							case Register.X: value += (((0xFL) << 52)   |(data[pos++] & 0xFFL) << 28) | ((data[pos++] & 0xFFL) << 24) | ((data[pos++] & 0xFFL) << 20) | ((data[pos++] & 0xFFL) << 16); break;
//							case Register.Y: value += (((0xFL) << 48)   |(data[pos++] & 0xFFL) << 12) | ((data[pos++] & 0xFFL) << 8)  | ((data[pos++] & 0xFFL) << 4)  | ((data[pos++] & 0xFFL) << 0); break;
//							}
//						}
//					}
//
//					logger.debug("\tPattern: "+id+" Combi: "+j+" Valeur " + String.format("%016x", value));
//
//					// Ajout de la combinaison de pixels pour le pattern
//					List<Long> l = new ArrayList<Long>();
//					if (!patternData.containsKey(id)) {
//						l = new ArrayList<Long>();
//						patternData.put(id, l);
//					} else {
//						l = patternData.get(id);
//					}
//					l.add(value);
//				}
//			}
//
//			// Construction des groupes de pattern pour l'optimisation
//			// Chaque groupe est composé de patterns ayant un motif strictement identique
//			// Un groupe qui ne contient qu'un pattern doit avoir un motif commun sur un des 4 registres A, B, X, Y avec un autre groupe
//			boolean match, matchExact;
//			Long matchVal = 0L;
//			List<Integer> p;
//			for (int id : patterns) {
//				match = false;
//				matchExact = false;
//				outerloop:
//					for (long val : patternData.get(id)) {
//						for (int idSub : patterns) {
//							if (id != idSub) {
//								for (long idVal : patternData.get(idSub)) {
//									if (val == idVal) {
//										if (!patternOptimL.contains(val)) {
//											p = new ArrayList<Integer>();
//											p.add(id);
//											patternOptim.add(p);
//											patternOptimL.add(val);
//										} else {
//											patternOptim.get(patternOptimL.indexOf(val)).add(id);
//										}
//										logger.debug("\t\tMatch Exact ("+id+", "+idSub+")");
//										matchExact = true;
//										match = false;
//										break outerloop;
//									} else if (((val & 0xF000000000000000L) >>> 60 == 0xFL   && (idVal & 0xF000000000000000L) >>> 60 == 0xFL   && (val & 0x0000FF0000000000L) >>> 40 == (idVal & 0x0000FF0000000000L) >>> 40) ||
//											((val & 0x0F00000000000000L) >>> 56 == 0xFL   && (idVal & 0x0F00000000000000L) >>> 56 == 0xFL   && (val & 0x000000FF00000000L) >>> 32 == (idVal & 0x000000FF00000000L) >>> 32) ||
//											((val & 0xFF00000000000000L) >>> 56 == 0xFFL  && (idVal & 0xFF00000000000000L) >>> 56 == 0xFFL  && (val & 0x0000FFFF00000000L) >>> 32 == (idVal & 0x0000FFFF00000000L) >>> 32) ||
//											((val & 0x00F0000000000000L) >>> 52 == 0xFL   && (idVal & 0x00F0000000000000L) >>> 52 == 0xFL   && (val & 0x00000000FFFF0000L) >>> 16 == (idVal & 0x00000000FFFF0000L) >>> 16) ||
//											((val & 0x000F000000000000L) >>> 48 == 0xFL   && (idVal & 0x000F000000000000L) >>> 48 == 0xFL   && (val & 0x000000000000FFFFL) >>> 0  == (idVal & 0x000000000000FFFFL) >>> 0)){
//										logger.debug("\t\tMatch ("+id+", "+idSub+"): "+ String.format("%016x", val) + " "+ String.format("%016x", idVal));
//										match = true;
//										matchVal = val;
//									}
//								}
//							}
//						}
//					}
//				if (!matchExact) {
//					if (match) {
//						p = new ArrayList<Integer>();
//						p.add(id);
//						patternOptim.add(p);
//						patternOptimL.add(matchVal);
//					} else {
//						patternNonOptim.add(id);
//					}
//				}
//			}
//
//			logger.debug("\tOptim: "+patternOptim+" NonOptim: "+patternNonOptim);
//
//			if (patternOptim.size() > 1) {
//				if (patternOptim.size() > 9) {
//					//OptimizeRandom(patternOptim);
//				} else {
//					//OptimizeFactorial(patternOptim);
//				}	
//			}
//
//			patterns.clear();
//			patterns.addAll(patternNonOptim);
//
//			for(List<Integer> patternGroup : patternOptim) {
//				patterns.addAll(patternGroup);
//			}
//
//			logger.debug("\tSortie Optim: "+patterns);
//		}
//	}
}
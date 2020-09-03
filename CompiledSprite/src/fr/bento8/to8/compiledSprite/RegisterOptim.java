package fr.bento8.to8.compiledSprite;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import fr.bento8.to8.InstructionSet.Register;
import fr.bento8.to8.compiledSprite.patterns.Pattern;

public class RegisterOptim{
	// Construit le code à partir des patterns et des noeuds trouvés
	// Cherche toutes les combinaisons pour chaque noeud:
	// - Ordre de patterns mobiles
	// - Différents registres
	// L'objectif est de limiter les rechargements de registres avec les données de l'image source

	private Solution solution;
	private byte[] data;

	public RegisterOptim(Solution solution, byte[] data) {
		this.solution = solution;
		this.data = data;
	}

	public void run(boolean isForward) {
		int i, j, c, r, k;
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
		}
	}
}
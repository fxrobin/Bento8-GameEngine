package fr.bento8.to8.compiledSprite;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.compiledSprite.patterns.*;

public class CompiledSpriteModeB16v2 {
	// Convertisseur d'image en "Compiled Sprite"
	// Thomson TO8/TO9+
	// Mode 160x200 en seize couleurs sans contraintes
	private byte[] image;
	private Snippet[] snippets = {new Pattern_111111111111(), new Pattern_1111111111(), new Pattern_11111111(), new Pattern_111111(), new Pattern_1111(), new Pattern_0111(), new Pattern_1011(), new Pattern_1101(), new Pattern_1110(), new Pattern_0101(), new Pattern_1001(), new Pattern_0110(), new Pattern_1010(), new Pattern_11(), new Pattern_01(), new Pattern_10()}; // Trier du plus rapide au plus lent
	private List<Solution> solutions;

	public CompiledSpriteModeB16v2 (byte[] data) {
		image = data;
	}

	public void buildCode () throws Exception {
		this.solutions = buildCodeR(0);
	}

	private List<Solution> buildCodeR(int i) {
		List<Solution> localSolution =  new ArrayList<Solution>();

		while (i < image.length && image[i] == 0x00 && image[i+1] == 0x00) {
			i += 2;
		}

		if (i >= image.length) {
			localSolution.add(new Solution());
			return localSolution;
		}

		for (Snippet snippet : snippets) {
			if (snippet.matches(image, i)) {
				List<Solution> bottomSolution = buildCodeR(i+snippet.getNbPixels());
				if (!bottomSolution.isEmpty()) {
					for (Solution eachSolution : bottomSolution) {
						eachSolution.add(snippet, i);
						localSolution.add(eachSolution);
					}
				}
				// fast method
				return localSolution;
			}
		}
		return localSolution;
	}

	public List<Solution> getSolutions() {
		return solutions;
	}

	public void displaySolutions() {
		System.out.println("Solutions:"+this.solutions.size());
		for (Solution eachSolution : this.solutions) {
			System.out.println(eachSolution.toString());
		}
	}

}

package fr.bento8.to8.compiledSprite;

import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.compiledSprite.patterns.*;

public class CompiledSpriteModeB16v2 {
	// Convertisseur d'image en "Compiled Sprite"
	// Thomson TO8/TO9+
	// Mode 160x200 en seize couleurs sans contraintes
	private byte[] image;
	private Snippet[] snippets = {new Pattern_01(), new Pattern_10(), new Pattern_11(), new Pattern_1111()};
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
				List<Solution> bottomSolution = buildCodeR(i + snippet.getNbPixels());
				if (!bottomSolution.isEmpty()) {
					for (Solution eachSolution : bottomSolution) {
						eachSolution.add(snippet, i);
						localSolution.add(eachSolution);
					}
				}
			}
		}
		return localSolution;
	}

	public List<Solution> getSolutions() {
		return solutions;
	}

	public void displaySolutions() {
		System.out.println("Solutions:");
		for (Solution eachSolution : this.solutions) {
			System.out.println(eachSolution.toString());
		}
	}

}

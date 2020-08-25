package fr.bento8.to8.compiledSprite;

import fr.bento8.to8.compiledSprite.patterns.*;

public class CompiledSpriteModeB16v2 {
	// Convertisseur d'image en "Compiled Sprite"
	// Thomson TO8/TO9+
	// Mode 160x200 en seize couleurs sans contraintes
	private byte[] image;
	private Snippet[] snippets = {new Pattern_01(), new Pattern_10(), new Pattern_11(), new Pattern_1111()};

	public CompiledSpriteModeB16v2 (byte[] data) {
		image = data;
	}

	public void buildCode () throws Exception {
		boolean match;
		int i = 0;
		while (i < image.length) {
			if (image[i] != 0x00 && image[i+1] != 0x00) {
				match = false;
				for (Snippet snippet : snippets) {
					if (snippet.matches(image, i)) {
						System.out.println("i: "+i+" Match pattern: "+snippet.getPattern());
						match = true;
					} else {
						System.out.println("i: "+i+" Not Match pattern: "+snippet.getPattern());
					}
				}
				if (!match) {
					throw new Exception ("Aucune solution trouvée à l'index: "+i);
				}
			}
			i += 2;
		}
	}
}

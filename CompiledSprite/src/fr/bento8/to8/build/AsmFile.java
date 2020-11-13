package fr.bento8.to8.build;

import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class AsmFile
{
	public AsmFile(String fileName, String tag) throws Exception {
		Path path = Paths.get(fileName);
		String content = "* Generated Code\\n(main)" + tag + "\\n";
		Files.write(path, content.getBytes(StandardCharsets.ISO_8859_1));
	}
}
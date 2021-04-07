package fr.bento8.to8.audio;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.build.BuildDisk;
import fr.bento8.to8.build.Game;
import fr.bento8.to8.storage.BinUtil;
import fr.bento8.to8.storage.DataIndex;
import fr.bento8.to8.storage.FdUtil;
import fr.bento8.to8.util.FileUtil;

public class Sound{

	public String name = "";
	public String soundFile;
	public List<SoundBin> sb = new ArrayList<SoundBin>();
	
	public Sound (String name) {
		this.name = name;
	}
	
	public void setAllBinaries(String fileName, boolean inRAM) throws Exception {
		int pageSize = 0x4000 - BinUtil.linearHeaderTrailerSize;
		byte[] buffer = new byte[pageSize];
		byte[] exomizedBin;
		int i = 0, j = 0;
		
		String tmpDestFile = Game.generatedCodeDirName + FileUtil.removeExtension(Paths.get(fileName).getFileName().toString()) + ".tmp";
		String exoDestFile =  Game.generatedCodeDirName + FileUtil.removeExtension(Paths.get(fileName).getFileName().toString()) + ".EXO";
		
		byte[] data = Files.readAllBytes(Paths.get(fileName));
		
		while (j < data.length) {
			for (i = 0; i < pageSize && j < data.length; i++) {
				buffer[i] = data[j++];
			}
			int dataSize = i;
			byte[] writebuffer = new byte[dataSize];
			for (int k = 0; k < dataSize; k++) {
				writebuffer[k] = buffer[k];
			}

			Files.deleteIfExists(Paths.get(tmpDestFile));
			Files.write(Paths.get(tmpDestFile), writebuffer, StandardOpenOption.CREATE);
			BinUtil.RawToLinear(tmpDestFile, 0xA000);
			
			exomizedBin = BuildDisk.exomize(tmpDestFile);
			SoundBin nsb = new SoundBin();
			nsb.dataIndex = new DataIndex();
			nsb.bin = exomizedBin;
			nsb.uncompressedSize = dataSize;
			nsb.inRAM = inRAM;		
			sb.add(nsb);
		}
		
		Files.deleteIfExists(Paths.get(tmpDestFile));		
		Files.deleteIfExists(Paths.get(exoDestFile));
	}	
		
	public void setAllFileIndex(FdUtil fd) {
		for (SoundBin soundBin:sb) {
			soundBin.setFileIndex(fd);
		}
	}
}
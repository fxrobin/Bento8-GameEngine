package fr.bento8.to8.audio;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;

import fr.bento8.to8.build.BuildDisk;
import fr.bento8.to8.disk.BinUtil;
import fr.bento8.to8.disk.DataIndex;
import fr.bento8.to8.disk.FdUtil;

public class Sound{

	public String name = "";
	public String soundFile;
	public List<SoundBin> sb = new ArrayList<SoundBin>();
	
	public Sound (String name) {
		this.name = name;
	}
	
	public void setAllBinaries(String fileName) throws Exception {
		int pageSize = 0x4000 - BinUtil.linearHeaderTrailerSize;
		byte[] buffer = new byte[pageSize];
		byte[] exomizedBin;
		int i = 0, j = 0;

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

			Files.deleteIfExists(Paths.get(BuildDisk.binTmpFile));
			Files.write(Paths.get(BuildDisk.binTmpFile), writebuffer, StandardOpenOption.CREATE);
			BinUtil.RawToLinear(BuildDisk.binTmpFile, 0xA000);
			
			exomizedBin = BuildDisk.exomize(BuildDisk.binTmpFile);
			SoundBin nsb = new SoundBin();
			nsb.fileIndex = new DataIndex();
			nsb.bin = exomizedBin;
			nsb.uncompressedSize = dataSize;
			sb.add(nsb);
		}
	}	
		
	public void setAllFileIndex(FdUtil fd) {
		for (SoundBin soundBin:sb) {
			soundBin.setFileIndex(fd);
		}
	}
}
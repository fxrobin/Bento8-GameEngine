package fr.bento8.to8.compiledSprite;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.ListIterator;

import fr.bento8.to8.compiledSprite.patterns.Pattern;

public class Solution {
	public List<Pattern> patterns;
	public List<Integer> offsets;
	public List<Integer> computedNodes;
	public List<Pattern> computedPatterns;
	public List<Integer> computedOffsets;
	public HashMap<Integer, Integer> computedLeas;
	private int cycles;
	private int size;

	public Solution() {
		patterns = new ArrayList<Pattern>();
		offsets = new ArrayList<Integer>();
		computedNodes = new ArrayList<Integer>();
		computedPatterns = new ArrayList<Pattern>();
		computedOffsets = new ArrayList<Integer>();
		computedLeas = new HashMap<Integer, Integer>();
		cycles = 0;
		size = 0;
	}

	public void add(Pattern pattern, int i) {
		patterns.add(0, pattern);
		offsets.add(0, i);
		computedOffsets.add(0, 0);
	}

	public void computeStats() {
		cycles = 0;
		size = 0;

		for (Pattern pattern : patterns) {
			this.cycles += pattern.getCycles();
			this.size += pattern.getSize();
		}
	}
	
	public String toString() {
		computeStats();
		
		String display = "[Cycles: "+getCycles()+" Octets: "+getSize()+" ";
		ListIterator<Integer> it = offsets.listIterator();
		for (Pattern snippet : patterns) {
			display = display + "("+it.next()+":"+snippet.getClass().getSimpleName()+")";
		}
		return display;
	}
	
	public int getCycles() {
		return cycles;
	}

	public int getSize() {
		return size;
	}
}
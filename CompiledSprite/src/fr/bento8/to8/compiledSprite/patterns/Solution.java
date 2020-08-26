package fr.bento8.to8.compiledSprite.patterns;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

public class Solution {
	private List<Snippet> patterns;
	private List<Integer> positions;
	private int cycles;
	private int size;
	private boolean valid;
	private int invalidIndex;

	public Solution() {
		patterns = new ArrayList<Snippet>();
		positions = new ArrayList<Integer>();
		cycles = 0;
		size = 0;
		valid = true;
		invalidIndex = -1;
	}

	public void add(Snippet pattern, int i) {
		patterns.add(0, pattern);
		positions.add(0, i);
	}

	public void computeStats() {
		cycles = 0;
		size = 0;

		for (Snippet pattern : patterns) {
			this.cycles += pattern.getCycles();
			this.size += pattern.getSize();
		}
	}
	
	public String toString() {
		computeStats();
		
		String display = "[Cycles: "+getCycles()+" Octets: "+getSize()+" ";
		ListIterator<Integer> it = positions.listIterator();
		for (Snippet snippet : patterns) {
			display = display + "("+it.next()+"){" + snippet.getPattern() + "}";
		}
		return display;
	}
	
	public void setNotValid(int i) {
		valid = false;
		invalidIndex = i;
	}
	
	public boolean isValid() {
		return valid;
	}
	
	public int getCycles() {
		return cycles;
	}

	public int getSize() {
		return size;
	}

	public int getInvalidIndex() {
		return invalidIndex;
	}
}
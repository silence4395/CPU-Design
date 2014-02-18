package bigproject.translate;

import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;

import bigproject.assem.Assem;
import bigproject.main.RegConst;

public class Level {

	public Level parent = null;
	public int depth = 0;
	public static int MaxDepth = 0;
	public int localnum = 0;
	
	public Level() {
		depth = 0;
	}
	
	public Level(Level a) {
		parent = a;
		depth = a.depth + 1;
		if (depth > MaxDepth)
			MaxDepth = depth;
	}
	
	public Temp newLocal() {
		localnum = localnum + 1;
		return new Temp(this, localnum-1);
	}

	public int frameSize() {
		return 4 * (1 /* old $ra */ + RegConst.SavedRegNum + localnum);
	}
	
	private TreeSet<Integer> usedRegisters = new TreeSet<Integer>();
	
	public List<Assem> saveRegs() {
		List<Assem> result = new ArrayList<Assem>();
		for (int i = 0; i < RegConst.SavedRegNum; i++) {
			int r = RegConst.SavedRegBase + i;
			if (usedRegisters.contains(r)) {
				result.add(new Assem(
					"sw $%, %($sp)", RegConst.RegNames[r], 4 * (localnum + i)
				));
			}
		}
		return result;
	}
	
	public List<Assem> loadRegs() {
		List<Assem> result = new ArrayList<Assem>();
		for (int i = 0; i < RegConst.SavedRegNum; i++) {
			int r = RegConst.SavedRegBase + i;
			if (usedRegisters.contains(r)) {
				result.add(new Assem(
					"lw $%, %($sp)", RegConst.RegNames[r], 4 * (localnum + i)
				));
			}
		}
		return result;
	}

	public void useRegister(int a) {
		usedRegisters.add(a);
	}
}

package bigproject.analysis;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import bigproject.interm.Interm;
import bigproject.translate.Temp;

public class Block {

	public List<Interm> interms = new ArrayList<Interm>();
	public List<Block> next = new ArrayList<Block>();
	public List<Block> pre = new ArrayList<Block>();
	
	public Block(Interm a) {
		interms.add(a);
	}
	
	public void addInterm(Interm a) {
		interms.add(a);
	}
	
	public void addNext(Block a) {
		next.add(a);
	}
	
	public void addPre(Block a) {
		pre.add(a);
	}
	
	public Set<Temp> IN = new HashSet<Temp>();
	public Set<Temp> OUT = new HashSet<Temp>();

	public Set<Temp> def() {
		Set<Temp> set = new HashSet<Temp>();
		for (int i = interms.size()-1; i >= 0; i--) {
			set.addAll(interms.get(i).def());
			set.removeAll(interms.get(i).use());
		}
		return set;
	}
	
	public Set<Temp> use() {
		Set<Temp> set = new HashSet<Temp>();
		for (int i = interms.size()-1; i >= 0; i--) {
			set.removeAll(interms.get(i).def());
			set.addAll(interms.get(i).use());
		}
		return set;
	}
}

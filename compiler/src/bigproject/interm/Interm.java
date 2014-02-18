package bigproject.interm;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import bigproject.assem.Assem;
import bigproject.translate.Label;
import bigproject.translate.Temp;

public class Interm {

	public List<Assem> gen() {
		return null;
	}
	
	public void replaceLabel(Label oldl, Label newl) {
		
	}
	
	public Label getLabel() {
		return null;
	}

	public List<Interm> next = new ArrayList<Interm>();
	public boolean leader = false;
	
	public void addNext(Interm a) {
		next.add(a);
	}

	public void setLeader() {
		leader = true;		
	}
	
	public Set<Temp> def() {
		return new HashSet<Temp>();
	}
	
	public Set<Temp> use() {
		return new HashSet<Temp>();
	}
	
	public Set<Temp> IN = new HashSet<Temp>();
	public Set<Temp> OUT = new HashSet<Temp>();

	public void clearAll() {
		leader = false;
		next.clear();
		IN.clear();
		OUT.clear();
	}

	public void replaceUseTemp(Temp oldt, Temp newt) {
	}


}

package bigproject.interm;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import bigproject.assem.Assem;
import bigproject.translate.Label;
import bigproject.translate.Temp;

public class MoveL extends Interm {

	public Temp dest = null;
	public Label source = null;
	
	public MoveL(Temp a, Label b) {
		dest = a;
		source = b;
	}
	
	public String toString() {
		return dest + " = " + source;
	}
	
	@Override
	public List<Assem> gen() {
		List<Assem> result = new ArrayList<Assem>();
		result.add(new Assem("la @, %", dest, source));
		return result;
	}
	
	@Override
	public Set<Temp> def() {
		Set<Temp> set = new HashSet<Temp>();
		set.add(dest);
		return set;
	}

}

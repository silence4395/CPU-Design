package bigproject.interm;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import bigproject.assem.Assem;
import bigproject.translate.Const;
import bigproject.translate.Temp;

public class MoveI extends Interm {

	public Temp dest = null;
	public Const source = null;
	
	public MoveI(Temp a, Const b) {
		dest = a;
		source = b;
	}
	
	public String toString() {
		return dest + " = " + source;
	}
	
	@Override
	public List<Assem> gen() {
		List<Assem> result = new ArrayList<Assem>();
		result.add(new Assem("li @, %", dest, source));
		return result;
	}
	
	@Override
	public Set<Temp> def() {
		Set<Temp> set = new HashSet<Temp>();
		set.add(dest);
		return set;
	}

}

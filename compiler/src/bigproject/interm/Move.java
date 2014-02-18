package bigproject.interm;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import bigproject.assem.Assem;
import bigproject.translate.Temp;

public class Move extends Interm {

	public Temp dest = null;
	public Temp source = null;
	
	public Move(Temp a, Temp b) {
		dest = a;
		source = b;
	}
	
	public String toString() {
		return dest + " = " + source;
	}
	
	@Override
	public List<Assem> gen() {
		List<Assem> result = new ArrayList<Assem>();
		result.add(new Assem("move @, %", dest, source));
		return result;
	}
	
	@Override
	public Set<Temp> def() {
		Set<Temp> set = new HashSet<Temp>();
		set.add(dest);
		return set;
	}

	@Override
	public Set<Temp> use() {
		Set<Temp> set = new HashSet<Temp>();
		set.add(source);
		return set;
	}
	
	@Override
	public void replaceUseTemp(Temp oldt, Temp newt) {
		if (source.equals(oldt))
			source = newt;
	}
	
}

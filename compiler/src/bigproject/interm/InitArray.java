package bigproject.interm;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import bigproject.assem.Assem;
import bigproject.translate.Temp;

public class InitArray extends Interm {
	
	public Temp addr = null;
	public int size;

	public InitArray(Temp a, int b) {
		addr = a;
		size = b;
	}
	
	public String toString() {
		return addr + " = Array size:" + size;
	}

	@Override
	public List<Assem> gen() {
		List<Assem> result = new ArrayList<Assem>();
		result.add(new Assem("move @, $gp", addr));
		result.add(new Assem("addi $gp, $gp, %", size));
		return result;
	}
	
	@Override
	public Set<Temp> def() {
		Set<Temp> set = new HashSet<Temp>();
		set.add(addr);
		return set;
	}


}

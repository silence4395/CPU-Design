package bigproject.interm;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import bigproject.assem.Assem;
import bigproject.translate.Const;
import bigproject.translate.Temp;

public class Load extends Interm {

	public Temp dest = null;
	public Temp memaddr = null;
	public Const shift = null;
	
	public Load(Temp a, Temp b, Const c) {
		dest = a;
		memaddr = b;
		shift = c;
	}
	
	public String toString() {
		return dest + " = " + memaddr + "[" + shift + "]";
	}
	
	@Override
	public List<Assem> gen() {
		List<Assem> result = new ArrayList<Assem>();
		result.add(new Assem("lw @, %(%)", dest, shift.value * 4, memaddr));
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
		set.add(memaddr);
		return set;
	}
	
	@Override
	public void replaceUseTemp(Temp oldt, Temp newt) {
		if (memaddr.equals(oldt))
			memaddr = newt;
	}
}

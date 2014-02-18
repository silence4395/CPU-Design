package bigproject.interm;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import bigproject.assem.Assem;
import bigproject.translate.Addr;
import bigproject.translate.Const;
import bigproject.translate.Level;
import bigproject.translate.Temp;

public class Return extends Interm {

	public Level level;
	public Addr addr;
	
	public Return(Level a) {
		this(a, null);
	}
	
	public Return(Level a, Addr b) {
		level = a;
		addr = b;
	}
	
	public String toString() {
		return "return " + addr;
	}
	
	@Override
	public List<Assem> gen() {
		List<Assem> result = new ArrayList<Assem>();
		if (addr instanceof Const)
			result.add(new Assem("li $v0, %", addr));
		else
			result.add(new Assem("move $v0, %", addr));
		return result;
	}
	
	@Override
	public Set<Temp> use() {
		Set<Temp> set = new HashSet<Temp>();
		if (addr instanceof Temp)
			set.add((Temp) addr);
		return set;
	}
	
	@Override
	public void replaceUseTemp(Temp oldt, Temp newt) {
		if ((addr instanceof Temp) && addr.equals(oldt))
			addr = newt;
	}
}

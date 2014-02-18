package bigproject.interm;

import java.util.List;
import java.util.Set;

import bigproject.assem.Assem;
import bigproject.translate.Label;
import bigproject.translate.Temp;

public class CallFun extends CallProc {

	public Temp dest = null;
	
	public CallFun(Temp a, Label b, List<Temp> c) {
		super(b, c);
		dest = a;
	}
	
	public String toString() {
		return dest + " = " + super.toString();
	}
	
	@Override
	public List<Assem> gen() {
		List<Assem> result = super.gen();
		result.add(new Assem("move @, $v0", dest));
		return result;
	}

	@Override
	public Set<Temp> def() {
		Set<Temp> set = super.def();
		set.add(dest);
		return set;
	}
}

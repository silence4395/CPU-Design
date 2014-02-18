package bigproject.ast;

import java.util.List;

public class CommaExp extends Exp {

	public List<Exp> exps = null;
	
	public CommaExp(List<Exp> a) {
		exps = a;
	}
	
}

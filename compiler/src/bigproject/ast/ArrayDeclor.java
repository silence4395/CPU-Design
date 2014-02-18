package bigproject.ast;

import java.util.List;

public class ArrayDeclor extends Declor {

	public PlanDeclor name;
	public List<Exp> dim = null;
	
	public ArrayDeclor(PlanDeclor a, List<Exp> b) {
		name = a;
		dim = b;
	}

}

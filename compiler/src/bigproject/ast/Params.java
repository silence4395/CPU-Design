package bigproject.ast;

import java.util.List;

public class Params extends Ast {
	
	public List<PlanDecl> parameters = null;
	public boolean bdc;
	
	public Params(List<PlanDecl> a, boolean b) {
		parameters = a;
		bdc = b;
	}

}

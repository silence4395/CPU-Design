package bigproject.ast;

public class FunDecl extends DeclStat {
	
	public Ty type;
	public PlanDeclor name;
	public Params parameters;
	public CompStat body;
	
	public FunDecl(Ty a, PlanDeclor b, CompStat c) {
		this(a, b, null, c);
	}
	
	public FunDecl(Ty a, PlanDeclor b, Params c, CompStat d) {
		type = a;
		name = b;
		parameters = c;
		body = d;
	}
	
}

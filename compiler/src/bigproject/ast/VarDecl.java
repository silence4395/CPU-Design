package bigproject.ast;

public class VarDecl extends DeclStat {
	
	public Ty type;
	public InitDeclors initdecl;
	
	public VarDecl(Ty a) {
		this(a, null);
	}
	
	public VarDecl(Ty a, InitDeclors b) {
		type = a;
		initdecl = b;
	}
}

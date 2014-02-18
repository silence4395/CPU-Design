package bigproject.ast;

public class Initer extends Ast {

	public Exp body;
	public Initers anotherbody;
	
	public Initer(Exp a) {
		body = a;
		anotherbody = null;
	}
	
	public Initer(Initers a) {
		body = null;
		anotherbody = a;
	}
}

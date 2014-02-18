package bigproject.ast;

public class InitDeclor extends Ast {

	public Declor name;
	public Initer init;
	
	public InitDeclor(Declor a) {
		this(a, null);
	}
	
	public InitDeclor(Declor a, Initer b) {
		name = a;
		init = b;
		assigned = false;
	}
	
	public Boolean assigned = false;
}

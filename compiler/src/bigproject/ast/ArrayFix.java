package bigproject.ast;

public class ArrayFix extends Postfix {
	
	public Exp body;
	
	public ArrayFix(Exp a) {
		body = a;
	}

}

package bigproject.ast;

public class FunFix extends Postfix {

	public Arguments argus;
	
	public FunFix() {
		argus = null;
	}
	
	public FunFix(Arguments a) {
		argus = a;
	}
}

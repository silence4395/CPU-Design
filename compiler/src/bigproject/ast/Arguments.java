package bigproject.ast;

import java.util.List;

public class Arguments extends Exp {

	public List<Exp> argus = null;
	
	public Arguments(List<Exp> a) {
		argus = a;
	}

}

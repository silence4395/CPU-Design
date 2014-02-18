package bigproject.env;

import bigproject.translate.Temp;
import bigproject.types.Type;

public class VarEntry extends Entry {

	public Temp temp = null;
	
	public VarEntry(Type a, Temp b) {
		super(a);
		temp = b;
	}
	
}

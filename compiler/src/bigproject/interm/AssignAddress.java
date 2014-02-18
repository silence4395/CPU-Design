package bigproject.interm;

import bigproject.translate.Temp;

public class AssignAddress extends Interm {

	public Temp dest = null;
	public Temp source = null;
	
	public AssignAddress(Temp a, Temp b) {
		dest = a;
		source = b;
	}
	
	public String toString() {
		return dest + " = @ " + source;
	}
	
	@Override
	public void replaceUseTemp(Temp oldt, Temp newt) {
		if (source.equals(oldt))
			source = newt;
	}
	
	// TODO
}

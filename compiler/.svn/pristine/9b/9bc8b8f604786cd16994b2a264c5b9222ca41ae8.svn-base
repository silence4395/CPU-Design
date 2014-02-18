package bigproject.types;

import bigproject.translate.Addr;
import bigproject.translate.Const;

public class Array extends Pointer {

	public int capacity = -1;
	public Addr addr = null;
	
	public Array(Type a) {
		super(a);
	}
	
	public Array(Type a, int b) {
		super(a);
		capacity = b;
	}
	
	public Array(Type a, Integer b) {
		super(a);
		if (b != null)
			capacity = b.intValue();
	}

	public Array(Type a, Addr b) {
		super(a);
		addr = b;
		if (addr instanceof Const)
			capacity = ((Const) addr).value;
	}

	public boolean coerceTo(Type type) {
		return type.actual() == this.actual();
	}
	
	public int size() {
		return capacity * elementtype.size();
	}

}

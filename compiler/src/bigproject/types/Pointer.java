package bigproject.types;

public class Pointer extends Type {

	public Type elementtype;
	
	public Pointer() {
		elementtype = null;
	}
	
	public Pointer(Type a) {
		elementtype = a;
	}
	
	public void bind(Type a) {
		if (elementtype instanceof Pointer)
			((Pointer) elementtype).bind(a);
		else if (elementtype instanceof Function)
			((Function) elementtype).setReturnType(a);
		else
			elementtype = a;
	}
	
	public boolean coerceTo(Type type) {
		return type.actual() instanceof Pointer;
	}
	
	public int size() {
		return 1;
	}
	
}

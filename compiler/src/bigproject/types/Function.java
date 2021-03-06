package bigproject.types;

public class Function extends Type {

	public Record argumenttype;
	public Type returntype = null;
	public boolean defined = false;
	
	public Function(Record a, Type b) {
		argumenttype = a;
		returntype = b;
		defined = false;
	}
	
	public void setReturnType(Type a) {
		if (returntype instanceof Pointer)
			((Pointer) returntype).bind(a);
		else
			returntype = a;
	}
	
	public void setDefined() {
		defined = true;
	}
	
	public int size() {
		return returntype.size();
	}
	
}

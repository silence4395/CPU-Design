package bigproject.types;

public class Int extends Type {

	public boolean coerceTo(Type type) {
		return (type.actual() instanceof Int) ||
			   (type.actual() instanceof Char);
	}
	
	public int size() {
		return 1;
	}
	
}

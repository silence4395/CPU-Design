package bigproject.types;

import bigproject.symbol.*;

public class Name extends Type {

	public Symbol name;
	public Type acttype = null;
	public int recordclass; // 0: struct; 1: union;
	
	public Name(Symbol a) {
		name = a;
	}
	
	public void bind(Type a) {
		acttype = a;
	}
	
	public void setStruct() {
		recordclass = 0;
	}
	
	public void setUnion() {
		recordclass = 1;
	}
	
	public boolean coerceTo(Type type) {
		return this.actual().coerceTo(type);
	}
	
	public Type actual() {
		if (acttype == null)
			return null;
		else
			return acttype.actual();
	}
	
	public int size() {
		return acttype.size();
	}
}

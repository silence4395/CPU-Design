package bigproject.types;

import java.util.ArrayList;
import java.util.List;

import bigproject.symbol.*;

public class Record extends Type {

	public class RecordField {
		public Symbol name;
		public Type type;
		public RecordField(Symbol a, Type b) {
			name = a;
			type = b;
		}
	}
	
	public List<RecordField> fields = null;
	
	public Record() {
		fields = new ArrayList<RecordField>();
	}
	
	public Record(Symbol a, Type b) {
		fields = new ArrayList<RecordField>();
		fields.add(new RecordField(a, b));
	}
	
	public void addField(Symbol a, Type b) {
		fields.add(new RecordField(a, b));
	}
	
	public boolean coerceTo(Type type) {
		return type.actual() == this.actual();
	}
	
	public List<Type> getFieldsType() {
		List<Type> result = new ArrayList<Type>();
		for (RecordField field: fields) {
			result.add(field.type);
		}
		return result;
	}

	public boolean hasField(Symbol name) {
		for (RecordField field: fields)
			if (field.name == name)
				return true;
		return false;
	}

	public Type getField(Symbol name) {
		for (RecordField field: fields)
			if (field.name == name)
				return field.type;
		return null;
	}
	
	public int getFieldIndex(Symbol name) {
		int sum = 0;
		for (int i=0; i<fields.size(); i++) {
			if (fields.get(i).name == name)
				return sum;
			sum = sum + fields.get(i).type.size();
		}
		return -1;
	}
	
	public int size() {
		int sum = 0;
		for (int i=0; i<fields.size(); i++)
			sum = sum + fields.get(i).type.size();
		return sum;
	}
	
}

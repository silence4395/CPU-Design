package bigproject.translate;

import java.util.ArrayList;
import java.util.List;

import bigproject.assem.Assem;

public class DataFrag {

	public Label label = null;
	public String value;
	
	public DataFrag(Label a, String b) {
		label = a;
		value = b;
	}
	
	public List<Assem> gen() {
		List<Assem> result = new ArrayList<Assem>();
		result.add(new Assem("!%:", label));
		result.add(new Assem(".asciiz \"%\"", value));
		result.add(new Assem(".align 2"));
		return result;
	}
	
}

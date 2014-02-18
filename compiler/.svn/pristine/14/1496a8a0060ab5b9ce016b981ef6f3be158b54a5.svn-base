package bigproject.interm;

import java.util.ArrayList;
import java.util.List;

import bigproject.assem.Assem;
import bigproject.translate.Label;

public class LabelMark extends Interm {

	public Label label;
	
	public LabelMark(Label a) {
		label = a;
	}
	
	public String toString() {
		return "Label: " + label;
	}
	
	@Override
	public List<Assem> gen() {
		List<Assem> result = new ArrayList<Assem>();
		result.add(new Assem("!%:", label));
		return result;
	}
	
}

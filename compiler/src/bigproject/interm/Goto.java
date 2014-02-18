package bigproject.interm;

import java.util.ArrayList;
import java.util.List;

import bigproject.assem.Assem;
import bigproject.translate.Label;

public class Goto extends Interm {

	public Label label = null;
	
	public Goto(Label a) {
		label = a;
	}
	
	public String toString() {
		return "goto " + label;
	}
	
	@Override
	public List<Assem> gen() {
		List<Assem> result = new ArrayList<Assem>();
		result.add(new Assem("j %", label));
		return result;
	}
	
	@Override
	public void replaceLabel(Label oldl, Label newl) {
		if (label.equals(oldl))
			label = newl;
	}
	
	@Override
	public Label getLabel() {
		return label;
	}
}

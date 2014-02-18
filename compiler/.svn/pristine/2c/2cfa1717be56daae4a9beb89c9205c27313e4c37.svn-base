package bigproject.interm;

import java.util.ArrayList;
import java.util.List;

import bigproject.assem.Assem;
import bigproject.translate.Label;
import bigproject.translate.Level;

public class Leave extends Interm {

	public Label label = null;
	public Level level = null;
	
	public Leave(Label a, Level b) {
		label = a;
		level = b;
	}
	
	public String toString() {
		return "leave " + label;
	}
	
	@Override
	public List<Assem> gen() {
		List<Assem> result = new ArrayList<Assem>();
		int l = level.frameSize();
		result.addAll(level.loadRegs());
		result.add(new Assem("addiu $sp, $sp, %", l));
		result.add(new Assem("lw $ra, %($sp)", -4));
		result.add(new Assem("jr $ra"));
		return result;
	}
	
}

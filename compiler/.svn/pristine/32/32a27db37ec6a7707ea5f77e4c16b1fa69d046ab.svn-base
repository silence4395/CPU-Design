package bigproject.interm;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import bigproject.assem.Assem;
import bigproject.main.RegConst;
import bigproject.translate.Label;
import bigproject.translate.Level;
import bigproject.translate.Temp;

public class Enter extends Interm {

	public Label label = null;
	public Level level = null;
	public List<Temp> params = null;
	
	public Enter(Label a, Level b, List<Temp> c) {
		label = a;
		level = b;
		params = c;
	}
	
	public String toString() {
		return "enter " + label + ", params are " + params;
	}
	
	@Override
	public List<Assem> gen() {
		List<Assem> result = new ArrayList<Assem>();
		int l = level.frameSize();
		result.add(new Assem("sw $ra, %($sp)", -4));
		result.add(new Assem("addiu $sp, $sp, -%", l));
		result.addAll(level.saveRegs());
		result.addAll(loadArgus());
		return result;
	}
	
	@Override
	public Set<Temp> def() {
		Set<Temp> set = new HashSet<Temp>();
		set.addAll(params);
		return set;
	}
	
	public List<Assem> loadArgus() {
		List<Assem> result = new ArrayList<Assem>();
		int l = level.frameSize();
		int i = 0;
		while ((i < RegConst.ParamRegNum) && (i < params.size())) {
			result.add(new Assem(
				"move @, $%", params.get(i), RegConst.RegNames[RegConst.ParamRegBase+i]
			));
			i = i + 1;
		}
		if (i < params.size()) {
			while (i < params.size()) {
				result.add(new Assem(
					"lw @, %($sp)", params.get(i), l + (i-4) * 4
				));
				i = i + 1;
			}
		}
		return result;
	}
}

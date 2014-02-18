package bigproject.assem;

import java.io.BufferedWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import bigproject.analysis.LiveInterval;
import bigproject.interm.Interm;
import bigproject.interm.CallProc;
import bigproject.main.RegConst;
import bigproject.opt.StrengthReduction;
import bigproject.regalloc.RegAlloc;
import bigproject.translate.CompUnit;
import bigproject.translate.Temp;

public class Codegen {

	public List<Assem> inits = null;
	public List<String> lines = null;
	private List<Assem> assems = null;
	
	public Codegen() {
		inits = new ArrayList<Assem>();
		lines = new ArrayList<String>();
	}
	
	public void gen(Assem a) {
		inits.add(a);
	}
	
	public void gen(List<Assem> a) {
		inits.addAll(a);
	}
	
	public void gen(CompUnit unit, RegAlloc alloc) {
		assems = new ArrayList<Assem>();
		if (unit.label.name.equals("main"))
			for (Interm interm: unit.interms) {
				assems.addAll(interm.gen());
			}
		else {
			assems.addAll(unit.interms.get(0).gen());
			assems.addAll(unit.interms.get(1).gen());
			loadGlobalVar(unit, alloc);
			for (int i = 2; i < unit.interms.size()-1; i++) {
				if (unit.interms.get(i) instanceof CallProc) {
					saveGlobalVar(unit, alloc);
					assems.addAll(unit.interms.get(i).gen());
					loadGlobalVar(unit, alloc);				
				} else
					assems.addAll(unit.interms.get(i).gen());
			}
			saveGlobalVar(unit, alloc);
			assems.addAll(unit.interms.get(unit.interms.size()-1).gen());
		}
		for (Assem assem: assems) {
			lines.add(StrengthReduction.work(assem).toString(alloc));
		}
	}

	private void saveGlobalVar(CompUnit unit, RegAlloc alloc) {
		Set<Temp> globalvars = new HashSet<Temp>();
		for (Interm interm: unit.interms)
			for (Temp temp: interm.def())
				if (temp.level.depth == 0)
					globalvars.add(temp);
		for (Temp temp: globalvars) {
			LiveInterval i = temp.getLiveInterval();
			if (!i.spilled) {
				assems.add(new Assem(
					"sw $" + RegConst.RegNames[i.register] + ", " + 4 * temp.index + "($gp)"
				));
			}
		}
	}

	private void loadGlobalVar(CompUnit unit, RegAlloc alloc) {
		Set<Temp> globalvars = new HashSet<Temp>();
		for (Interm interm: unit.interms)
			for (Temp temp: interm.use())
				if (temp.level.depth == 0)
					globalvars.add(temp);
		for (Temp temp: globalvars) {
			LiveInterval i = temp.getLiveInterval();
			if (!i.spilled) {
				assems.add(new Assem(
					"lw $" + RegConst.RegNames[i.register] + ", " + 4 * temp.index + "($gp)"
				));
			}
		}
	}

	public void printToFile(BufferedWriter writer) throws IOException {
		for (Assem init: inits) {
			writer.write(init.toString());
			writer.newLine();
		}
		for (String line: lines) {
			if (line.equals("syshalt")) {
				writer.write("li $v0, 10");
				writer.newLine();
				writer.write("syscall");
				writer.newLine();
			} else {
				writer.write(line);
				writer.newLine();
			}
		}
	}
	
	public void printToScreen() throws IOException {
		for (Assem init: inits)
			System.out.println(init.toString());
		for (String line: lines)
			if (line.equals("syshalt")) {
				System.out.println("li $v0, 10");
				System.out.println("syscall");
			} else {
				System.out.println(line);
			}
	}

	public List<String> getCode() {
		List<String> result = new ArrayList<String>();
		for (Assem init: inits)
			result.add(init.toString());
		for (String line: lines)
			result.add(line);
		return result;
	}
}

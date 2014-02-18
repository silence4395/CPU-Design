package bigproject.opt;

import bigproject.ast.*;

public class LoopUnroll_Check {

	int loopcount = 0;
	boolean loopcountchanged;
	
	public void work(Program tree) {
		checkProgram(tree);
	}
	
	public void checkProgram(Program node) {
		for (DeclStat decl: node.body)
			checkDeclStat((DeclStat) decl);
	}
	
	private void checkDeclStat(DeclStat node) {
		if (node instanceof FunDecl)
			checkDeclStat((FunDecl) node);
	}
	
	private void checkDeclStat(FunDecl node) {
		checkStat(node.body);
	}

	private void checkStat(CompStat node) {
		for (DeclStat decl: node.declors)
			checkDeclStat(decl);
		for (Stat stat: node.stats)
			checkStat(stat);
	}
	
	private void checkStat(Stat node) {
		if (node instanceof CompStat)
			checkStat((CompStat) node);
		if (node instanceof SelectStat)
			checkStat((SelectStat) node);
		if (node instanceof WhileStat)
			checkStat((WhileStat) node);
		if (node instanceof ForStat)
			checkStat((ForStat) node);
	}

	private void checkStat(SelectStat node) {
		checkStat(node.thenclause);
		if (node.elseclause != null)
			checkStat(node.elseclause);
	}

	private void checkStat(WhileStat node) {
		checkStat(node.body);
	}

	private void checkStat(ForStat node) {
		loopcount = loopcount + 1;
		loopcountchanged = false;
		checkStat(node.body);
		if (loopcountchanged)
			node.unrollable = false;
		loopcount = loopcount - 1;
		loopcountchanged = true;
	}

}

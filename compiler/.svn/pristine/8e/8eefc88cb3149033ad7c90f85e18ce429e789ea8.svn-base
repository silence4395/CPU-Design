package bigproject.opt;

import bigproject.ast.Program;

public class ConstantInline {

	public void findVarDec(Program tree) {
		new CstInline_FindVarDec().work(tree);
	}

	public void check(Program tree) {
		new CstInline_Check().work(tree);
	}

	private Boolean rewrited = false;
	
	public Boolean isRewrited() {
		return rewrited;
	}

	public Program rewrite(Program tree) {
		CstInline_Rewriter rewriter = new CstInline_Rewriter();
		Program newprog = rewriter.work(tree);
		rewrited = rewriter.isRewrited();
		return newprog;
	}

}

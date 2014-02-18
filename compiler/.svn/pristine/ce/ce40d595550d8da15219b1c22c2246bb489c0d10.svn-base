package bigproject.opt;

import bigproject.ast.Program;

public class LoopUnrolling {
	
	public void check(Program tree) {
		new LoopUnroll_Check().work(tree);
	}

	public void rewrite(Program tree) {
		LoopUnroll_Rewriter rewriter = new LoopUnroll_Rewriter();
		rewriter.work(tree);
		rewrited = rewriter.isRewrited();
	}

	Boolean rewrited = false;
	
	public Boolean isRewrited() {
		return rewrited;
	}

}

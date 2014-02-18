package bigproject.opt;

import bigproject.ast.*;

public class CstInline_Rewriter {

	private Boolean rewrited = false;
	
	public Program work(Program node) {
		rewrited = false;
		return checkProgram(node);
	}

	private Program checkProgram(Program node) {
		for (int i = 0; i < node.body.size(); i++) {
			checkDeclStat((DeclStat) node.body.get(i));
		}
		return node;
	}
	
	private void checkDeclStat(DeclStat node) {
		if (node instanceof VarDecl)
			checkDeclStat((VarDecl) node);
		if (node instanceof FunDecl)
			checkDeclStat((FunDecl) node);
	}
	
	private void checkDeclor(Declor node) {
		if (node instanceof ArrayDeclor)
			checkDeclor((ArrayDeclor) node);
	}
	
	private void checkParams(Params node) {
		if (node == null) 
			return;
		for (PlanDecl decl: node.parameters)
			checkPlanDecl(decl);
	}

	private void checkPlanDecl(PlanDecl node) {
		checkDeclor(node.decl);
	}

	private void checkDeclor(ArrayDeclor node) {
		for (int i=node.dim.size()-1; i>=0; i--) {
			node.dim.set(i, checkExp(node.dim.get(i)));
		}
	}

	private void checkDeclStat(VarDecl node) {
		checkInitDeclors(node.initdecl);
	}
	
	private void checkInitDeclors(InitDeclors node) {
		if (node == null)
			return;
		for (InitDeclor decl: node.decls)
			checkInitDeclor(decl);
	}

	private void checkInitDeclor(InitDeclor node) {
		checkDeclor(node.name);
		checkIniter(node.init);
	}

	private void checkIniter(Initer node) {
		if (node == null)
			return;
		if (node.anotherbody == null) {
			node.body = checkExp(node.body);
			return;
		}
		checkIniters(node.anotherbody);
	}

	private void checkIniters(Initers node) {
		for (Initer initer: node.body)
			checkIniter(initer);
	}

	private void checkDeclStat(FunDecl node) {
		checkParams(node.parameters);
		checkStat(node.body);
	}

	private void checkStat(CompStat node) {
		for (DeclStat decl: node.declors)
			checkDeclStat(decl);
		for (Stat stat: node.stats)
			checkStat(stat);
	}
	
	private void checkStat(Stat node) {
		if (node instanceof ExpStat)
			checkStat((ExpStat) node);
		if (node instanceof CompStat)
			checkStat((CompStat) node);
		if (node instanceof SelectStat)
			checkStat((SelectStat) node);
		if (node instanceof WhileStat)
			checkStat((WhileStat) node);
		if (node instanceof ForStat)
			checkStat((ForStat) node);
		if (node instanceof JumpStat)
			checkStat((JumpStat) node);
	}

	private void checkStat(ExpStat node) {
		if (node.body != null)
			node.body = checkExp(node.body);
	}

	private void checkStat(SelectStat node) {
		node.condition = checkExp(node.condition);
		checkStat(node.thenclause);
		if (node.elseclause != null)
			checkStat(node.elseclause);
	}

	private void checkStat(WhileStat node) {
		node.condition = checkExp(node.condition);
		checkStat(node.body);
	}

	private void checkStat(ForStat node) {
		if (node.firstcond != null) {
			node.firstcond = checkExp(node.firstcond);
		}
		if (node.secondcond != null) {
			node.secondcond = checkExp(node.secondcond);
		}
		if (node.thirdcond != null) {
			node.thirdcond = checkExp(node.thirdcond);
		}
		checkStat(node.body);
	}

	private void checkStat(JumpStat node) {
		if (node instanceof ReturnStat)
			if (((ReturnStat) node).result != null) {
				((ReturnStat) node).result = checkExp(((ReturnStat) node).result);
			}
	}

	private Exp checkExp(Exp node) {
		if (node instanceof CommaExp)
			return checkExp((CommaExp) node);
		if (node instanceof AssignExp)
			return checkExp((AssignExp) node);
		if (node instanceof OpExp)
			return checkExp((OpExp) node);
		if (node instanceof CoerceExp)
			return checkExp((CoerceExp) node);
		if (node instanceof SingleOpExp)
			return checkExp((SingleOpExp) node);
		if (node instanceof SizeofExp)
			return checkExp((SizeofExp) node);
		if (node instanceof PostfixExp)
			return checkExp((PostfixExp) node);
		if (node instanceof VarExp)
			return checkExp((VarExp) node);
		return node;
	}
	
	private Exp checkExp(VarExp node) {
		InitDeclor vd = node.dec;
		if ((vd != null) && (!vd.assigned))
			if ((vd.init != null) && (vd.init.body != null)) {
				Ast exp = vd.init.body;
				while (exp instanceof OpExp) {
					exp = ((OpExp) exp).explist.get(0);
				}
				if (exp instanceof PostfixExp)
					exp = ((PostfixExp) exp).body;
				if ((exp instanceof IntExp) ||
					(exp instanceof CharExp)) {
					rewrited = true;
					return vd.init.body;
				}
			}
		return node;
	}

	private Exp checkExp(PostfixExp node) {
		node.body = checkExp(node.body);
		for (int i = 0; i < node.postfixes.size(); i++) {
			Postfix postfix = node.postfixes.get(i);
			if (postfix instanceof ArrayFix) {
				ArrayFix arrayfix = (ArrayFix) postfix;
				node.postfixes.set(i, new ArrayFix(checkExp(arrayfix.body)));
			} else if (postfix instanceof FunFix) {
				FunFix funfix = (FunFix) postfix;
				funfix = new FunFix(checkArguments(funfix.argus));
				node.postfixes.set(i, funfix);
			}
		}
		return node;
	}

	private Arguments checkArguments(Arguments argus) {
		if (argus != null) {
			for (int i=0; i<argus.argus.size(); i++) {
				argus.argus.set(i, checkExp(argus.argus.get(i)));
			}
		}
		return argus;
	}

	private Exp checkExp(SizeofExp node) {
		if (node.type == null)
			node.body = checkExp(node.body);
		return node;
	}

	private Exp checkExp(SingleOpExp node) {
		node.body = checkExp(node.body);
		return node;
	}

	private Exp checkExp(CommaExp node) {
		for (int i = 0; i < node.exps.size(); i++)
			node.exps.set(i, checkExp(node.exps.get(i)));
		return node;
	}

	private Exp checkExp(AssignExp node) {
		node.left = checkExp(node.left);
		node.right = checkExp(node.right);
		return node;
	}
	
	private Exp checkExp(OpExp node) {
		for (int i=0; i<node.explist.size(); i++)
			node.explist.set(i, checkExp(node.explist.get(i)));
		return node;
	}

	private Exp checkExp(CoerceExp node) {
		node.body = checkExp(node.body);
		return node;
	}

	public Boolean isRewrited() {
		return rewrited;
	}

}

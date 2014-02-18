package bigproject.opt;

import bigproject.ast.*;

public class AstReduce {
	
	public Program work(Program node) {
		return checkProgram(node);
	}

	private Program checkProgram(Program node) {
		for (int i = 0; i < node.body.size(); i++) {
			checkDeclStat((DeclStat) node.body.get(i));
		}
		return node;
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
		return node;
	}
	
	private Exp checkExp(PostfixExp node) {
		node.body = checkExp(node.body);
		if (node.postfixes.size() == 0)
			return node.body;
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
		if (node.exps.size() == 1)
			return node.exps.get(0);
		else
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
		if (node.explist.size() == 1)
			return node.explist.get(0);
		else
			return node;
	}

	private Exp checkExp(CoerceExp node) {
		node.body = checkExp(node.body);
		return node;
	}

}

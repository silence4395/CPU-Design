package bigproject.opt;

import java.util.ArrayList;
import java.util.List;

import bigproject.ast.*;
import bigproject.symbol.Symbol;
import bigproject.symbol.Table;

public class CstInline_FindVarDec {

	public void work(Program tree) {
		checkProgram(tree);
	}
	
	private Table env = new Table();
	
	public void checkProgram(Program node) {
		for (DeclStat decl: node.body) {
			checkDeclStat((DeclStat) decl);
		}
	}
	
	private void checkDeclStat(DeclStat node) {
		if (node instanceof VarDecl)
			checkDeclStat((VarDecl) node);
		if (node instanceof FunDecl)
			checkDeclStat((FunDecl) node);
	}
	
	private Symbol checkDeclor(Declor node) {
		if (node instanceof ArrayDeclor)
			return checkDeclor((ArrayDeclor) node);
		return null;
	}
	
	private List<Symbol> checkParams(Params node) {
		List<Symbol> list = new ArrayList<Symbol>();
		if (node == null) 
			return list;
		for (PlanDecl decl: node.parameters)
			list.add(checkPlanDecl(decl));
		return list;
	}

	private Symbol checkPlanDecl(PlanDecl node) {
		return checkDeclor(node.decl);
	}

	private Symbol checkDeclor(ArrayDeclor node) {
		for (int i=node.dim.size()-1; i>=0; i--) {
			checkExp(node.dim.get(i));
		}
		return checkPlanDeclor(node.name);
	}

	private Symbol checkPlanDeclor(PlanDeclor node) {
		return node.name;
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
		Symbol name = checkDeclor(node.name);
		if (name != null)
			env.put(name, node);
		checkIniter(node.init);
	}

	private void checkIniter(Initer node) {
		if (node == null)
			return;
		if (node.anotherbody == null) {
			checkExp(node.body);
			return;
		}
		checkIniters(node.anotherbody);
	}

	private void checkIniters(Initers node) {
		for (Initer initer: node.body)
			checkIniter(initer);
	}

	private void checkDeclStat(FunDecl node) {
		List<Symbol> parameters = checkParams(node.parameters);
		env.beginScope();
		if (parameters != null)
			for (Symbol field: parameters)
				env.put(field, null);
		checkStat(node.body);
		env.endScope();
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
		if (node instanceof CompStat) {
			env.beginScope();
			checkStat((CompStat) node);
			env.endScope();
		}
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
			checkExp(node.body);
	}

	private void checkStat(SelectStat node) {
		checkExp(node.condition);
		checkStat(node.thenclause);
		if (node.elseclause != null)
			checkStat(node.elseclause);
	}

	private void checkStat(WhileStat node) {
		checkExp(node.condition);
		checkStat(node.body);
	}

	private void checkStat(ForStat node) {
		if (node.firstcond != null) {
			checkExp(node.firstcond);
		}
		if (node.secondcond != null) {
			checkExp(node.secondcond);
		}
		if (node.thirdcond != null) {
			checkExp(node.thirdcond);
		}
		checkStat(node.body);
	}

	private void checkStat(JumpStat node) {
		if (node instanceof ReturnStat)
			if (((ReturnStat) node).result != null) {
				checkExp(((ReturnStat) node).result);
			}
	}

	private void checkExp(Exp node) {
		if (node instanceof CommaExp)
			checkExp((CommaExp) node);
		if (node instanceof AssignExp)
			checkExp((AssignExp) node);
		if (node instanceof OpExp)
			checkExp((OpExp) node);
		if (node instanceof CoerceExp)
			checkExp((CoerceExp) node);
		if (node instanceof SingleOpExp)
			checkExp((SingleOpExp) node);
		if (node instanceof SizeofExp)
			checkExp((SizeofExp) node);
		if (node instanceof PostfixExp)
			checkExp((PostfixExp) node);
		if (node instanceof VarExp)
			checkExp((VarExp) node);
	}
	
	private void checkExp(VarExp node) {
		InitDeclor var = (InitDeclor) env.get(node.name);
		node.dec = var;
	}

	private void checkExp(PostfixExp node) {
		checkExp(node.body);
		for (Postfix postfix: node.postfixes) {
			if (postfix instanceof ArrayFix) {
				checkExp(((ArrayFix) postfix).body);
			} else if (postfix instanceof FunFix) {
				checkArguments(((FunFix) postfix).argus);
			}
		}
	}

	private void checkArguments(Arguments argus) {
		if (argus != null) {
			for (int i=0; i<argus.argus.size(); i++) {
				checkExp(argus.argus.get(i));
			}
		}
	}

	private void checkExp(SizeofExp node) {
		if (node.type == null)
			checkExp(node.body);
	}

	private void checkExp(SingleOpExp node) {
		checkExp(node.body);
	}

	private void checkExp(CommaExp node) {
		for (Exp eachexp: node.exps)
			checkExp(eachexp);
	}

	private void checkExp(AssignExp node) {
		checkExp(node.left);
		checkExp(node.right);
	}
	
	private void checkExp(OpExp node) {
		for (int i=0; i<node.explist.size(); i++) {
			checkExp(node.explist.get(i));
		}
	}

	private void checkExp(CoerceExp node) {
		checkExp(node.body);
	}

}

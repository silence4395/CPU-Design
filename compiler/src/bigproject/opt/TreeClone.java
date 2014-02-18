package bigproject.opt;

import java.util.ArrayList;
import java.util.List;

import bigproject.ast.*;

public class TreeClone {

	public CompStat cloneCompStat(CompStat node) {
		List<DeclStat> list1 = new ArrayList<DeclStat>(); 
		List<Stat> list2 = new ArrayList<Stat>();
		for (DeclStat a: node.declors)
			list1.add(cloneDeclStat(a));
		for (Stat a: node.stats)
			list2.add(cloneStat(a));
		return new CompStat(list1, list2);
	}

	public Stat cloneStat(Stat node) {
		if (node == null)
			return null;
		if (node instanceof ExpStat)
			return cloneExpStat((ExpStat) node);
		if (node instanceof CompStat)
			return cloneCompStat((CompStat) node);
		if (node instanceof SelectStat)
			return cloneSelectStat((SelectStat) node);
		if (node instanceof WhileStat)
			return cloneWhileStat((WhileStat) node);
		if (node instanceof ForStat)
			return cloneForStat((ForStat) node);
		if (node instanceof JumpStat)
			return cloneJumpStat((JumpStat) node);
		return null;
	}

	private JumpStat cloneJumpStat(JumpStat node) {
		if (node instanceof ContinueStat)
			return new ContinueStat();
		if (node instanceof BreakStat)
			return new BreakStat();
		if (node instanceof ReturnStat) {
			Exp exp = cloneExp(((ReturnStat) node).result);
			return new ReturnStat(exp);
		}
		return null;
	}

	private Exp cloneExp(Exp node) {
		if (node == null)
			return null;
		if (node instanceof CommaExp)
			return cloneCommaExp((CommaExp) node);
		if (node instanceof AssignExp)
			return cloneAssignExp((AssignExp) node);
		if (node instanceof OpExp)
			return cloneOpExp((OpExp) node);
		if (node instanceof CoerceExp)
			return cloneCoerceExp((CoerceExp) node);
		if (node instanceof SingleOpExp)
			return cloneSingleOpExp((SingleOpExp) node);
		if (node instanceof SizeofExp)
			return cloneSizeofExp((SizeofExp) node);
		if (node instanceof PostfixExp)
			return clonePostfixExp((PostfixExp) node);
		if (node instanceof VarExp)
			return cloneVarExp((VarExp) node);
		if (node instanceof StringExp)
			return new StringExp(((StringExp) node).body);
		if (node instanceof IntExp)
			return new IntExp(((IntExp) node).value);
		if (node instanceof CharExp)
			return new CharExp("+" + ((CharExp) node).value + "+");
		return null;
	}

	private Exp cloneVarExp(VarExp node) {
		return new VarExp(node.name);
	}

	private Exp clonePostfixExp(PostfixExp node) {
		Exp exp = cloneExp(node.body);
		List<Postfix> list = new ArrayList<Postfix>();
		for (Postfix postfix: node.postfixes)
			list.add(clonePostfix(postfix));
		return new PostfixExp(exp, list);
	}

	private Postfix clonePostfix(Postfix node) {
		if (node instanceof ArrayFix)
			return new ArrayFix(cloneExp(((ArrayFix) node).body));
		else if (node instanceof FunFix)
			return new FunFix(cloneArguments(((FunFix) node).argus));
		else if (node instanceof FieldFix)
			return new FieldFix(((FieldFix) node).name);
		else if (node instanceof BelongFix)
			return new BelongFix(((BelongFix) node).name);
		else
			return node;
	}

	private Arguments cloneArguments(Arguments node) {
		List<Exp> list = new ArrayList<Exp>();
		for (Exp exp: node.argus)
			list.add(cloneExp(exp));
		return new Arguments(list);
	}

	private Exp cloneSizeofExp(SizeofExp node) {
		if (node.type == null) {
			Exp exp = cloneExp(node.body);
			return new SizeofExp(exp);
		} else {
			return new SizeofExp(node.type, node.stars);
		}
	}

	private Exp cloneSingleOpExp(SingleOpExp node) {
		Exp exp = cloneExp(node.body);
		return new SingleOpExp(exp, node.op);
	}

	private Exp cloneCoerceExp(CoerceExp node) {
		Exp exp = cloneExp(node.body);
		return new CoerceExp(node.type, node.stars, exp);
	}

	private Exp cloneOpExp(OpExp node) {
		if (node.oplist == null) {
			List<Exp> list = new ArrayList<Exp>();
			for (Exp exp: node.explist)
				list.add(cloneExp(exp));
			return new OpExp(list, node.op);
		} else {
			List<Exp> list = new ArrayList<Exp>();
			for (Exp exp: node.explist)
				list.add(cloneExp(exp));
			List<Integer> list2 = new ArrayList<Integer>(node.oplist);
			return new OpExp(list, list2);
		}
	}

	private Exp cloneAssignExp(AssignExp node) {
		Exp exp1 = cloneExp(node.left);
		Exp exp2 = cloneExp(node.right);
		return new AssignExp(exp1, node.op, exp2);
	}

	private Exp cloneCommaExp(CommaExp node) {
		List<Exp> list = new ArrayList<Exp>();
		for (Exp exp: node.exps)
			list.add(cloneExp(exp));
		return new CommaExp(list);
	}

	private ForStat cloneForStat(ForStat node) {
		ForStat forstat = new ForStat();
		forstat.setFirstCond(cloneExp(node.firstcond));
		forstat.setSecondCond(cloneExp(node.secondcond));
		forstat.setThirdCond(cloneExp(node.thirdcond));
		forstat.setBody(cloneStat(node.body));
		return forstat;
	}

	private WhileStat cloneWhileStat(WhileStat node) {
		return new WhileStat(cloneExp(node.condition), cloneStat(node.body));
	}

	private SelectStat cloneSelectStat(SelectStat node) {
		return new SelectStat(cloneExp(node.condition),
							  cloneStat(node.thenclause),
							  cloneStat(node.elseclause));
	}

	private ExpStat cloneExpStat(ExpStat node) {
		return new ExpStat(cloneExp(node.body));
	}

	private DeclStat cloneDeclStat(DeclStat node) {
		if (node instanceof TypeDecl)
			return cloneTypeDecl((TypeDecl) node);
		if (node instanceof VarDecl)
			return cloneVarDecl((VarDecl) node);
		if (node instanceof FunDecl)
			return cloneFunDecl((FunDecl) node);
		return null;
	}

	private DeclStat cloneFunDecl(FunDecl node) {
		CompStat compstat = cloneCompStat(node.body);
		Params params = cloneParams(node.parameters);
		PlanDeclor plandeclor = clonePlanDeclor(node.name);
		return new FunDecl(node.type, plandeclor, params, compstat);
	}

	private PlanDeclor clonePlanDeclor(PlanDeclor node) {
		return new PlanDeclor(node.name, node.stars);
	}

	private PlanDecl clonePlanDecl(PlanDecl node) {
		Declor declor = cloneDeclor(node.decl);
		return new PlanDecl(node.type, declor);
	}

	private Declor cloneDeclor(Declor node) {
		if (node instanceof FunDeclor)
			return cloneFunDeclor((FunDeclor) node);
		if (node instanceof ArrayDeclor)
			return cloneArrayDeclor((ArrayDeclor) node);
		return null;
	}

	private ArrayDeclor cloneArrayDeclor(ArrayDeclor node) {
		List<Exp> list = new ArrayList<Exp>();
		for (Exp exp: node.dim)
			list.add(cloneExp(exp));
		PlanDeclor plandeclor = clonePlanDeclor(node.name);
		return new ArrayDeclor(plandeclor, list);
	}

	private FunDeclor cloneFunDeclor(FunDeclor node) {
		PlanDeclor plandeclor = clonePlanDeclor(node.name);
		Params params = cloneParams(node.parameters);
		return new FunDeclor(plandeclor, params);
	}

	private Params cloneParams(Params node) {
		List<PlanDecl> list = new ArrayList<PlanDecl>();
		if (node == null)
			return null;
		for (PlanDecl plandecl: node.parameters)
			list.add(clonePlanDecl(plandecl));
		return new Params(list, node.bdc);
	}

	private DeclStat cloneVarDecl(VarDecl node) {
		InitDeclors initdeclors = cloneInitDeclors(node.initdecl);
		return new VarDecl(node.type, initdeclors);
	}

	private InitDeclors cloneInitDeclors(InitDeclors node) {
		if (node == null)
			return null;
		List<InitDeclor> list = new ArrayList<InitDeclor>();
		for (InitDeclor initdeclor: node.decls)
			list.add(cloneInitDeclor(initdeclor));
		return new InitDeclors(list);
	}

	private InitDeclor cloneInitDeclor(InitDeclor node) {
		Initer initer = cloneIniter(node.init);
		Declor declor = cloneDeclor(node.name);
		return new InitDeclor(declor, initer);
	}

	private Initer cloneIniter(Initer node) {
		if (node == null)
			return null;
		if (node.anotherbody == null)
			return new Initer(cloneExp(node.body));
		else
			return new Initer(cloneIniters(node.anotherbody));
	}

	private Initers cloneIniters(Initers node) {
		List<Initer> list = new ArrayList<Initer>();
		for (Initer initer: node.body)
			list.add(cloneIniter(initer));
		return new Initers(list);
	}

	private DeclStat cloneTypeDecl(TypeDecl node) {
		Declors declors = cloneDeclors(node.decls);
		return new TypeDecl(node.type, declors);
	}

	private Declors cloneDeclors(Declors node) {
		List<Declor> list = new ArrayList<Declor>();
		for (Declor declor: node.body)
			list.add(cloneDeclor(declor));
		return new Declors(list);
	}

}

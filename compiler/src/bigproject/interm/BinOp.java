package bigproject.interm;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import bigproject.assem.Assem;
import bigproject.ast.OpExp;
import bigproject.translate.Temp;

public class BinOp extends Interm {

	public Temp dest;
	public Temp left;
	public Temp right;
	public int op;
	
	public BinOp(Temp a, int b, Temp c, Temp d) {
		dest = a;
		left = c;
		right = d;
		op = b;
	}
	
	public String toString() {
		return dest + " = " + left + " " + OpExp.ops[op] + " " + right;
	}
	
	public static String assemStr[] = {
			"",           // ','
			"",           // '||'
			"",           // '&&'
			"or",         // '|'
			"xor",        // '^'
			"and",        // '&'
			"seq",        // '=='
			"sne",        // '!='
			"slt",        // '<'
			"sgt",        // '>'
			"sle",        // '<='
			"sge",        // '>='
			"sll",        // '<<'
			"srl",        // '>>'
			"add",        // '+'
			"sub",        // '-'
			"mul",        // '*'
			"div",        // '/'
			"rem"         // '%'
	};

	@Override
	public List<Assem> gen() {
		List<Assem> result = new ArrayList<Assem>();
		result.add(new Assem("% @, %, %", assemStr[op], dest, left, right));
		return result;
	}
	
	@Override
	public Set<Temp> def() {
		Set<Temp> set = new HashSet<Temp>();
		set.add(dest);
		return set;
	}

	@Override
	public Set<Temp> use() {
		Set<Temp> set = new HashSet<Temp>();
		set.add(left);
		set.add(right);
		return set;
	}

	@Override
	public void replaceUseTemp(Temp oldt, Temp newt) {
		if (left.equals(oldt))
			left = newt;
		if (right.equals(oldt))
			right = newt;
	}
}

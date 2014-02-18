package bigproject.ast;

import java.util.List;

import bigproject.symbol.Symbol;

public class RecordTy extends Ty {

	public Symbol name;
	public int recordclass; // 0: struct 1: union
	public List<Ty> types = null;
	public List<Declors> decls = null;
	
	public RecordTy(int a, List<Ty> b, List<Declors> c) {
		this(null, a, b, c);
	}
	
	public RecordTy(Symbol a, int b) {
		this(a, b, null, null);
	}
	
	public RecordTy(Symbol a, int b, List<Ty> c, List<Declors> d) {
		name = a;
		recordclass = b;
		types = c;
		decls = d;
	}
	
}

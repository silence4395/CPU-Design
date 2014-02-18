package bigproject.ast;

import java.util.List;

public class CompStat extends Stat {

	public List<DeclStat> declors = null;
	public List<Stat> stats = null;
	
	public CompStat(List<DeclStat> a, List<Stat> b) {
		declors = a;
		stats = b;
	}
	
}

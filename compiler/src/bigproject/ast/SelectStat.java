package bigproject.ast;

public class SelectStat extends Stat {

	public Exp condition;
	public Stat thenclause;
	public Stat elseclause;
	
	public SelectStat(Exp a, Stat b) {
		this(a, b, null);
	}
	
	public SelectStat(Exp a, Stat b, Stat c) {
		condition = a;
		thenclause = b;
		elseclause = c;
	}
}

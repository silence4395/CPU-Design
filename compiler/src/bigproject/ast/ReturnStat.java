package bigproject.ast;

public class ReturnStat extends JumpStat {

	public Exp result;
	
	public ReturnStat() {
		result = null;
	}
	
	public ReturnStat(Exp a) {
		result = a;
	}
}

package bigproject.ast;

public class SingleOpExp extends Exp {

	public Exp body;
	public int op;
	
	public SingleOpExp(Exp a, int b) {
		body = a;
		op = b;
	}
	
	public static int DuPlus = 0,        // '++'
					  DuMinus = 1,       // '--'
					  At = 2,            // '&'
					  Star = 3,          // '*'
					  Plus = 4,          // '+'
					  Minus = 5,         // '-'
					  Swung = 6,         // '~'
					  Excal = 7;         // '!'
					  
}

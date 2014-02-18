package bigproject.ast;

public class CharExp extends Exp {

	public char value;
	
	public CharExp(String a) {
		if (a.charAt(1) == '\\') {
			if (a.charAt(2) == 'n')
				value = '\n';
		} else
			value = a.charAt(1);
	}
}

package bigproject.opt;

import bigproject.assem.Assem;
import bigproject.ast.OpExp;
import bigproject.interm.BinOpI;
import bigproject.translate.Const;

public class StrengthReduction {

	public static Assem work(Assem assem) {
		if (assem.format.equals("% @, %, % #I")) {
			if (assem.params[0].equals(BinOpI.assemStr[OpExp.Mult])) {
				int v = ((Const) assem.params[3]).value;
				if (v == 1)
					return new Assem("move @, %", assem.params[1], assem.params[2]);
				int t = 0;
				while (v > 1) {
					if (v % 2 == 0) {
						v = v / 2;
						t = t + 1;
					} else break;
				}
				if (v == 1)
					return new Assem("sll @, %, %", assem.params[1], assem.params[2], t);
			} else if (assem.params[0].equals(BinOpI.assemStr[OpExp.Div])) {
				int v = ((Const) assem.params[3]).value;
				if (v == 1)
					return new Assem("move @, %", assem.params[1], assem.params[2]);
				int t = 0;
				while (v > 1) {
					if (v % 2 == 0) {
						v = v / 2;
						t = t + 1;
					} else break;
				}
				if (v == 1)
					return new Assem("sra @, %, %", assem.params[1], assem.params[2], t);
			}
		}
		return assem;
	}
	
}

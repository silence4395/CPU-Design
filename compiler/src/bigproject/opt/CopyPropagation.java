package bigproject.opt;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import bigproject.analysis.Block;
import bigproject.interm.*;
import bigproject.translate.Const;
import bigproject.translate.Temp;
import bigproject.translate.Translate;

public class CopyPropagation {

	public void work(Block block) {
		Map<Temp, Temp> tmap = new HashMap<Temp, Temp>();
		Map<Temp, Const> cmap = new HashMap<Temp, Const>();
		for (int i = 0; i < block.interms.size(); i++) {
			Interm interm = block.interms.get(i);
			Set<Temp> useset = interm.use();
			for (Temp t: useset) {
				if (tmap.containsKey(t))
					interm.replaceUseTemp(t, tmap.get(t));
				else if (cmap.containsKey(t)) {
					interm = replaceByConst(interm, t, cmap.get(t));
					block.interms.set(i, interm);
				}
			}
			if (interm instanceof Move) {
				tmap.put(((Move) interm).dest, ((Move) interm).source);
				cmap.remove(((Move) interm).dest);
			} else if (interm instanceof MoveI) {
				cmap.put(((MoveI) interm).dest, ((MoveI) interm).source);
				tmap.remove(((MoveI) interm).dest);
			} else {
				for (Temp t: interm.def())
					tmap.remove(t);
				for (Temp t: interm.def())
					cmap.remove(t);
			}
		}

	}

	private Interm replaceByConst(Interm interm, Temp oldt, Const newc) {
		if (interm instanceof BinOp) {
			BinOp binop = (BinOp) interm;
			if (binop.right.equals(oldt)) {
				BinOpI binopi = new BinOpI(
					binop.dest, binop.op, binop.left, newc
				);
				return replaceByConst(binopi, oldt, newc);
			}
			if (binop.left.equals(oldt) && Translate.isInvertable[binop.op]) {
				BinOpI binopi = new BinOpI(
					binop.dest, Translate.opInverted[binop.op],
					binop.right, newc
				);
				return binopi;
			}
			return interm;
		} else if (interm instanceof BinOpI) {
			BinOpI binopi = (BinOpI) interm;
			if (binopi.left.equals(oldt)) {
				MoveI movei = new MoveI(
					binopi.dest, new Const(
						calculate(binopi.op, newc.value, binopi.right.value)
					)
				);
				return movei;
			}
			return interm;
		} else if (interm instanceof Branch) {
			Branch branch = (Branch) interm;
			if ((branch.right instanceof Temp) &&
					((Temp) branch.right).equals(oldt)) {
				branch.right = newc;
				return branch;
			}
			return interm;
		} else if (interm instanceof IfFalse) {
			// TODO
			return interm;
		} else if (interm instanceof Move) {
			Move move = (Move) interm;
			if (move.source.equals(oldt)) {
				MoveI movei = new MoveI(move.dest, newc);
				return movei;
			}
			return interm;
		} else if (interm instanceof Return) {
			Return ret = (Return) interm;
			if ((ret.addr instanceof Temp) &&
					((Temp) ret.addr).equals(oldt)) {
				ret.addr = newc;
				return ret;
			}
			return interm;
		} else {
			return interm;
		}
	}
	
	// Copy from translate
	private int calculate(int op, int a1, int a2) {
		int ta2;
		if (a2 == 0)
			ta2 = 1;
		else
			ta2 = a2;
		int[] results = {
			0, toInt((a1>0) || (a2>0)), toInt((a1>0) && (a2>0)),
			a1 | a2, a1 ^ a2, a1 & a2, toInt(a1 == a2),
			toInt(a1 != a2), toInt(a1 < a2), toInt(a1 > a2),
			toInt(a1 <= a2), toInt(a1 >= a2), a1 << a2, a1 >> a2,
			a1 + a2, a1 - a2, a1 * a2, a1 / ta2, a1 % ta2
		};
		return results[op];
	}
	// Copy from translate
	private int toInt(boolean a) {
		if (a)
			return 1;
		else 
			return 0;
	}
	
}

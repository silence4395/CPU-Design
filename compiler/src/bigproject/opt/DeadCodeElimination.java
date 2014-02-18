package bigproject.opt;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import bigproject.ast.OpExp;
import bigproject.interm.*;
import bigproject.translate.CompUnit;
import bigproject.translate.Const;
import bigproject.translate.Temp;

public class DeadCodeElimination {

	public void work(CompUnit unit) {
		List<Interm> result = new ArrayList<Interm>();
		for (Interm interm: unit.interms) {
			if ((interm instanceof AssignAddress) ||
				(interm instanceof BinOp) ||
				(interm instanceof BinOpI) || 
				(interm instanceof Load) || 
				(interm instanceof Move) || 
				(interm instanceof MoveI) || 
				(interm instanceof MoveL)) {
				Set<Temp> set = new HashSet<Temp>(interm.def());
				Boolean flag = false;
				for (Temp temp: set)
					if (temp.level.depth == 0)
						flag = true;
				if (flag) {
					result.add(interm);
					continue;
				}
				set.retainAll(interm.OUT);
				if (set.size() != 0)
					result.add(interm);
			} else
				result.add(interm);
		}
		List<Interm> t = new ArrayList<Interm>(result);
		result = new ArrayList<Interm>();
		for (Interm interm: t) {
			if (interm instanceof BinOpI) {
				BinOpI binopi = (BinOpI) interm;
				if ((binopi.op == OpExp.Plus) && 
						(binopi.right.value == 0)) {
					result.add(new Move(binopi.dest, binopi.left));
				} else if ((binopi.op == OpExp.Mult) &&
						(binopi.right.value == 1)) {
					result.add(new Move(binopi.dest, binopi.left));
				} else if ((binopi.op == OpExp.Mult) &&
						(binopi.right.value == 0)) {
					result.add(new MoveI(binopi.dest, new Const(0)));
				} else if ((binopi.op == OpExp.Div) &&
						(binopi.right.value == 1)) {
					result.add(new Move(binopi.dest, binopi.left));
				} else if ((binopi.op == OpExp.Minus) &&
						(binopi.right.value == 0)) {
					result.add(new Move(binopi.dest, binopi.left));
				} else {
					result.add(interm);
				}
			} else if (interm instanceof Move) {
				Move move = (Move) interm;
				if (!move.dest.equals(move.source))
					result.add(interm);
			} else
				result.add(interm);
		}
		unit.setInterms(result);
	}
}

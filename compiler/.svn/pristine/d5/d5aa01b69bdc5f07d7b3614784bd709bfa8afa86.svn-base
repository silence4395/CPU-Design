package bigproject.analysis;

import bigproject.main.RegConst;
import bigproject.translate.Temp;

public class LiveInterval implements Comparable<LiveInterval> {

	public Temp temp = null;
	public int startpoint = 0;
	public int endpoint = 0;
	public int register = RegConst.SpillReg;
	public boolean spilled = true;

	public LiveInterval(Temp temp, int pos) {
		this(temp, pos, pos);
	}

	public LiveInterval(Temp a, int b, int c) {
		temp = a;
		startpoint = b;
		endpoint = c;
		register = RegConst.SpillReg;
		spilled = true;
	}
	
	public void expand(int point) {
		if (startpoint > point)
			startpoint = point;
		if (endpoint < point)
			endpoint = point;
	}
	
	@Override
	public int compareTo(LiveInterval other) {
		return startpoint - other.startpoint;
	}

}

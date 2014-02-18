package bigproject.regalloc;

import bigproject.analysis.LiveInterval;
import bigproject.main.RegConst;
import bigproject.translate.Temp;

public class DefaultMap extends RegAlloc {

	@Override
	public String map(Temp t) {
		LiveInterval i = t.getLiveInterval();
		return "$" + RegConst.RegNames[i.register];
	}
	
	private static DefaultMap singleton = null;

	public static DefaultMap getSingleton() {
		if (singleton == null) {
			singleton = new DefaultMap();
		}
		return singleton;
	}

}

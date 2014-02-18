package bigproject.translate;

import bigproject.symbol.Symbol;

public class Label extends Addr {
	
	public static int Count = 0;
	public String name = "";
	public boolean forfun = false;
	
	public Label() {
		this("L" + (++Count));
	}

	public Label(String a) {
		name = a;
	}
	
	public static Label forFun(Symbol name) {
		Label l = new Label();
		if (name.name.equals("main"))
			l.name = "cmain";
		else if ((name.name.equals("printf")) ||
				 (name.name.equals("malloc")) ||
				 (name.name.equals("scanf")))
			l.name = name.name;
		else
			l.name += "_" + name.name;
		l.forfun = true;
		return l;
	}
	
	public String toString() {
		return name;
	}
	
}
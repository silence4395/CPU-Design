package bigproject.ast;

import java.util.List;

public class Program extends Ast {
	
	public List<DeclStat> body = null;
	
	public Program(List<DeclStat> a) {
		body = a;
	}
	
}

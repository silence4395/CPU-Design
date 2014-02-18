package bigproject.ast;

import java.util.List;

public class InitDeclors extends Ast{

	public List<InitDeclor> decls = null;
	
	public InitDeclors(List<InitDeclor> a) {
		decls = a;
	}
	
}

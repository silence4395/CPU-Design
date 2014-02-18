package bigproject.env;

import bigproject.symbol.*;
import bigproject.translate.Label;
import bigproject.translate.Level;
import bigproject.types.Function;
import bigproject.types.Pointer;
import bigproject.types.Record;
import bigproject.types.Type;

public class Env {

	public Table typeenv = null;
	public Table varenv = null;
	
	public Env() {
		initTypeEnv();
		initVarEnv();
	}

	private void initVarEnv() {
		varenv = new Table();
		Level level = new Level();
		
		Record temprec = new Record(Symbol.symbol("s"), new Pointer(Type.Char));
		temprec.addField(Symbol.symbol("..."), Type.Nil);
		varenv.put(Symbol.symbol("scanf"), 
				   new FunEntry(new Function(temprec, Type.Void),
						   		Label.forFun(Symbol.symbol("scanf")),
						   		level));
		temprec = new Record(Symbol.symbol("s"), new Pointer(Type.Char));
		temprec.addField(Symbol.symbol("..."), Type.Nil);
		varenv.put(Symbol.symbol("printf"), 
				   new FunEntry(new Function(temprec, Type.Void),
						   		Label.forFun(Symbol.symbol("printf")),
						   		level));
		temprec = new Record(Symbol.symbol("bytes"), Type.Int);
		varenv.put(Symbol.symbol("malloc"),
				   new FunEntry(new Function(temprec, new Pointer(Type.Void)),
						   		Label.forFun(Symbol.symbol("malloc")),
						   		level));
		
	}

	private void initTypeEnv() {
		typeenv = new Table();
		typeenv.put(Symbol.symbol("int"), Type.Int);
		typeenv.put(Symbol.symbol("Char"), Type.Char);
		typeenv.put(Symbol.symbol("void"), Type.Void);	
	}
	
	public void beginScope() {
		typeenv.beginScope();
		varenv.beginScope();
	}
	
	public void endScope() {
		typeenv.endScope();
		varenv.endScope();
	}
}

package bigproject.translate;

import org.antlr.v4.runtime.ANTLRFileStream;
import org.antlr.v4.runtime.BaseErrorListener;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;

import bigproject.ast.Program;
import bigproject.interm.Interm;
import bigproject.semant.Semant;
import bigproject.semant.SementText;
import bigproject.syntactic.CTXLexer;
import bigproject.syntactic.CTXParser;

public class TranslateTest {
	
	public static class MyListener extends BaseErrorListener {
		@Override
		public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol,
								int line, int charPositionInLine, String msg, RecognitionException e)
		{
			System.out.println('1');
			System.exit(1);
		}
	}
	
	public static String pathOf(String filename) {
		return SementText.class.getResource(filename).getPath();
	}

	public static void main(String argv[]) throws Exception {
		
		String filename = "input.c";
	//	String filename = argv[0];
		ANTLRFileStream file1 = new ANTLRFileStream(filename);

		CTXLexer lexer = new CTXLexer(file1);
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		CTXParser parser = new CTXParser(tokens);
		tokens.fill();
		parser.removeErrorListeners();
		parser.addErrorListener(new MyListener());

		Program tree = (Program) parser.program().v;

		Semant semant = new Semant();
		semant.checkProgram(tree);
		
		if (!semant.hasError())
			System.out.println('0');
		else {
			System.out.println('1');
			System.exit(1);
		}

		Translate trans = new Translate();
		trans.transProg(tree);
		for (Interm code: trans.intermlist) {
			System.out.println(code.toString());
		}
		for (CompUnit unit: trans.units)
			for (Interm code: unit.interms)
				System.out.println(code.toString());
		
	}
	
}

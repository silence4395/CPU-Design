package bigproject.main;

import java.io.BufferedInputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import org.antlr.v4.runtime.*;

import bigproject.analysis.Analyzer;
import bigproject.analysis.Block;
import bigproject.assem.Assem;
import bigproject.assem.Codegen;
import bigproject.ast.Program;
import bigproject.interm.Interm;
import bigproject.opt.*;
import bigproject.regalloc.*;
import bigproject.semant.Semant;
import bigproject.syntactic.CTXLexer;
import bigproject.syntactic.CTXParser;
import bigproject.translate.*;

public class RealMain {

	public static class MyListener extends BaseErrorListener {
		@Override
		public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol,
								int line, int charPositionInLine, String msg, RecognitionException e)
		{
			System.out.println('1');
			System.exit(1);
		}
	}

	public static void main(String argv[]) throws Exception {
		
	//	String filename = "input.c";
		String filename = argv[0];
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
		
		if (!semant.hasError()) {
		//	System.out.println('0');
		} else {
		//	System.out.println('1');
			System.exit(1);
		}

		// opt

		Boolean changeflag;
		AstReduce astreduce = new AstReduce();
		ConstantInline cstinline = new ConstantInline();
		LoopUnrolling loopunroll = new LoopUnrolling();
		do {
			changeflag = false;
			cstinline.findVarDec(tree);
			cstinline.check(tree);
			tree = cstinline.rewrite(tree);
			changeflag = cstinline.isRewrited();
			tree = astreduce.work(tree);
			loopunroll.check(tree);
			loopunroll.rewrite(tree);
			if (!changeflag)
				changeflag = loopunroll.isRewrited();
		} while (changeflag);

		// opt end
		
		semant = new Semant();
		semant.checkProgram(tree);

		Translate trans = new Translate();
		trans.transProg(tree);
		List<CompUnit> units = trans.units;
		List<Interm> globalvars = trans.intermlist;
		
		CompUnit mainunit = new CompUnit(globalvars, new Label("main"), new Level());
		trans.units.add(0, mainunit);

		for (CompUnit unit: trans.units)
			if (!unit.label.name.equals("main")) {
				Analyzer analyzer = new Analyzer();
				analyzer.lableEliminate(unit);
				analyzer.findBranch(unit);
				analyzer.findBlocks(unit);
				analyzer.findLiveness(unit);
			}
		
		// opt
		
		for (CompUnit unit: trans.units) 
			if (!unit.label.name.equals("main")) {
				List<Interm> oldinterms = null;
				do {
					oldinterms = new ArrayList<Interm>(unit.interms);
					for (Block block: unit.blocks)
						new CopyPropagation().work(block);
					Analyzer analyzer = new Analyzer();
					analyzer.findLiveness(unit);
					new DeadCodeElimination().work(unit);
					analyzer.findBlocks(unit);
					analyzer.findLiveness(unit);				
				} while (!unit.interms.equals(oldinterms));
			}
		
		// opt end
		
		for (CompUnit unit: trans.units) {
			new Analyzer().findLiveIntervals(unit);
		}
		
		Codegen code = new Codegen();
		code.gen(new Assem(".data"));
		code.gen(new Assem(".align 2"));
		for (DataFrag dataFrag : trans.frags) {
			code.gen(dataFrag.gen());
		}

		code.gen(new Assem(".text"));
		code.gen(new Assem(".align 2"));
		code.gen(new Assem(".globl main"));

		for (CompUnit unit: units) 
			if (unit.label.name.equals("main")) {
				code.gen(new Assem("!main:"));
				code.gen(unit, DefaultMap.getSingleton());
				code.lines.add("\tjal cmain");
			} else {
				//code.gen(unit, DefaultMap.getSingleton());
				code.gen(unit, new LinearScan(unit));
			}

		code.printToScreen();
		
		Scanner scanner = new Scanner(new BufferedInputStream(Main.class.getResourceAsStream("runtime.s")));
		while (scanner.hasNextLine()) {
			System.out.println(scanner.nextLine());
		}
		scanner.close();
		
	}

	
}

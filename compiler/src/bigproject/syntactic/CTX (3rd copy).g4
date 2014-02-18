grammar CTX;

@header {
package bigproject.syntactic;
import bigproject.ast.*;
import bigproject.symbol.*;
import static bigproject.symbol.Symbol.symbol;
}

program returns [Program v]
		: {List<DeclStat> list = new ArrayList<DeclStat>();}
		  (a=declaration {list.add($a.v);} | b=function_definition {list.add($b.v);})+
		  {$v = new Program(list);}
		;

declaration returns [DeclStat v]
		: 'typedef' a=type_specifier b=declarators ';'
		  {$v = new TypeDecl($a.v, $b.v);}
		| {InitDeclors init = null;} a=type_specifier
		  (c=init_declarators {init = $c.v;})? ';'
		  {$v = new VarDecl($a.v, init);}
		;

function_definition returns [FunDecl v]
		: {Params para = null;} a=type_specifier b=plain_declarator 
		  '(' (d=parameters {para = $d.v;})? ')' c=compound_statement
		  {$v = new FunDecl($a.v, $b.v, para, $c.v);}
		;

parameters returns [Params v]
		: {boolean other = false; List<PlanDecl> list = new ArrayList<PlanDecl>();} 
		  a=plain_declaration {list.add($a.v);}
		  (',' b=plain_declaration {list.add($b.v);})* (',' '...' {other = true;})?
		  {$v = new Params(list, other);}
		;

declarators returns [Declors v]
		: {List<Declor> list = new ArrayList<Declor>();}
		  a=declarator {list.add($a.v);}
		  (',' b=declarator {list.add($b.v);})*
		  {$v = new Declors(list);}
		;

init_declarators returns [InitDeclors v]
		: {List<InitDeclor> list = new ArrayList<InitDeclor>();}
		  a=init_declarator {list.add($a.v);}
		  (',' b=init_declarator {list.add($b.v);})*
		  {$v = new InitDeclors(list);}
		;

init_declarator returns [InitDeclor v]
		: {Initer init = null;} a=declarator 
		  ('=' b=initializer {init = $b.v;})?
		  {$v = new InitDeclor($a.v, init);}
		;

initializer returns [Initer v]
		: a=assignment_expression {$v = new Initer($a.v);}
		| '{' b=initializers {$v = new Initer($b.v);} '}'
		;

initializers returns [Initers v]
		: {List<Initer> list = new ArrayList<Initer>();} 
		  a=initializer {list.add($a.v);}
		  (',' b=initializer {list.add($b.v);})*
		  {$v = new Initers(list);}
		;

type_specifier returns [Ty v]
		: 'void' {$v = new VoidTy();}
		| 'char' {$v = new CharTy();}
		| 'int' {$v = new IntTy();}
		| a=typedef_name {$v = new NameTy(symbol($a.v));}
		| {Symbol sym = null; List<Ty> list1 = new ArrayList<Ty>(); List<Declors> list2 = new ArrayList<Declors>();}
		  b=struct_or_union (e=identifier {sym = symbol($e.v);})? 
		  '{' (c=type_specifier {list1.add($c.v);} d=declarators {list2.add($d.v);} ';')+ '}'
		  {$v = new RecordTy(sym, $b.v, list1, list2);}
		| b=struct_or_union e=identifier {$v = new RecordTy(symbol($e.v), $b.v);}
		;

struct_or_union returns [int v]
		: 'struct' {$v = 0;}
		| 'union' {$v = 1;}
		;

plain_declaration returns [PlanDecl v]
		: a=type_specifier b=declarator {$v = new PlanDecl($a.v, $b.v);}
		;

declarator returns [Declor v]
		: {Params para = null;} a=plain_declarator
		  '(' (b=parameters {para = $b.v;})? ')'
		  {$v = new FunDeclor($a.v, para);}
		| {List<Exp> list = new ArrayList<Exp>();}
		  a=plain_declarator ('[' c=con_expr ']' {list.add($c.v);} )*
		  {$v = new ArrayDeclor($a.v, list);}
		;

plain_declarator returns [PlanDeclor v]
		: {int stars = 0;} ('*' {stars = stars + 1;})* 
		  a=identifier {$v = new PlanDeclor(symbol($a.v), stars);}
		;

statement returns [Stat v]
		: expression_statement {$v = $expression_statement.v;}
		| compound_statement {$v = $compound_statement.v;}
		| selection_statement {$v = $selection_statement.v;}
		| while_statement {$v = $while_statement.v;}
		| for_statement {$v = $for_statement.v;}
		| jump_statement {$v = $jump_statement.v;}
		;

expression_statement returns [ExpStat v]
		: {ExpStat exp = null;} (a=expression {exp = new ExpStat($a.v);})?
		  ';' {$v = exp;} 
		;

compound_statement returns [CompStat v]
		: {List<DeclStat> list1 = new ArrayList<DeclStat>(); List<Stat> list2 = new ArrayList<Stat>();}
		  '{' (a=declaration {list1.add($a.v);})*
		  (b=statement {list2.add($b.v);})* '}'
		  {$v = new CompStat(list1, list2);}
		;

selection_statement returns [SelectStat v]
		: {Stat elsestat = null;} 'if' '(' a=expression ')' b=statement
		  ('else' c=statement {elsestat = $c.v;})?
		  {$v = new SelectStat($a.v, $b.v, elsestat);}
		;

while_statement returns [WhileStat v]
		: 'while' '(' a=expression ')' b=statement
		  {$v = new WhileStat($a.v, $b.v);}
		;
		
for_statement returns [ForStat v]
		: {$v = new ForStat();} 'for' '('
		  (a=expression {$v.setFirstCond($a.v);})? ';'
		  (b=expression {$v.setSecondCond($b.v);})? ';'
		  (c=expression {$v.setThirdCond($c.v);})? ')'
		  d=statement {$v.setBody($d.v);}
		;

jump_statement returns [JumpStat v]
		: 'continue' ';' {$v = new ContinueStat();}
		| 'break' ';' {$v = new BreakStat();}
		| {Exp result = null;} 'return' 
		  (a=expression {result = $a.v;})? ';' {$v = new ReturnStat(result);}
		;

expression returns [Exp v]
		: {List<Exp> list = new ArrayList<Exp>();} 
		  a=assignment_expression {list.add($a.v);}
		  (',' b=assignment_expression {list.add($b.v);})*
		  {$v = new CommaExp(list);}
		;

assignment_expression returns [Exp v]
		: a=con_expr {$v = $a.v;}
		| b=unary_expression c=assignment_operator d=assignment_expression
		  {$v = new AssignExp($b.v, $c.v, $d.v);}
		;

assignment_operator returns [int v]
		: '=' {$v = AssignExp.Assign;}
		| '*=' {$v = AssignExp.MultAssign;}
		| '/=' {$v = AssignExp.DivAssign;}
		| '%=' {$v = AssignExp.ModAssign;}
		| '+=' {$v = AssignExp.PlusAssign;} 
		| '-=' {$v = AssignExp.MinusAssign;}
		| '<<=' {$v = AssignExp.ShlAssign;}
		| '>>=' {$v = AssignExp.ShrAssign;}
		| '&=' {$v = AssignExp.AndAssign;}
		| '^=' {$v = AssignExp.XorAssign;}
		| '|=' {$v = AssignExp.OrAssign;}
		;

con_expr returns [Exp v]
        : a=cast_expression {$v = $a.v;}
		| a=con_expr ('*' {int op = BinOpExp.Mult;}
		             |'/' {int op = BinOpExp.Div;}
		             |'%' {int op = BinOpExp.Mod;}) b=con_expr 
		  {$v = BinOpExp($a.v, op, $b.v);}
		| a=con_expr '&' b=con_expr 
		  {$v = BinOpExp($a.v, BinOpExp.And, $b.v);}
		| a=con_expr '^' b=con_expr 
		  {$v = BinOpExp($a.v, BinOpExp.Xor, $b.v);}
		| a=con_expr '|' b=con_expr 
		  {$v = BinOpExp($a.v, BinOpExp.Or, $b.v);}
		| a=con_expr '&&' b=con_expr 
		  {$v = BinOpExp($a.v, BinOpExp.LogicalAnd, $b.v);}
		| a=con_expr '||' b=con_expr 
		  {$v = BinOpExp($a.v, BinOpExp.LogicalOr, $b.v);}
		;
		
cast_expression returns [Exp v]
		: a=unary_expression {$v = $a.v;}
		| '(' b=type_name ')' c=cast_expression
		  {$v = new CoerceExp($b.v, $b.u, $c.v);}
		;
		
type_name returns [Ty v, int u]
		: a=type_specifier {$v = $a.v; $u = 0;} ('*' {$u = $u + 1;})* 
		;

unary_expression returns [Exp v]
		: a=postfix_expression {$v = $a.v;}
		| '++' b=unary_expression {$v = new SingleOpExp($b.v, SingleOpExp.DuPlus);}
		| '--' b=unary_expression {$v = new SingleOpExp($b.v, SingleOpExp.DuMinus);}
		| d=unary_operator e=cast_expression
		  {$v = new SingleOpExp($e.v, $d.v);}
		| 'sizeof' b=unary_expression {$v = new SizeofExp($b.v);}
		| 'sizeof' '(' c=type_name ')' {$v = new SizeofExp($c.v, $c.u);}
		;

unary_operator returns [int v]
		: '&' {$v = 2;}
		| '*' {$v = 3;}
		| '+' {$v = 4;}
		| '-' {$v = 5;}
		| '~' {$v = 6;}
		| '!' {$v = 7;}
		;

postfix_expression returns [Exp v]
		: {List<Postfix> list = new ArrayList<Postfix>();}
		  a=primary_expression (b=postfix {list.add($b.v);})*
		  {$v = new PostfixExp($a.v, list);}
		;

postfix returns [Postfix v]
		: '[' a=expression ']' {$v = new ArrayFix($a.v);}
		| '(' ')' {$v = new FunFix();}
		| '(' b=arguments ')' {$v = new FunFix($b.v);}
		| '.' c=identifier {$v = new FieldFix(symbol($c.v));}
		| '->' c=identifier {$v = new BelongFix(symbol($c.v));}
		| '++' {$v = new DuPlusFix();}
		| '--' {$v = new DuMinusFix();}
		;

arguments returns [Arguments v]
		: {List<Exp> list = new ArrayList<Exp>();}
		  a=assignment_expression {list.add($a.v);} 
		  (',' b=assignment_expression {list.add($b.v);})*
		  {$v = new Arguments(list);}
		;

primary_expression returns [Exp v]
		: a=identifier {$v = new VarExp(symbol($a.v));}
		| b=constant {$v = $b.v;}
		| c=string {$v = new StringExp($c.v);}
		| '(' d=expression ')' {$v = $d.v;}
		;

constant returns [Exp v]
		: a=integer_constant {$v = new IntExp($a.v);}
		| b=character_constant {$v = new CharExp($b.v);}
		;

//Lexer

typedef_name returns [String v]
		: a=IDENTIFIER {$v = $a.text;}
		;

identifier returns [String v]
		: a=IDENTIFIER {$v = $a.text;}
		;

string returns [String v]
		: a=STRING {$v = $a.text;}
		;

integer_constant returns [int v]
		: a=INTEGER {$v = $a.int;}
		;

character_constant returns [char v]
		: a=CHAR {$v = ($a.text).charAt(0);}
		;

INTEGER: DECINTEGER
       | HEXINTEGER
       | OCTINTEGER
       ;

CHAR: '\'' ('\\'('t'|'n'|'r'|'\''|'\"'|'\\') | ~('\''|'\\')) '\''
    ;

DECINTEGER: '0' | [1-9] [0-9]*
          ;

HEXINTEGER: '0' ('x'|'X') [0-9a-fA-F]*
          ;

OCTINTEGER: '0' [0-7]+
          ;

STRING: '"' ('\\'('t'|'n'|'r'|'\''|'\"'|'\\') | ~('\\'|'"'))* '"'
      ;

IDENTIFIER: [a-zA-Z_] [0-9a-zA-Z_]*
          ;

WS: [ \r\t\n]+ -> skip
  ;

COMMENTS: '/*' .*? '*/' -> skip
        ;

LINE_COMMENT: '//' ~[\r\n]* ('\r'? '\n' | EOF) -> skip
            ;

INCLUDE_COMMENT: '#include' ~[\r\n]* ('\r'? '\n' | EOF) -> skip
			   ;            
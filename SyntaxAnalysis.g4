grammar SyntaxAnalysis;
//PARSER PART
prog:               (func | eventHand)* EOF
                    ;

func:               'function' ftype ID '(' fparam ')' block 'endFunction'      #function
                    ;

eventHand:          'when' ID '(' fparam ')' block 'endWhen'                    #when
                    ;

block:              stmt*                                                       #blk
                    ;

stmt:               'if' '(' expression ')' 'do' block ('else if' '(' expression ')' 'do' block)* ('else do' block)? 'endIf'    #if
				    | 'repeat' '(' (DIGITS | ID) ')' block 'endRepeat'                                                          #rep
				    | 'repeatIf' '(' expression ')' block 'endRepeatIf'                                                         #rep_if
				    | 'repeat' block 'until' '(' expression ')'                                                                 #rep_until
                    | func_Call '.'                                                                                             #func_stmt
				    | type ID '=' (expression | incr_Stmt | decr_Stmt) '.'                                                      #var_decl
				    | ID '=' (expression | incr_Stmt | decr_Stmt) '.'                                                           #assign
				    | incr_Stmt '.'                                                                                             #incr
				    | decr_Stmt '.'                                                                                             #decr
				    | return_Stmt '.'                                                                                           #ret
				    ;

incr_Stmt:          '++' ID         #pre_incr
                    | ID '++'       #post_incr
                    ;

decr_Stmt:          '--' ID         #pre_decr
                    | ID '--'       #post_decr
                    ;

return_Stmt:        'return' expression                                             #returnStmt
                    ;

expression:         primary                                                         #prim
                    | func_Call                                                     #func_expr
                    | '!' expression                                                #not
                    | expression bop=('*'|'/'|'%') expression                       #mul_div_mod
                    | expression bop=('+'|'-') expression                           #add_sub
                    | expression bop=('<=' | '>=' | '<' | '>') expression           #le_ge_lt_gt
                    | expression bop=('==' | '!=') expression                       #equal_notequal
                    | expression bop='&&' expression                                #logical_and
                    | expression bop='||' expression                                #logical_or
                    | <assoc=right> expression bop='?' expression ':' expression    #tertiary
                    ;

primary:            '(' expression ')'      #parens
                    | DIGITS                #digits
                    | ID                    #id
                    | BOOL                  #bool
                    ;

func_Call:          ID '(' param ')' '.'                                            #funcCall
                    ;

fparam:             (type ID (',' type ID)*)?                                       #fparameters
                    ;

param:              (expression (',' expression)*)?                                 #parameters
                    ;

ftype:              'void'                                                          #void_ftype
                    | type                                                          #type_ftype
                    ;

type:               'num'                                                           #num_type
                    | 'bool'                                                        #bool_type
                    ;

//LEXICAL PART
BOOL:               'true' | 'false';
ID:                 LETTER (LETTERORDIGIT | '_')*;
DIGITS:             DIGIT DIGITS
		            | DIGIT;
DIGIT:              '0'..'9';
LETTER:             'a'..'z'
                    | 'A'..'Z';
LETTERORDIGIT:      LETTER
                    | DIGIT;

MUL:                '*';
DIV:                '/';
ADD:                '+';
SUB:                '-';
MOD:                '%';
GE:                 '>=';
LE:                 '<=';
GT:                 '>';
LT:                 '<';
EQUALS:             '==';
NOTEQUALS:          '!=';
AND:                '&&';
OR:                 '||';
QMARK:              '?';
COLON:              ':';

WS:                 [ \t\r\n]       -> skip;
LINE_COMMENT:       '//' ~[\r\n]*   -> skip;
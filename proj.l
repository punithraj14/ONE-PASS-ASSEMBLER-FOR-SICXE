%{
#include "y.tab.h"
char hex[5];
int locctr;
int i = 0;
%}
END ("END")
ZERO_ARG ("RET"|"AAA"|"AAD"|"AAM"|"AAS"|"CLC"|"CLD"|"CLI"|"CMC"|"CWD"|"DAA"|"CBW"|"CMPSB"|"CMPSW"|"DAS"|"HLT"|"XLAT")
ONE_ARG ("PUSH"|"MUL"|"POP"|"DIV"|"IDIV"|"IMUL"|"INC"|"DEC"|"CALL"|"INT"|"JAE"|"JMP"|"INT")
TWO_ARG ("MOV"|"ADC"|"AND"|"ADD"|"CMP"|"IN"|"SUB")
Reg8 ("AL"|"AH"|"BL"|"BH"|"CL"|"CH"|"DL"|"DH")
Reg16 ("AX"|"BX"|"CX"|"DX"|"SP"|"BP"|"SI"|"DI")
MM ("[BX+SI]"|"[BX+DI]"|"[BP+SI]"|"[BP+DI]"|"[SI]"|"[DI]"|"[BP]")
Hex16 [0-9a-fA-F]{4}"H"
Hex8 [0-9a-fA-F]{2}"H"
Name ([a-zA-Z])([a-z|A-Z|0-9])+
String ['"'][a-z|A-Z|0-9|,|"."|;|:|/|-|+|*|?|!|*|"("	|")"|_|=|"$"| ]+['"']
Spaces [ \t]*
TEXT (".CODE"|".MODEL SMALL"|"END"|".DATA"|".MODEL TINY")

%%
{END} {return END;}
{ZERO_ARG} { strcpy(yylval.str, yytext); return OP_ZERO; }
{ONE_ARG} { strcpy(yylval.str, yytext); return OP_ONE; }
{TWO_ARG} { strcpy(yylval.str, yytext); return OP_TWO; }
"DW"	{return DW;}
"DB"	{return DB;}
{Hex16} {strcpy(yylval.str,yytext);return WCONST;}

{Hex8}  {strcpy(yylval.str,yytext);return BCONST;}

{MM}    {
	 strcpy(yylval.str, yytext);
	 return MEMORY;}
{Reg8}  {strcpy(yylval.str, yytext);
         return REG8;}
{Reg16} { strcpy(yylval.str, yytext);
	 return REG16;}
{Name}  {strcpy(yylval.str,yytext);return LABEL;}
{String} {strcpy(yylval.str,yytext);return STR;}
\n      {return NL;}
{Spaces} {}
{TEXT} ;

.	{return yytext[0];}
%%
int yywrap()
{return 1;}


%{
     #include <bits/stdc++.h>
     #include "main.tab.h"
     using namespace std;
     void out(string s){
          //cout<<s;
     }
%}
%option noyywrap

Print_N print-num
Print_B print-bool
And and
Or or
Not not
Def define
Fun fun
If if
MOD mod
num (0)|([1-9][0-9]*)|([-][1-9][0-9]*)
ID [a-z]([a-z]|[0-9]|[\-])*
bool_val #t|#f

%%
{Print_N} {return Print_N;}
{Print_B} {return Print_B;}
{And} {return And;}
{Or} {return Or;}
{Not}  {return Not;}
{Def} {return Def;}
{Fun}  {out("F"); return Fun;}
{If} {return If;}
{MOD} {return MOD;}
{num} {Var x = new Var(1);yylval.var = new Var(1);yylval.var->ival = atoi(yytext);return num;}
{ID} {string s = yytext; yylval.var = new Var(s); return ID;}
{bool_val} {
     yylval.var = new Var(false);
     if(yytext[1]=='t'){yylval.var->bval = true;}
     return bool_val;
}
[\t\r\n ] {}
.			{ out(yytext);return yytext[0];}
%%


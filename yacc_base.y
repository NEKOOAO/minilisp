%code requires{

#include <bits/stdc++.h>
using namespace std;
    struct Var{
        int type;
        string s;
        int ival;
        bool bval=1;
        Var(int _ival){type = 0; ival = _ival;}
        Var(bool _bval){type = 1; bval = _bval;}
        Var(string _s){type = 2; s = _s;}
        Var(){};
    };
    void add_sym(string s , int type , int val);
    Var* get_sym(string s);
}
%{
void yyerror(const char *message);
extern int yylex(); 

%}
%union{
    Var* var;
}
%token Print_N Print_B And Or Not Def Fun If MOD 
%token<var> num bool_val ID
%type<var> EXP Plus_EXP Mul_EXP NUM_OP BOOL_OP AND_EXP OR_EXP IF_EXP EQU_EXP


%%
program     : program stmt | stmt
            ;
stmt        : EXP | Print_stmt | Def_stmt
            ;
Print_stmt  : '(' Print_N EXP ')'{cout<<$3->ival<<'\n';}
            | '(' Print_B EXP ')'{cout<<($3->bval?"#t":"#f")<<'\n';}
            ;
EXP         : num{$$ = $1;} | '(' NUM_OP ')' {$$ = $2;} | '(' BOOL_OP ')'{$$ = $2;} | bool_val{$$ = $1;} | ID {$$ = get_sym($1->s);} | IF_EXP{$$ = $1;}
            ;
NUM_OP      :  '+' EXP Plus_EXP  {$$ =new Var( $2->ival+$3->ival);} 
            | '-' EXP EXP {$$ =new Var( $2->ival-$3->ival);} 
            | '*' EXP Mul_EXP {$$ =new Var( $2->ival*$3->ival);} 
            | '/' EXP EXP {$$ =new Var( $2->ival/$3->ival);} 
            | MOD EXP EXP {$$ =new Var( $2->ival%$3->ival);}
            | '>' EXP EXP {$$ =new Var((bool) $2->ival>$3->ival);}
            | '<' EXP EXP {$$ =new Var((bool) $2->ival<$3->ival);}
            | '=' EXP EQU_EXP {$$ = new Var((bool)$2->ival==$3->ival);if(!$3->bval){$$->bval = false;}}
            ;
EQU_EXP     : EQU_EXP EXP {
    $$ =new Var( $1->ival);
    if(!$2->bval or $1->ival!=$2->ival)$$->bval = false;
    else $$->bval = 1;
} 
            | EXP{$$ = $1; }
            ;
Plus_EXP    : Plus_EXP EXP {$$ =new Var( $1->ival+$2->ival);} | EXP {$$ = $1;}
            ;
Mul_EXP     : Mul_EXP EXP {$$ =new Var( $1->ival*$2->ival);} | EXP {$$ = $1;}
            ;    
BOOL_OP     : And EXP AND_EXP {$$ =new Var( $2->bval and $3->bval);} | Or EXP OR_EXP {$$ =new Var( $2->bval or $3->bval);} | Not EXP {$$ =new Var( ! $2->bval);}
            ;
AND_EXP     : AND_EXP EXP {$$ =new Var( $1->bval and $2->bval);}
            | EXP {$$ = $1;}
            ;
OR_EXP      : OR_EXP EXP {$$ =new Var( $1->bval or $2->bval);}
            | EXP {$$ = $1;}
            ;
Def_stmt    : '(' Def ID EXP ')'{
    if($4->type == 0){
        add_sym($3->s,$4->type,$4->ival);
    }
    else{
        add_sym($3->s,$4->type,$4->bval);    
    }
}
            ;
IF_EXP      : '(' If EXP EXP EXP ')'{
            if($3->bval){
                $$ = $4;
            }
            else{
                $$ = $5;
            }
}
            ;
%%
    map<string,int> id_table;
    Var val_table[100];
    priority_queue<int> can_use_seq;
    int max_symbol = 100;
    bool re = 0;
void add_sym(string s , int type , int val){
    if(can_use_seq.size()==0){
        
    }
    if(id_table[s]){
        re =true;
        return;
    }
    int id = can_use_seq.top();
    id_table[s] = id;
    can_use_seq.pop();
    if(type == 0){
        val_table[id] = Var(val);
    }
    else{
        val_table[id] = Var((bool)val);
    }
}
Var* get_sym(string s){
    if(id_table[s]==0){
        re = true;
        return new Var();
    }
    return &val_table[id_table[s]];
}
void yyerror (const char *message)
{
	cout<<message<<'\n';
}
int main()
{
    for(int i = 1 ;i<max_symbol;i++)can_use_seq.push(i);
	yyparse();
	return 0;
}

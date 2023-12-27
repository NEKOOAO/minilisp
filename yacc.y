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
    struct Vec{
        vector<string> vec;
        vector<Var> Vvec;
    };
    void add_sym(string s , int type , int val);
    Var* get_sym(string s);
    struct Fun_oper{
        int tmp;
        string type;
        Var var;
        Fun_oper(Var _var){var = _var;type = "var";}
        Fun_oper(int x){type = "sub";}
    };
    struct Funtion{
        vector<Fun_oper> body;
        vector<string> pram;
        map<string,Var> sym;
        stack<Var> sys_stack;
        void add(Fun_oper _oper){
            body.emplace_back(_oper);
        }
        void pram_init(vector<string> s){
            pram = s;
        }
        void pram_set(vector<Var> s){
            if(s.size()!=pram.size()){
                return;
            }
            for(int i = 0,len = s.size();i<len;i++){
                sym[pram[i]] = s[i];
            }
        }
        Var* result(vector<Var>_pram){
            pram_set(_pram);
            cout<<body.size()<<'\n';
            for(int i = 0,len = body.size();i<len;i++){
                if(body[i].type == "var"){
                    sys_stack.push(body[i].var);
                    if(body[i].var.type == 0){
                        cout<<body[i].var.ival<<" var\n";
                    }
                    else{
                        cout<<body[i].var.s<<" "<<sym[body[i].var.s].ival<<'\n';
                    }
                }
                else if(body[i].type == "sub"){
                    cout<<"sub\n";
                    sub();

                }
            }
            return &sys_stack.top();
        }
        Var top(){
            Var x = sys_stack.top();
            sys_stack.pop();
            if(x.type == 2){
                x = sym[x.s];
            }
            return x;
        }
        private : void sub(){
            Var a,b;
            a = top();b = top();
            a.ival -= b.ival;
            sys_stack.push(a); 
        }

    };
    Var* init (Var* x);Var* result(vector<Var> vec);
    Var* Sub(Var* l,Var* r);
    void bind(int id,vector<string> vec);
  
}
%{
void yyerror(const char *message);
extern int yylex(); 
int infunc,func_id=0;

%}
%union{
    Var* var;
    Vec* vec;
}
%token Print_N Print_B And Or Not Def Fun If MOD 
%token<var> num bool_val ID
%type<var> EXP Plus_EXP Mul_EXP NUM_OP BOOL_OP AND_EXP OR_EXP IF_EXP EQU_EXP Fun_CALL
%type<vec> prams_def prams
%%
program     : program stmt | stmt
            ;
stmt        : EXP | Print_stmt | Def_stmt
            ;
Print_stmt  : '(' Print_N EXP ')'{cout<<$3->ival<<'\n';}
            | '(' Print_B EXP ')'{cout<<($3->bval?"#t":"#f")<<'\n';}
            ;
EXP         : num{$$ = init($1);} | '(' NUM_OP ')' {$$ = $2;} | '(' BOOL_OP ')'{$$ = $2;} | bool_val{$$ = init($1);} | ID {$$ = init($1);} | IF_EXP{$$ = $1;}
            | Fun_CALL 
            ;
Fun_CALL    : '('FUN_EXP prams')'{cout<<"CALL"<<$3->Vvec[0].ival<<'\n';$$ = result($3->Vvec);}
            ;
prams       : prams EXP{$$ = $1;$$->Vvec.emplace_back($2);} | EXP{$$ = new Vec();$$->Vvec.emplace_back(*$1);cout<<$1->ival<<' '<<$$->Vvec[0].ival<<'\n';} 
            ;
FUN_EXP     :'(' FUN_token'(' prams_def ')' FUN_BODY')'{bind(0,$4->vec);infunc = 0;}
            ;
prams_def   : prams_def ID{$1->vec.emplace_back($2->s);$$ = $1;} | ID{$$ = new Vec();$$->vec.emplace_back($1->s);}
            ;
FUN_token   : Fun{infunc = 1;}
            ;
FUN_BODY    : FUN_BODY EXP | EXP
            ;
NUM_OP      :  '+' EXP Plus_EXP  {$$ =new Var( $2->ival+$3->ival);} 
            | '-' EXP EXP {$$ =Sub($2,$3);} 
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
            | EXP{$$ = $1; $$->bval = 1; }
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

Funtion fun_arr[100]; 
map<string,int> id_table;
Var val_table[100];
priority_queue<int> can_use_seq;
int max_symbol = 100;
bool re = 0;
void bind(int id,vector<string> vec){
    fun_arr[id].pram_init(vec);
}
Var* result(vector<Var> vec){
    return fun_arr[func_id].result(vec);
}
Var* Sub(Var* l,Var* r){
    if(!infunc){
        return new Var(l->ival-r->ival);
    }
    else{
        fun_arr[func_id].add(Fun_oper(0));
        return new Var();
    }
}
Var* init(Var* x){
    if(!infunc){
        if(x->type == 2){
            return get_sym(x->s);
        }
        return x;
    }
    else{
        fun_arr[func_id].add(Fun_oper(*x));
        return new Var();
    }
}


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

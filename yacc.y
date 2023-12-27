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
        Fun_oper(string s){
            type = s;
        }
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
        
        Var* result(vector<Var>_pram ){
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
                else if(body[i].type== "sub"){
                    //cout<<"sub\n";
                    sub();
                }
                else if(body[i].type =="add"){
                    //cout<<"add\n";
                    add();
                }
                else if(body[i].type =="mul"){
                    //cout<<"mul\n";
                    mul();
                }
                else if(body[i].type =="div"){
                    cout<<"div\n";
                    div();
                }
                else if(body[i].type =="mod"){
                    cout<<"mod\n";
                    mod();
                }
                else if(body[i].type =="big"){
                    cout<<"big\n";
                    big();
                }
                else if(body[i].type =="les"){
                    cout<<"les\n";
                    les();
                }
                else if(body[i].type =="not"){
                    cout<<"not\n";
                    Not();
                }
                else if(body[i].type =="and"){
                    cout<<"big\n";
                    And();
                }
                else if(body[i].type =="or"){
                    cout<<"big\n";
                    Or();
                }
                else if(body[i].type =="if"){
                    cout<<"big\n";
                    If();
                }
                else if(body[i].type =="equ"){
                    cout<<"big\n";
                    equ();
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
            b.ival -= a.ival;
            sys_stack.push(b); 
        }
        private : void add(){
            Var a,b;
            a = top();b = top();
            a.ival += b.ival;
            sys_stack.push(a); 
        }
        private : void mul(){
            Var a,b;
            a = top();b = top();
            a.ival *= b.ival;
            sys_stack.push(a); 
        }
        private : void div(){
            Var a,b;
            a = top();b = top();
            b.ival /= a.ival;
            sys_stack.push(b); 
        }
        private : void mod(){
            Var a,b;
            a = top();b = top();
            b.ival %= a.ival;
            sys_stack.push(b); 
        }
        private : void big(){
            Var a,b;
            a = top();b = top();
            a.bval = a.ival>b.ival;
            a.type = 1;
            sys_stack.push(a); 
        }
        private : void les(){
            Var a,b;
            a = top();b = top();
            a.bval = a.ival<b.ival;
            a.type = 1;
            sys_stack.push(a); 
        }
        private : void And(){
            Var a,b;
            a = top();b = top();
            a.bval = a.bval and b.bval;
            a.type = 1;
            sys_stack.push(a); 
        }
        private : void Or(){
            Var a,b;
            a = top();b = top();
            a.bval = a.bval or b.bval;
            a.type = 1;
            sys_stack.push(a); 
        }
        private : void Not(){
            Var a;
            a = top();
            a.bval = !a.bval;
            a.type = 1;
            sys_stack.push(a); 
        }
        private : void If(){
            Var a,b,c;
            a = top();b = top();c = top();
            if(a.bval)sys_stack.push(b);
            else sys_stack.push(c);
        }
        private : void equ(){
            Var a,b;
            a = top();b = top();
            if(b.bval){
                if(a.ival!=b.ival){
                    a.bval = false;
                    a.type = 1;    
                }
                else{
                    a.bval = true;
                    a.type = 1;    
                }
            }
            else{
                a.bval = false;
                a.type = 1;
            }
            sys_stack.push(a); 
        }
    };
    Var* init (Var* x);
    Var* Sub(Var* l,Var* r);
    Var* Add(Var* l,Var* r);
    Var* Mul(Var*l, Var* r);
    Var* Div(Var*l, Var* r);
    Var* Mod(Var*l, Var* r);
    Var* Big(Var*l, Var* r);
    Var* les(Var*l, Var* r);
    Var* And_f(Var*l, Var* r);
    Var* Or_f(Var*l, Var* r);    
    Var* Not_f(Var*l);
    Var* If_f(Var* p,Var* l,Var* r);
    Var* Equ(Var*l, Var* r);
    void add_func(string s , int val);
    void bind(int id,vector<string> vec);
    Var* result(int id, vector<Var> vec);
    Var* result(string s,vector<Var> vec);
}
%{
void yyerror(const char *message);
extern int yylex();
int infunc,func_id=1;

%}
%union{
    Var* var;
    Vec* vec;
}
%token Print_N Print_B And Or Not Def Fun If MOD 
%token<var> num bool_val ID
%type<var> EXP Plus_EXP Mul_EXP NUM_OP BOOL_OP AND_EXP OR_EXP IF_EXP EQU_EXP Fun_CALL FUN_EXP
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
            | Fun_CALL {$$ = $1;} | FUN_EXP{$$ = $1;}
            ;
Fun_CALL    : '('FUN_EXP prams')'{$$ = result($2->ival,$3->Vvec);} | '(' ID prams ')'{$$ = result($2->s,$3->Vvec);}| '(' ID ')'{$$ = result($2->s,vector<Var>());}
            ;
prams       : prams EXP{$$ = $1;$$->Vvec.emplace_back(*$2);} | EXP{$$ = new Vec();$$->Vvec.emplace_back(*$1);} 
            ;
FUN_EXP     :'(' FUN_token'(' prams_def ')' FUN_BODY')'{bind(func_id,$4->vec);infunc = 0; $$ = new Var(func_id);$$->type = 3;func_id++;}
            |'(' FUN_token'(' ')' FUN_BODY')'{infunc = 0; $$ = new Var(func_id);$$->type = 3;func_id++;}
            ;
prams_def   : prams_def ID{$1->vec.emplace_back($2->s);$$ = $1;} | ID{$$ = new Vec();$$->vec.emplace_back($1->s);}
            ;
FUN_token   : Fun{infunc = 1;}
            ;
FUN_BODY    : FUN_BODY EXP | EXP
            ;
NUM_OP      : '+' EXP Plus_EXP {$$ = Add($2,$3);} 
            | '-' EXP EXP {$$ =Sub($2,$3);} 
            | '*' EXP Mul_EXP {$$ =Mul($2,$3);} 
            | '/' EXP EXP {$$ =Div($2,$3);} 
            | MOD EXP EXP {$$ =Mod($2,$3);}
            | '>' EXP EXP {$$ =Big($2,$3);}
            | '<' EXP EXP {$$ =les($2,$3);}
            | '=' EXP EQU_EXP {$$ = Equ($2,$3);}
            ;
EQU_EXP     : EQU_EXP EXP {
    $$ = Equ($1,$2);
} 
            | EXP{$$ = $1; $$->bval = 1; }
            ;
Plus_EXP    : Plus_EXP EXP {$$ = Add($1,$2);} | EXP {$$ = $1;}
            ;
Mul_EXP     : Mul_EXP EXP {$$ =Mul($1,$2);} | EXP {$$ = $1;}
            ;    
BOOL_OP     : And EXP AND_EXP {$$ = And_f($2,$3);} | Or EXP OR_EXP {$$ = Or_f($2,$3);} | Not EXP {$$ = Not_f($2);}
            ;
AND_EXP     : AND_EXP EXP {$$ = And_f($1,$2);}
            | EXP {$$ = $1;}
            ;
OR_EXP      : OR_EXP EXP {$$ = Or_f($1,$2);}
            | EXP {$$ = $1;}
            ;
Def_stmt    : '(' Def ID EXP ')'{
    if($4->type == 0){
        add_sym($3->s,$4->type,$4->ival);
    }
    else if($4->type == 3){
        add_func($3->s,$4->ival);
    }
    else{
        add_sym($3->s,$4->type,$4->bval);    
    }
}
            ;
IF_EXP      : '(' If EXP EXP EXP ')'{
            $$ = If_f($3,$4,$5);
}
            ;
%%
void xout(string s){
    //cout<<s<<'\n';
}
Funtion fun_arr[100]; 
map<string,int> id_table,fun_table;
Var val_table[100];
priority_queue<int> can_use_seq;
int max_symbol = 100;
bool re = 0;
void bind(int id,vector<string> vec){
    fun_arr[id].pram_init(vec);
}
Var* result(int id,vector<Var> vec){
    return fun_arr[id].result(vec);
}
Var* result(string s,vector<Var> vec){
    if(fun_table[s]==0){
        re = 1;
        return new Var();
    }
    return fun_arr[fun_table[s]].result(vec);
}
Var* If_f(Var* p,Var* l,Var* r){
    if(!infunc){
        if(p->bval){
            return l;
        }
        else{
            return r;
        }
    }
    else{
        fun_arr[func_id].add(Fun_oper((string) "if"));
        return new Var();
    }
}
Var* Sub(Var* l,Var* r){
    if(!infunc){
        return new Var(l->ival-r->ival);
    }
    else{
        fun_arr[func_id].add(Fun_oper((string) "sub"));
        return new Var();
    }
}
Var* Add(Var*l, Var* r){
    if(!infunc){
        return new Var(l->ival+r->ival);
    }
    else{
        xout("Add");
        fun_arr[func_id].add(Fun_oper((string)"add"));
        return new Var();
    }
}
Var* Mul(Var*l, Var* r){
    if(!infunc){
        return new Var(l->ival*r->ival);
    }
    else{
        xout("Mul");
        fun_arr[func_id].add(Fun_oper((string)"mul"));
        return new Var();
    }
}
Var* Div(Var*l, Var* r){
    if(!infunc){
        return new Var(l->ival/r->ival);
    }
    else{
        xout("div");
        fun_arr[func_id].add(Fun_oper((string)"div"));
        return new Var();
    }
}
Var* Mod(Var*l, Var* r){
    if(!infunc){
        return new Var(l->ival%r->ival);
    }
    else{
        xout("mod");
        fun_arr[func_id].add(Fun_oper((string)"mod"));
        return new Var();
    }
}
Var* Big(Var*l, Var* r){
    if(!infunc){
        return new Var(l->ival>r->ival);
    }
    else{
        xout("big");
        fun_arr[func_id].add(Fun_oper((string)"big"));
        return new Var();
    }
}
Var* les(Var*l, Var* r){
    if(!infunc){
        return new Var(l->ival<r->ival);
    }
    else{
        xout("les");
        fun_arr[func_id].add(Fun_oper((string)"les"));
        return new Var();
    }
}
Var* Equ(Var*l, Var* r){
    if(!infunc){
        Var *ret  =new Var( l->ival);
        if(!r->bval or l->ival!=r->ival)ret->bval = false;
        else ret->bval = 1;
        ret->type = 1;
        return ret;
    }
    else{
        xout("Equ");
        fun_arr[func_id].add(Fun_oper((string)"equ"));
        return new Var();
    }
}
Var* And_f(Var*l, Var* r){
    if(!infunc){
        return new Var(l->bval and r->bval);
    }
    else{
        xout("and");
        fun_arr[func_id].add(Fun_oper((string)"and"));
        return new Var();
    }
}
Var* Or_f(Var*l, Var* r){
    if(!infunc){
        return new Var(l->bval or r->bval);
    }
    else{
        xout("or");
        fun_arr[func_id].add(Fun_oper((string)"or"));
        return new Var();
    }
}
Var* Not_f(Var*l){
    if(!infunc){
        return new Var(!l->bval);
    }
    else{
        xout("not");
        fun_arr[func_id].add(Fun_oper((string)"not"));
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

void add_func(string s , int val){
    if(fun_table[s]){
        re =true;
        return;
    }
    fun_table[s] = val;
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

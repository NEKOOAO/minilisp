# 寫在前面
- final.out為執行檔，可直接運行(不知道windos能不能跑就是)
- run 為編譯指令，如何使用寫在最後
- yacc_base 為沒有實作funtion call 的版本
- yacc 為完整版 然後多了快400行 = =
- code 非常醜，請輕噴
- code 有bug歡迎回報
- 這個架構應該是很彈性，應該能做完所有加分題
- 請不要照抄，至少知道你在寫甚麼，至少這大概是你最後一次寫編譯器了030

# funtion call怎麼做

給翻到這個檔案的人一些 funtion call 的提示

yacc的遍歷順序為後續，也就是說每一段code會依照後續依序執行

當你要建置funtion body時 遍可以用這個特性實作

我自己的方式是用一個vector存每一步要推入變數或是執行運算

之後由於是後序，就能簡單使用stack實作了

雖然說是簡單，但是寫了400多行((

# Mini LISP Interpreter
- interpreter of a prototype of LISP.
# Implement Way
C++
Yacc
Lex
# Feature
- Print Statements
    - Print Number
    - Print Boolean
- Numerical Operations
    - Addition
    - Subtraction
    - Multiplication
    - Division
    - Modulus
    - $>,<,=$
- Logical Operations
    - And
    - Or
    - Not
- Define Statements
    - Define Variable
    - Define Function
- Function
    - Anonymous Function
    - Named Function
- If-Else Statement
- Type Checking
# 環境
linux (kali)
# 如何編譯
執行run，之後會產生一個final.out
如果不能執行(權限被拒)
你可以
~~chmod 777 run~~

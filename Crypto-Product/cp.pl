:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).

cp_solver(L_vars, R_vars, Res_vars):-
    append(L_vars, R_vars, Op), append(Op, Res_vars, VarsDup),
    remove_dups(VarsDup, Vars),
    domain(Vars, 0, 9),
    all_distinct(Vars),

    nth1(1, L_vars, L1),
    nth1(1, R_vars, R1),
    nth1(1, Res_vars, Res1),
    Not0Dups = [L1, R1, Res1],
    remove_dups(Not0Dups, Not0),
    applyNon0(Not0),
    

    convertDigitListToNumber(L_vars, L_number),
    convertDigitListToNumber(R_vars, R_number),
    convertDigitListToNumber(Res_vars, Res_number),
    L_number * R_number #= Res_number,

    labeling([], [L_number, R_number, Res_number]),
    format('\nSolution: ~w x ~w = ~w\n', [L_number, R_number, Res_number]).


cp_generator(L_digits, R_digits, Res_digits, [L_vars, R_vars, Res_vars]):-
    L_lowerpow is L_digits-1,
    R_lowerpow is R_digits-1,
    Res_lowerpow is Res_digits-1,

    pow(10,L_lowerpow, L_lowerbound),
    pow(10,L_digits, L_upperbound_1),
    pow(10,R_lowerpow, R_lowerbound),
    pow(10,R_digits, R_upperbound_1),
    pow(10,Res_lowerpow, Res_lowerbound),
    pow(10,Res_digits, Res_upperbound_1),

    L_upperbound is L_upperbound_1-1,
    R_upperbound is R_upperbound_1-1,
    Res_upperbound is Res_upperbound_1-1,

    L_number in L_lowerbound..L_upperbound,
    R_number in R_lowerbound..R_upperbound,
    Res_number in Res_lowerbound..Res_upperbound,

    L_number #> 0, R_number #> 0, Res_number #> 0,

    L_number * R_number #= Res_number,

    convertDigitListToNumber(L_number_list, L_number),
    convertDigitListToNumber(R_number_list, R_number),
    convertDigitListToNumber(Res_number_list, Res_number),

    DicList = [A, B, C, D, E, F, G, H, I, J],
    convertDigitListToVarList(L_number_list, DicList, L_vars),
    convertDigitListToVarList(R_number_list, DicList, R_vars),
    convertDigitListToVarList(Res_number_list, DicList, Res_vars),

    labeling([], [L_number, R_number, Res_number]),

    format('\nPuzzle: ~w x ~w = ~w\n', [L_vars, R_vars, Res_vars]),
    format('Solution: ~w x ~w = ~w\n', [L_number, R_number, Res_number]).


applyNon0([]).
applyNon0([H | T]):-
    H #> 0,
    applyNon0(T).

convertDigitListToNumber(Ds, N) :-
    convertDigitListToNumber(Ds, 0, N), !.
    
convertDigitListToNumber([], N, N).
convertDigitListToNumber([D|Ds], N0,N) :-
    D #>= 0, D #< 10,
    N0 #=< N,
    N1 #= D+N0*10,
    convertDigitListToNumber(Ds, N1, N).

pow(_,0,1).
pow(N,P,R) :- P > 0,!, P1 is P-1, pow(N,P1,R1), R is N*R1.


convertDigitListToVarList(DigitList, DicList, VarList):-
    convertDigitListToVarList(DigitList, DicList, [], VarList).

convertDigitListToVarList([], _, VarList, VarList).
convertDigitListToVarList([H | T], DicList, AuxList, VarList):-
    nth0(H, DicList, Var),
    append(AuxList, [Var], NewAux),
    convertDigitListToVarList(T, DicList, NewAux, VarList).
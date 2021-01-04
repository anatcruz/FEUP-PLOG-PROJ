:-use_module(library(clpfd)).
:-use_module(library(lists)).
:-use_module(library(random)).
:-compile('tests.pl').

cp_solver(L_digits_list, R_digits_list, Res_digits_list, L_number, R_number, Res_number):-
    cp_solver(L_digits_list, R_digits_list, Res_digits_list, L_number, R_number, Res_number, [min,bisect,up]).

cp_solver(L_digits_list, R_digits_list, Res_digits_list, L_number, R_number, Res_number, LabelingOps):-
    length(L_digits_list, L_num_digits),
    length(R_digits_list, R_num_digits),
    length(Res_digits_list, Res_num_digits),

    append(L_digits_list, R_digits_list, Op), append(Op, Res_digits_list, DigitsDup),
    remove_dups(DigitsDup, Digits),
    domain(Digits, 0, 9),
    all_distinct(Digits),

    element(1, L_digits_list, L1),
    element(1, R_digits_list, R1),
    element(1, Res_digits_list, Res1),
    Not0Dups = [L1, R1, Res1],
    remove_dups(Not0Dups, Not0),
    applyNon0(Not0),

    convertDigitListToNumber(L_digits_list, L_number),
    convertDigitListToNumber(R_digits_list, R_number),
    convertDigitListToNumber(Res_digits_list, Res_number),

    L_number * R_number #= Res_number, !,

    labeling(LabelingOps, [L_number, R_number, Res_number]).

cp_generator(L_digits_list, R_digits_list, Res_digits_list, L_num_digits, R_num_digits):-
    cp_generator(L_digits_list, R_digits_list, Res_digits_list, L_num_digits, R_num_digits, [min,bisect,up]).

cp_generator(L_digits_list, R_digits_list, Res_digits_list, L_num_digits, R_num_digits, LabelingOps):-
    Res_max_digits is L_num_digits+R_num_digits,
    (
        (
            Res_num_digits is Res_max_digits-1,
            cp_generator(L_digits_list, R_digits_list, Res_digits_list, L_num_digits, R_num_digits, Res_num_digits, LabelingOps)
        );
        (
            Res_num_digits is Res_max_digits,
            cp_generator(L_digits_list, R_digits_list, Res_digits_list, L_num_digits, R_num_digits, Res_num_digits, LabelingOps)
        )
    ).

cp_generator(L_digits_list, R_digits_list, Res_digits_list, L_num_digits, R_num_digits, Res_num_digits, LabelingOps):-
    length(L_digits_list, L_num_digits),
    length(R_digits_list, R_num_digits),
    length(Res_digits_list, Res_num_digits),

    append(L_digits_list, R_digits_list, Op), append(Op, Res_digits_list, DigitsDup),
    remove_dups(DigitsDup, Digits),
    domain(Digits, 0, 9),
    DiffDigitsRange in 2..Res_num_digits,
    nvalue(DiffDigitsRange, Digits),

    element(1, L_digits_list, L1),
    element(1, R_digits_list, R1),
    element(1, Res_digits_list, Res1),
    Not0Dups = [L1, R1, Res1],
    remove_dups(Not0Dups, Not0),
    applyNon0(Not0),

    convertDigitListToNumber(L_digits_list, L_number),
    convertDigitListToNumber(R_digits_list, R_number),
    convertDigitListToNumber(Res_digits_list, Res_number),

    L_pow is L_num_digits-1, R_pow is R_num_digits-1,
    pow(10, L_pow, L_lowerbound), pow(10, R_pow, R_lowerbound),
    (
        (L_number#=L_lowerbound, restrictPuzzles(R_digits_list)) ;
        (L_number#>L_lowerbound, R_number#=R_lowerbound, restrictPuzzles(L_digits_list)) ;
        (L_number#>L_lowerbound, R_number#>R_lowerbound)
    ),

    L_number * R_number #= Res_number, !,

    labeling(LabelingOps, [L_number, R_number, Res_number]).


cp_showAllPuzzlesAndAllSolutions(L_digits_num, R_digits_num, L_number, R_number, Res_number):-
    cp_generator(L_digits_list, R_digits_list, Res_digits_list, L_digits_num, R_digits_num),
    printPuzzle(L_digits_list, R_digits_list, Res_digits_list),
    convertAllDigitsListToVarList(L_digits_list, R_digits_list, Res_digits_list, L_vars, R_vars, Res_vars),
    cp_solver(L_vars, R_vars, Res_vars, L_number, R_number, Res_number),
    printSolution(L_number, R_number, Res_number).


pow(_,0,1).
pow(N,P,R) :- P > 0,!, P1 is P-1, pow(N,P1,R1), R is N*R1.

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


%+DigitsList
restrictPuzzles([H|T]):-
    H#>0, H #=<2,
    restrictPuzzles(T, H).

restrictPuzzles([], _).
restrictPuzzles([H|T], MaxPrevious):-
    H#=<MaxPrevious+1,
    maximum(NewMax, [MaxPrevious, H]),
    restrictPuzzles(T, NewMax).


convertAllDigitsListToVarList(L_digits_list, R_digits_list, Res_digits_list, L_vars, R_vars, Res_vars):-
    DicList = [A, B, C, D, E, F, G, H, I, J],
    convertDigitsListToVarList(L_digits_list, DicList, L_vars),
    convertDigitsListToVarList(R_digits_list, DicList, R_vars),
    convertDigitsListToVarList(Res_digits_list, DicList, Res_vars).

convertDigitsListToVarList(DigitList, DicList, VarList):-
    convertDigitsListToVarList(DigitList, DicList, [], VarList).

convertDigitsListToVarList([], _, VarList, VarList).
convertDigitsListToVarList([H | T], DicList, AuxList, VarList):-
    nth0(H, DicList, Var),
    append(AuxList, [Var], NewAux),
    convertDigitsListToVarList(T, DicList, NewAux, VarList).


printSolution(L_number, R_number, Res_number):-
    format('~w x ~w = ~w\n', [L_number, R_number, Res_number]).

printPuzzle(L_digits_list, R_digits_list, Res_digits_list):-
    append(L_digits_list, R_digits_list, Op), append(Op, Res_digits_list, DigitsList),
    buildColorAuxList(DigitsList, ListColors),
    convertListDigitsToStringColor(L_digits_list, ListColors, L_string),
    convertListDigitsToStringColor(R_digits_list, ListColors, R_string),
    convertListDigitsToStringColor(Res_digits_list, ListColors, Res_string),
    format('\n~w x ~w = ~w\n', [L_string, R_string, Res_string]),

%Build an auxiliar list like [1-'R',2-'B',...]
buildColorAuxList([],_).
buildColorAuxList(DigitsList, ListColors) :-
    Dic = ['R', 'G', 'B', 'W', 'N', 'Y', 'O', 'P', 'C', 'F'],
    remove_dups(DigitsList, NoDupsList),
    buildColorAuxList(Dic, NoDupsList, [], ListColors, 0 ),!.

buildColorAuxList(_,[], ListColors, ListColors, _).
buildColorAuxList(Dic, [H|T], AuxList, ListColors, Index) :-
    nth0(Index, Dic, Element),
    append(AuxList, [H-Element], NewAuxList),
    NewIndex is Index + 1,
    buildColorAuxList(Dic, T, NewAuxList, ListColors, NewIndex). 

%Get the color for a giver digit from the auxiliar list
getColor(_, [], _).
getColor(Digit, AuxList, Color) :- 
    getColor(Digit, AuxList, '', Color),! .

getColor(_, [], Color, Color).
getColor(Digit, [H-Key|T], AccColor, Color) :-
    (
        Digit == H, atom_concat(Key, AccColor, NewAccColor),
        getColor(Digit, T, NewAccColor, Color)
    );
    getColor(Digit, T, AccColor, Color).

%Converts a list of digits to a string of colors, like [1,2,3] to 'RGB'
convertListDigitsToStringColor([], _, _).
convertListDigitsToStringColor(ListDigits, ColorAuxList, StringColor) :-
    convertListDigitsToStringColor(ListDigits, ColorAuxList, '', StringColor), !.

convertListDigitsToStringColor([], _, StringColor, StringColor).
convertListDigitsToStringColor([H|T], ColorAuxList, AccColor, StringColor) :-
    getColor(H, ColorAuxList, Color),
    atom_concat(AccColor, Color, NewAccColor),
    convertListDigitsToStringColor(T, ColorAuxList, NewAccColor, StringColor).
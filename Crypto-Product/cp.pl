:-use_module(library(clpfd)).
:-use_module(library(lists)).
:-use_module(library(random)).
:-compile('tests.pl').

/* PUZZLE GENERATION AND SOLVING */

% Call cp_solver with the best combination of heuristics found
cp_solver(L_digits_list, R_digits_list, Res_digits_list, L_number, R_number, Res_number):-
    cp_solver(L_digits_list, R_digits_list, Res_digits_list, L_number, R_number, Res_number, [min,bisect,up]).

% Solve a puzzle (all possible solutions) given the digits list, using LabelingOps on labeling
cp_solver(L_digits_list, R_digits_list, Res_digits_list, L_number, R_number, Res_number, LabelingOps):-
    % Get each digit list length
    length(L_digits_list, L_num_digits),
    length(R_digits_list, R_num_digits),
    length(Res_digits_list, Res_num_digits),

    append(L_digits_list, R_digits_list, Op), append(Op, Res_digits_list, DigitsDup), % Create a flatten list with all digits
    remove_dups(DigitsDup, Digits), % Remove duplicated digits from the list
    domain(Digits, 0, 9), % All digits must be integers at least between 0 and 9

    all_distinct(Digits), % All passed variables must be distinct

    restrictAboveZero(L_digits_list, R_digits_list, Res_digits_list), % First digit of each number must be above 0

    % Convert each digit list to a number
    convertDigitListToNumber(L_digits_list, L_number),
    convertDigitListToNumber(R_digits_list, R_number),
    convertDigitListToNumber(Res_digits_list, Res_number),

    % Apply the multiplication restriction
    L_number * R_number #= Res_number, !,

    labeling(LabelingOps, [L_number, R_number, Res_number]).


% Call cp_generator with the best combination of heuristics found
cp_generator(L_digits_list, R_digits_list, Res_digits_list, L_num_digits, R_num_digits):-
    cp_generator(L_digits_list, R_digits_list, Res_digits_list, L_num_digits, R_num_digits, [min,bisect,up]).

% Generate a puzzle (all possible) given the number of digits, using LabelingOps on labeling
cp_generator(L_digits_list, R_digits_list, Res_digits_list, L_num_digits, R_num_digits, LabelingOps):-
    % Assert each digit list length
    length(L_digits_list, L_num_digits),
    length(R_digits_list, R_num_digits),

    % Result digit list will have L_num_digits+R_num_digits length or L_num_digits+R_num_digits-1
    Res_max_digits is L_num_digits+R_num_digits,
    Res_min_digits is Res_max_digits-1,
    (length(Res_digits_list, Res_min_digits); length(Res_digits_list, Res_max_digits)),
    

    append(L_digits_list, R_digits_list, Op), append(Op, Res_digits_list, DigitsDup), % Create a flatten list with all digits
    remove_dups(DigitsDup, Digits), % Remove duplicated digits from the list
    domain(Digits, 0, 9), % All digits must be integers at least between 0 and 9

    DiffDigitsRange in 2..Res_max_digits,
    nvalue(DiffDigitsRange, Digits), % At least 2 diferent digits, at most the maximum digits the result can have for the configuration

    restrictAboveZero(L_digits_list, R_digits_list, Res_digits_list), % First digit of each number must be above 0

    % Convert each digit list to a number
    convertDigitListToNumber(L_digits_list, L_number),
    convertDigitListToNumber(R_digits_list, R_number),
    convertDigitListToNumber(Res_digits_list, Res_number),

    % Applies restriction to powers of 10, so we can restrict repeated puzzles
    L_pow is L_num_digits-1, R_pow is R_num_digits-1,
    pow(10, L_pow, L_lowerbound), pow(10, R_pow, R_lowerbound),
    (
        (L_number#=L_lowerbound, restrictPower10(R_digits_list)) ;
        (L_number#>L_lowerbound, R_number#=R_lowerbound, restrictPower10(L_digits_list)) ;
        (L_number#>L_lowerbound, R_number#>R_lowerbound)
    ),

    % Apply the multiplication restriction
    L_number * R_number #= Res_number,

    labeling(LabelingOps, [L_number, R_number, Res_number]).


showAllPuzzlesAndAllSolutions(L_digits_num, R_digits_num, L_number, R_number, Res_number):-
    cp_generator(L_digits_list, R_digits_list, Res_digits_list, L_digits_num, R_digits_num),
    printPuzzle(L_digits_list, R_digits_list, Res_digits_list),
    convertAllDigitsListToVarList(L_digits_list, R_digits_list, Res_digits_list, L_vars, R_vars, Res_vars),
    cp_solver(L_vars, R_vars, Res_vars, L_number, R_number, Res_number),
    printSolution(L_number, R_number, Res_number).


% Power function
pow(_,0,1).
pow(N,P,R) :- P > 0,!, P1 is P-1, pow(N,P1,R1), R is N*R1.


% Restrict 1st digit of each must be higher than 0
restrictAboveZero(L_digits_list, R_digits_list, Res_digits_list):-
    % Get first digit of each digit list (first digit of a number)
    element(1, L_digits_list, L1),
    element(1, R_digits_list, R1),
    element(1, Res_digits_list, Res1),

    Not0Dups = [L1, R1, Res1], % Create a list with the digits that can't be 0
    remove_dups(Not0Dups, Not0), % Remove dups from the list
    applyAboveZero(Not0). % Apply the restriction to the digits

% All digits of the list must be higher than 0
applyAboveZero([]).
applyAboveZero([H | T]):-
    H #> 0,
    applyAboveZero(T).

% Convert a list of digits (as [1,3,5]) to a number (as 135)
convertDigitListToNumber(DigitList, Number) :-
    convertDigitListToNumber(DigitList, 0, Number), !.
    
convertDigitListToNumber([], Number, Number).
convertDigitListToNumber([D|T], N0, N) :-
    D #>= 0, D #< 10, % Digits [0,9]
    N0 #=< N, % Current number is below or equal to the final number
    N1 #= D+N0*10,
    convertDigitListToNumber(T, N1, N).


% Called to restrict a DigitList of a number when the other number is a power of 10, avoiding generating repeated puzzles
restrictPower10([H|T]):-
    H#>0, H #=<2,
    restrictPower10(T, 2).

restrictPower10([], _).
restrictPower10([H|T], MaxPrevious):-
    H#=<MaxPrevious+1,
    maximum(NewMax, [MaxPrevious, H]),
    restrictPower10(T, NewMax).

% Converts the list of digits of each number to a list of vars (like [1,3,4] to [A,B,C])
convertAllDigitsListToVarList(L_digits_list, R_digits_list, Res_digits_list, L_vars, R_vars, Res_vars):-
    DicList = [A, B, C, D, E, F, G, H, I, J],
    convertDigitsListToVarList(L_digits_list, DicList, L_vars),
    convertDigitsListToVarList(R_digits_list, DicList, R_vars),
    convertDigitsListToVarList(Res_digits_list, DicList, Res_vars).

% Converts a list of digits to a list of vars (like [1,3,4] to [A,B,C]) using DicList. Same numbers get the same variable
convertDigitsListToVarList(DigitList, DicList, VarList):-
    convertDigitsListToVarList(DigitList, DicList, [], VarList).

convertDigitsListToVarList([], _, VarList, VarList).
convertDigitsListToVarList([H | T], DicList, AuxList, VarList):-
    nth0(H, DicList, Var),
    append(AuxList, [Var], NewAux),
    convertDigitsListToVarList(T, DicList, NewAux, VarList).

/* DISPLAY */

% Print formated solution
printSolution(L_number, R_number, Res_number):-
    format('\nSolution: ~w x ~w = ~w\n', [L_number, R_number, Res_number]).

% Print formated puzzle. Convert each list of digits to a list of colors
printPuzzle(L_digits_list, R_digits_list, Res_digits_list):-
    append(L_digits_list, R_digits_list, Op), append(Op, Res_digits_list, DigitsList),
    buildColorAuxList(DigitsList, ListColors),
    convertListDigitsToStringColor(L_digits_list, ListColors, L_string),
    convertListDigitsToStringColor(R_digits_list, ListColors, R_string),
    convertListDigitsToStringColor(Res_digits_list, ListColors, Res_string),
    format('\nPuzzle: ~w x ~w = ~w\n', [L_string, R_string, Res_string]),

%Build an a number-color list like [1-'R',2-'B',...]
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
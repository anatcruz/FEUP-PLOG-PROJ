%Replaces given Value (content) in Index position of the List
replaceInList([_H|T], 0, Value, [Value|T]).
replaceInList([H|T], Index, Value, [H|TNew]) :-
	Index > 0,
	Index1 is Index - 1,
	replaceInList(T, Index1, Value, TNew).

%Replaces Value (content) in given Row and Column of the Matrix
replaceInMatrix([H|T], 0, Col, Value, [HNew|T]) :-
	replaceInList(H, Col, Value, HNew).

replaceInMatrix([H|T], Row, Col, Value, [H|TNew]) :-
	Row > 0,
	Row1 is Row - 1,
	replaceInMatrix(T, Row1, Col, Value, TNew).

%Gets Value (content) in Index position of the List
getValueFromList([H|_T], 0, Value) :-
	Value = H.

getValueFromList([_H|T], Index, Value) :-
	Index > 0,
	Index1 is Index - 1,
	getValueFromList(T, Index1, Value).

%Gets Value (content) in given Row and Column of the Matrix
getValueFromMatrix([H|_T], 0, Col, Value) :-
	getValueFromList(H, Col, Value).

getValueFromMatrix([_H|T], Row, Col, Value) :-
	Row > 0,
	Row1 is Row - 1,
	getValueFromMatrix(T, Row1, Col, Value).

isEmpty(List):-
	length(List, Size),
	Size=0.

appendListNotEmpty(L1, [], L1).
appendListNotEmpty(L1, L2, L12):-
	append(L1, [L2], L12).

printMove([]).
printMove([H|T]):-
	letter(H, Row),
	Col is T+1,
	format(" ~w~w ", [Row,Col]).

printMovesList([]).
printMovesList([H|T]):-
	printMove(H),
	printMovesList(T).

isPlayer(Board, Row, Column, Player) :-
    getValueFromMatrix(Board, Row, Column, Value),
    Player is Value.

isEnemy(Board, Row, Column, Player) :-
    getValueFromMatrix(Board, Row, Column, Enemy),
    Enemy is -Player.
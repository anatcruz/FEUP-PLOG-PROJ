%https://stackoverflow.com/questions/8519203/prolog-replace-an-element-in-a-list-at-a-specified-index
replaceInList(I, L, E, K) :-
  nth0(I, L, _, R),
  nth0(I, K, E, R).

%Replaces Value (content) in given Row and Column of the Matrix
replaceInMatrix(Matrix, Row, Col, Value, FinalMatrix) :-
	nth0(Row, Matrix, RowList),
	replaceInList(Col, RowList, Value, NewRow),
	replaceInList(Row, Matrix, NewRow, FinalMatrix).

%Gets Value (content) in given Row and Column of the Matrix
getValueFromMatrix(Matrix, Row, Col, Value) :-
	nth0(Row, Matrix, RowList),
	nth0(Col, RowList, Value).

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
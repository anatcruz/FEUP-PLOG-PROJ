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
	get_letter(H),
	get_number(T).

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

get_letter(Row) :-
	NewRow is Row + 65,
	char_code(X, NewRow),
	write(X).

get_number(Column) :-
	NewColumn is Column + 49,
	char_code(X, NewColumn),
	write(X).

/*A recursive function to replace 
previous char 'prevC' at '(Row, Col)' 
and all surrounding pixels of (Row, Col) 
with new char 'newC' and */
floodFill(Matrix, Size, Row, Col, PrevC, NewC, FinalMatrix):-
  (
    (
      Row >= 0, Row < Size, Col >= 0, Col < Size,
	  getValueFromMatrix(Matrix, Row, Col, Value),
      Value == PrevC,
      Value \== NewC,
	  replaceInMatrix(Matrix, Row, Col, NewC, UpdatedMatrix),
      Row1 is Row+1, Row2 is Row-1, Col1 is Col+1, Col2 is Col-1,
      floodFill(UpdatedMatrix, Size, Row1, Col, PrevC, NewC, M1) ,
      floodFill(M1, Size, Row2, Col, PrevC, NewC, M2) ,
      floodFill(M2, Size, Row, Col1, PrevC, NewC, M3) , 
      floodFill(M3, Size, Row, Col2, PrevC, NewC, FinalMatrix) 
    )
  ;
    (FinalMatrix = Matrix) 
  ).
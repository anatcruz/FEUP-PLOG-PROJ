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

get_letter(Row, Letter) :-
	NewRow is Row + 65,
	char_code(Letter, NewRow).

get_number(Column, Number) :-
	NewColumn is Column + 49,
	char_code(Number, NewColumn).

enterContinue:-
	write('\nPress ENTER to continue.'),
    skip_line.

%Checks is List is empty
isEmpty([]).

%If given L2 list is not empty, append it to L1 and result is L12
appendNotEmpty(L1, [], L1).
appendNotEmpty(L1, L2, L12):-
	append(L1, L2, L12).

%If given L2 list is not empty, append [L2] to L1 and result is L12
appendListNotEmpty(L1, [], L1).
appendListNotEmpty(L1, L2, L12):-
	append(L1, [L2], L12).

appendMoves(_, [], []).
appendMoves(Pos, Moves, RetList):-
	appendMoves(Pos, Moves, [], RetList).

appendMoves(Pos, [], RetList, RetList).
appendMoves(Pos, [Move | T], AuxList, RetList):-
	CompleteMove = [Pos, Move],
	append([CompleteMove], AuxList, NewAuxList),
	appendMoves(Pos, T, NewAuxList, RetList).

%Given a move (represented as a list of [Row, Column]), prints first two elements
printMove([]).
printMove(Row-Column):-
	get_letter(Row, RowL),
	get_number(Column, ColumnL),
	format(" ~w~w ", [RowL,ColumnL]).

%Prints a list of several moves (represented as [[Row,Col], ...])
printMovesList([]).
printMovesList([H|T]):-
	printMove(H),
	printMovesList(T).

%Checks if board value in the given position (row and column) is the current player
isPlayer(Board, Row, Column, Player) :-
    getValueFromMatrix(Board, Row, Column, Player).

%Checks if board value in the given position (row and column) is the current player's enemy
isEnemy(Board, Row, Column, Player) :-
    getValueFromMatrix(Board, Row, Column, Enemy),
    Enemy is -Player.

printTurn(1):-
	write('\n > RED(O) turn <\n').

printTurn(-1):-
	write('\n > BLUE(X) turn <\n').

%Print formated red player win
printWinner(1):-
	write('\n!!! RED(O) player won !!!\n\n').

%Print formated blue player win
printWinner(-1):-
	write('\n!!! BLUE(X) player won !!!\n\n').

/*A recursive function to replace 
previous char 'prevC' at '(Row, Col)' 
and all surrounding pixels of (Row, Col) 
with new char 'newC' and */
floodFill(Matrix, Size, Row, Col, PrevC, NewC, FinalMatrix):-
(
	(
		Row >= 0, Row < Size, Col >= 0, Col < Size,
		getValueFromMatrix(Matrix, Row, Col, PrevC),
		replaceInMatrix(Matrix, Row, Col, NewC, UpdatedMatrix),
		Row1 is Row+1, Row2 is Row-1, Col1 is Col+1, Col2 is Col-1,
		floodFill(UpdatedMatrix, Size, Row1, Col, PrevC, NewC, M1) ,
		floodFill(M1, Size, Row2, Col, PrevC, NewC, M2) ,
		floodFill(M2, Size, Row, Col1, PrevC, NewC, M3) , 
		floodFill(M3, Size, Row, Col2, PrevC, NewC, FinalMatrix) 
	);
	(
		FinalMatrix = Matrix
	)
).

%If given position is an empty space, floodfill the board replacing empty spaces(0) with '?'(2)
tryFloodFill(Board, Size, Row, Col, FinalBoard):-
    getValueFromMatrix(Board, Row, Col, 0),
    floodFill(Board, Size, Row, Col, 0, 2, FinalBoard), !.

getPositionAndMove(Move, SelPosition, MovPosition):-
	nth0(0, Move, SelPosition),
	nth0(1, Move, MovPosition).


getPlayerInMatrix(GameState, Size, Player, ListOfPositions) :-
	getPlayerInMatrix(GameState, Size, 0, 0, Player, [], ListOfPositions), !.

getPlayerInMatrix(_, Size, Row, Column, _, ListOfPositions, ListOfPositions):-
	check_end(Row, Column, Size).

getPlayerInMatrix(GameState, Size, Row, Column, Player, ListInterm, ListOfPositions):-
	isPlayer(GameState, Row, Column, Player),
	append(ListInterm, [Row-Column], NewList),
	next_index(Row, Column, Size, NextRow, NextColumn),
	getPlayerInMatrix(GameState, Size, NextRow, NextColumn, Player, NewList, ListOfPositions).

getPlayerInMatrix(GameState, Size, Row, Column, Player, ListInterm, ListOfPositions):-
	next_index(Row, Column, Size, NextRow, NextColumn),
	getPlayerInMatrix(GameState, Size, NextRow, NextColumn, Player, ListInterm, ListOfPositions).

getAllPossibleMoves(GameState, Size, Player, Positions, ListOfPossibleMoves):-
	getAllPossibleMoves(GameState, Size, Player, Positions, [], ListOfPossibleMoves).

getAllPossibleMoves(_, _, _, [], ListOfPossibleMoves, ListOfPossibleMoves).
getAllPossibleMoves(GameState, Size, Player, [Row-Column|PosRest], ListInterm, ListOfPossibleMoves):-
	checkMove(GameState, Size, Row, Column, Player, Moves),
	appendMoves(Row-Column, Moves, CurrentMoves),
	appendNotEmpty(ListInterm, CurrentMoves, NewList),
	getAllPossibleMoves(GameState, Size, Player, PosRest, NewList, ListOfPossibleMoves), !.

next_index(Row, Column, Length, NextRow, NextColumn):-
    Column1 is Column + 1,
    Column1 \== Length,
    NextColumn is Column1, 
    NextRow is Row.
next_index(Row, Column, Length, NextRow, NextColumn):-
    Column1 is Column + 1,
    Column1 == Length, 
    NextColumn is 0,
    NextRow is Row + 1.

check_end(Row, Col, Size):-
	Row is Size, Col is 0.

count(_, [], 0).
count(Num, [H|T], X) :- Num \= H, count(Num, T, X).
count(Num, [H|T], X) :- Num = H, count(Num, T, X1), X is X1 + 1.

% Receives [4,3,4,3,0,0] and returns 4
% [0,1,0,0,1,4,2] returns 3
% Returns in Result the longest sequence not formed by 0
sequence(List, Result):-
    sequence(List, 0, 0, Result).
sequence([], Counter, MaxLength, Counter):-
    Counter > MaxLength.
sequence([], _, MaxLength, MaxLength).
sequence([ToTest|Rest], Counter, MaxLength, Result):-
    ToTest == 0, Counter > MaxLength, 
    sequence(Rest, 0, Counter, Result).
sequence([ToTest|Rest], _, MaxLength, Result):-
    ToTest == 0, 
    sequence(Rest, 0, MaxLength, Result).
sequence([_|Rest], Counter, MaxLength, Result):-
    Counter1 is Counter+1,
    sequence(Rest, Counter1, MaxLength, Result).
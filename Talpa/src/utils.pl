%https://stackoverflow.com/questions/8519203/prolog-replace-an-element-in-a-list-at-a-specified-index
replaceInList(I, L, E, K) :-
	nth0(I, L, _, R),
	nth0(I, K, E, R).

%Replaces Value (content) in given Row and Column of the Matrix
replaceInMatrix(Matrix, Row, Column, Value, FinalMatrix) :-
	nth0(Row, Matrix, RowList),
	replaceInList(Column, RowList, Value, NewRow),
	replaceInList(Row, Matrix, NewRow, FinalMatrix).

%Gets Value (content) in given Row and Column of the Matrix
getValueFromMatrix(Matrix, Row, Column, Value) :-
	nth0(Row, Matrix, RowList),
	nth0(Column, RowList, Value).

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

appendMoves(_, [], []).
appendMoves(Pos, Moves, RetList):-
	appendMoves(Pos, Moves, [], RetList).

appendMoves(Pos, [], RetList, RetList).
appendMoves(Pos, [Move | T], AuxList, RetList):-
	CompleteMove = [Pos, Move],
	append([CompleteMove], AuxList, NewAuxList),
	appendMoves(Pos, T, NewAuxList, RetList).

%Print a given position (represented as a Row-Column)
printPosition([]).
printPosition(Row-Column):-
	get_letter(Row, RowL),
	get_number(Column, ColumnL),
	format(" ~w~w ", [RowL,ColumnL]).

%Prints a list of several Positions (represented as [Position1, Position2, ...])
printPositionsList([]).
printPositionsList([H|T]):-
	printPosition(H),
	printPositionsList(T).

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
previous char 'prevC' at '(Row, Column)' 
and all surrounding pixels of (Row, Column) 
with new char 'newC' and */
floodFill(Matrix, Size, Row, Column, PrevC, NewC, FinalMatrix):-
(
	(
		Row >= 0, Row < Size, Column >= 0, Column < Size,
		getValueFromMatrix(Matrix, Row, Column, PrevC),
		replaceInMatrix(Matrix, Row, Column, NewC, UpdatedMatrix),
		Row1 is Row+1, Row2 is Row-1, Col1 is Column+1, Col2 is Column-1,
		floodFill(UpdatedMatrix, Size, Row1, Column, PrevC, NewC, M1) ,
		floodFill(M1, Size, Row2, Column, PrevC, NewC, M2) ,
		floodFill(M2, Size, Row, Col1, PrevC, NewC, M3) , 
		floodFill(M3, Size, Row, Col2, PrevC, NewC, FinalMatrix) 
	);
	(
		FinalMatrix = Matrix
	)
).

%If given position is an empty space, floodfill the board replacing empty spaces(0) with '?'(2)
tryFloodFill(Board, Size, Row, Column, FinalBoard):-
    getValueFromMatrix(Board, Row, Column, 0),
    floodFill(Board, Size, Row, Column, 0, 2, FinalBoard), !.

getSelAndMovePosition(Move, SelPosition, MovPosition):-
	nth0(0, Move, SelPosition),
	nth0(1, Move, MovPosition).


getPlayerInMatrix(GameState, Size, Player, ListOfPositions) :-
	getPlayerInMatrix(GameState, Size, 0, 0, Player, [], ListOfPositions), !.

getPlayerInMatrix(_, Size, Row, Column, _, ListOfPositions, ListOfPositions):-
	checkEndPosition(Row, Column, Size).

getPlayerInMatrix(GameState, Size, Row, Column, Player, ListInterm, ListOfPositions):-
	isPlayer(GameState, Row, Column, Player),
	append(ListInterm, [Row-Column], NewList),
	nextPosition(Row, Column, Size, NextRow, NextColumn),
	getPlayerInMatrix(GameState, Size, NextRow, NextColumn, Player, NewList, ListOfPositions).

getPlayerInMatrix(GameState, Size, Row, Column, Player, ListInterm, ListOfPositions):-
	nextPosition(Row, Column, Size, NextRow, NextColumn),
	getPlayerInMatrix(GameState, Size, NextRow, NextColumn, Player, ListInterm, ListOfPositions).

getAllPossibleMoves(GameState, Size, Player, Positions, ListOfPossibleMoves):-
	getAllPossibleMoves(GameState, Size, Player, Positions, [], ListOfPossibleMoves).

getAllPossibleMoves(_, _, _, [], ListOfPossibleMoves, ListOfPossibleMoves).
getAllPossibleMoves(GameState, Size, Player, [Row-Column|PosRest], ListInterm, ListOfPossibleMoves):-
	checkMove(GameState, Size, Row, Column, Player, Moves),
	appendMoves(Row-Column, Moves, CurrentMoves),
	appendNotEmpty(ListInterm, CurrentMoves, NewList),
	getAllPossibleMoves(GameState, Size, Player, PosRest, NewList, ListOfPossibleMoves), !.

nextPosition(Row, Column, Length, NextRow, NextColumn):-
    Column1 is Column + 1,
    Column1 \== Length,
    NextColumn is Column1, 
    NextRow is Row.
nextPosition(Row, Column, Length, NextRow, NextColumn):-
    Column1 is Column + 1,
    Column1 == Length, 
    NextColumn is 0,
    NextRow is Row + 1.

checkEndPosition(Row, Column, Size):-
	Row is Size, Column is 0.

countElement(_, [], 0).
countElement(Element, [H|T], Count):-
	Element \== H,
	countElement(Element, T, Count).

countElement(Element, [H|T], Count):-
	Element == H,
	countElement(Element, T, Count1),
	Count is Count1 + 1.

% Receives [4,3,4,3,0,0] and returns 4
% [0,1,0,0,1,4,2] returns 3
% Returns in Result the longest sequence not formed by 0
sequenceOfNon0(List, Result):-
    sequenceOfNon0(List, 0, 0, Result).

sequenceOfNon0([], Counter, MaxLength, Counter):-
    Counter > MaxLength.
sequenceOfNon0([], _, MaxLength, MaxLength).
sequenceOfNon0([0|Rest], Counter, MaxLength, Result):-
    Counter > MaxLength, 
    sequenceOfNon0(Rest, 0, Counter, Result).
sequenceOfNon0([0|Rest], _, MaxLength, Result):- 
    sequenceOfNon0(Rest, 0, MaxLength, Result).
sequenceOfNon0([_|Rest], Counter, MaxLength, Result):-
    Counter1 is Counter+1,
    sequenceOfNon0(Rest, Counter1, MaxLength, Result).
%https://stackoverflow.com/questions/8519203/prolog-replace-an-element-in-a-list-at-a-specified-index
%replaceInList(+Index, +List, +Element, -NewList)
/*
Replaces an element in a List at a specified Index with Element
*/
replaceInList(Index, List, Element, NewList) :-
	nth0(Index, List, _, Rest),
	nth0(Index, NewList, Element, Rest).

%replaceInMatrix(+Matrix, +Row, +Column, +Value, -FinalMatrix)
/*
Replaces Value in given Row and Column of the Matrix
*/
replaceInMatrix(Matrix, Row, Column, Value, FinalMatrix) :-
	nth0(Row, Matrix, RowsList),
	replaceInList(Column, RowsList, Value, NewRows),
	replaceInList(Row, Matrix, NewRows, FinalMatrix).

%getValueFromMatrix(+Matrix, +Row, +Column, -Value)
/*
Gets Value in given Row and Column of the Matrix
*/
getValueFromMatrix(Matrix, Row, Column, Value) :-
	nth0(Row, Matrix, RowList),
	nth0(Column, RowList, Value).

%get_letter(+Row, -Letter)
/*
Gets Letter corresponding to the given Row index
*/
get_letter(Row, Letter) :-
	NewRow is Row + 65,
	char_code(Letter, NewRow).

%get_letter(+Column, -Number)
/*
Gets Number corresponding to the given Column index
*/
get_number(Column, Number) :-
	NewColumn is Column + 49,
	char_code(Number, NewColumn).

%enterContinue/0
/*
Waits for an Enter press
*/
enterContinue:-
	write('\nPress ENTER to continue.'),
    skip_line.

%isEmpty(+List)
/*
Checks if List is empty
*/
isEmpty([]).

%appendNotEmpty(+L1,+L2,-L12)
/*
If given L2 list is not empty, append it to L1 and result is L12
Base case, if L2 is an empty list then the result is L1
*/
appendNotEmpty(L1, [], L1).
appendNotEmpty(L1, L2, L12):-
	append(L1, L2, L12).

%appendMoves(+Pos,+Moves,-RetList)
/*
Return on RetList a list of sublists with for each position moves like [PositionRow-PosionColumn, MoveRow-MoveColumn], ...]
*/
appendMoves(_, [], []).
appendMoves(Pos, Moves, RetList):-
	appendMoves(Pos, Moves, [], RetList).

appendMoves(Pos, [], RetList, RetList).
appendMoves(Pos, [Move | T], AuxList, RetList):-
	CompleteMove = [Pos, Move],
	append([CompleteMove], AuxList, NewAuxList),
	appendMoves(Pos, T, NewAuxList, RetList).

%printPosition(+Position)
/*
Prints a given position (represented as a Row-Column)
*/
printPosition([]).
printPosition(Row-Column):-
	get_letter(Row, RowL),
	get_number(Column, ColumnL),
	format(" ~w~w ", [RowL,ColumnL]).

%printPositionList(+Position)
/*
Prints a list of several Positions (represented as [Position1, Position2, ...])
*/
printPositionsList([]).
printPositionsList([H|T]):-
	printPosition(H),
	printPositionsList(T).

%isEnemy(+Board,+Row,+Column,+Player)
/*
Checks if board value in the given position (row and column) is the current player's enemy
*/
isEnemy(Board, Row, Column, Player) :-
    getValueFromMatrix(Board, Row, Column, Enemy),
    Enemy is -Player.

%printTurn(+Player)
/*
Prints a formated red player turn message
*/
printTurn(1):-
	write('\n > RED(O) turn <\n').

%printTurn(+Player)
/*
Prints a formated blue player turn message
*/
printTurn(-1):-
	write('\n > BLUE(X) turn <\n').

%printWinner(+Player)
/*
Prints a formated red player win message
*/
printWinner(1):-
	write('\n!!! RED(O) player won !!!\n\n').

%printWinner(+Player)
/*
Prints a formated blue player win message
*/
printWinner(-1):-
	write('\n!!! BLUE(X) player won !!!\n\n').

%getSelAndMovePosition(+Move,-SelPosition,-MovPosition)
/*
Returns the current and the moving positions
*/
getSelAndMovePosition(Move, SelPosition, MovPosition):-
	nth0(0, Move, SelPosition),
	nth0(1, Move, MovPosition).

%getPlayerInMatrix(+GameState,+Size,+Player,-ListOfPositions)
/*
Retuns on ListOfMoves the all the positions where exists a current player's piece
*/
getPlayerInMatrix(GameState, Size, Player, ListOfPositions) :-
	getPlayerInMatrix(GameState, Size, 0, 0, Player, [], ListOfPositions), !.

%When the position is Size-0, it stops (end of the board)
getPlayerInMatrix(_, Size, Row, Column, _, ListOfPositions, ListOfPositions):-
	checkEndPosition(Row, Column, Size).

%If it is the player is that cell, then append that possition and pass to the next position
getPlayerInMatrix(GameState, Size, Row, Column, Player, ListInterm, ListOfPositions):-
	getValueFromMatrix(GameState, Row, Column, Player),
	append(ListInterm, [Row-Column], NewList),
	nextPosition(Row, Column, Size, NextRow, NextColumn),
	getPlayerInMatrix(GameState, Size, NextRow, NextColumn, Player, NewList, ListOfPositions).

%If it is not the player in that cell, avance to the next position
getPlayerInMatrix(GameState, Size, Row, Column, Player, ListInterm, ListOfPositions):-
	nextPosition(Row, Column, Size, NextRow, NextColumn),
	getPlayerInMatrix(GameState, Size, NextRow, NextColumn, Player, ListInterm, ListOfPositions).

%nextPosition(+Row,+Column,+Length,-NextRowm-NextColumn)
/*
If the end of the column has not been reached, avance to the next collumn, remaining in the same row
*/
nextPosition(Row, Column, Length, NextRow, NextColumn):-
    Column1 is Column + 1,
    Column1 \== Length,
    NextColumn is Column1, 
    NextRow is Row.
	
%nextPosition(+Row,+Column,+Length,-NextRowm-NextColumn)
/*
If the end of the column has been reached, avance to the next row, starting by the first collumn(0)
*/
nextPosition(Row, Column, Length, NextRow, NextColumn):-
    Column1 is Column + 1,
    Column1 == Length, 
    NextColumn is 0,
    NextRow is Row + 1.

%checkEndPosition(+Row,+Column,+Size)
/*
If the row is equal to size, then the board's end was reached
*/
checkEndPosition(Row, Column, Size):-
	Row is Size, Column is 0.

%countElement(+Element, +List, -Count)
%Counts ocurrences of an element in a list
/*
Base case, empty list, Count of anything is 0. 
*/
countElement(_, [], 0).

/*
The Element in the head of the list is the same as what we want to count,
add 1 to the recursive Count.
*/
countElement(Element, [Element|T], Count):-
	countElement(Element, T, Count1),
	Count is Count1 + 1.

/*
The element in the head of the list is different, keep old Count
*/
countElement(Element, [H|T], Count):-
	Element \== H,
	countElement(Element, T, Count).


%sequenceOfNon0(+List, -Result)
/*
Returns in Result the length of the longest sequence from List not formed by 0
*/
sequenceOfNon0(List, Result):-
    sequenceOfNon0(List, 0, 0, Result), !.

/*
Base case,
Result will be the greater number between the current 0 Sequence or
the MaxSequence achieved
*/
sequenceOfNon0([], Sequence, MaxSequence, Result):-
    Result is max(Sequence, MaxSequence).

/*
The number in the head of the list is 0, current MaxSequence will be 
the greater number between current Sequence or previous MaxSequence achieved
*/
sequenceOfNon0([0|Rest], Sequence, MaxSequence, Result):-
	NewMaxSequence is max(Sequence, MaxSequence),
    sequenceOfNon0(Rest, 0, NewMaxSequence, Result).

/*
The number in the head of the list is diferent from 0, increase current Sequence counter
*/
sequenceOfNon0([H|Rest], Sequence, MaxSequence, Result):-
	H \== 0,
    Sequence1 is Sequence+1,
    sequenceOfNon0(Rest, Sequence1, MaxSequence, Result).


%floodFill(+Matrix, +Size, +Row, +Column, +PreviousCharacter, +NewCharacter, -FinalMatrix)
/*
A recursive function to replace 
PreviousCharacter at position (Row, Column)
and all surrounding pixels of position
with NewCharacter.
Returns in FinalMatrix the floodfilled matrix
*/
floodFill(Matrix, Size, Row, Column, PrevC, NewC, FinalMatrix):-
    Row >= 0, Row < Size, Column >= 0, Column < Size,
    getValueFromMatrix(Matrix, Row, Column, PrevC),
    replaceInMatrix(Matrix, Row, Column, NewC, UpdatedMatrix),
    Row1 is Row+1, Row2 is Row-1, Col1 is Column+1, Col2 is Column-1,
    floodFill(UpdatedMatrix, Size, Row1, Column, PrevC, NewC, M1) ,
    floodFill(M1, Size, Row2, Column, PrevC, NewC, M2) ,
    floodFill(M2, Size, Row, Col1, PrevC, NewC, M3) , 
    floodFill(M3, Size, Row, Col2, PrevC, NewC, FinalMatrix).

/*
If previous predicate failed because position is out of matrix boundaries 
or char in the current position isn't previous char
returns the given Matrix
*/
floodFill(Matrix, _, _, _, _, _, Matrix).


%tryFloodFill(+Matrix, +Size, +Row, +Column, +FinalMatrix)    
/*
If given position is an empty space (0),
floodfill the matrix replacing empty spaces(0) with '?'(2)
Returns in FinalMatrix the floodfilled matrix
*/
tryFloodFill(Matrix, Size, Row, Column, FinalMatrix):-
    getValueFromMatrix(Matrix, Row, Column, 0),
    floodFill(Matrix, Size, Row, Column, 0, 2, FinalMatrix), !.

%botWait(+PlayerType,+EnemyType)
/*
In case it is a bot playing, the program sleeps for 1 second when this predicate is called
*/
botWait(PlayerType, EnemyType) :-
	(
		(PlayerType == 'Easy'; PlayerType == 'Normal'),
		(EnemyType == 'Easy'; EnemyType == 'Normal')
	),
	sleep(1).

%In case it is not a bot playing is does nothing
botWait(_, _).
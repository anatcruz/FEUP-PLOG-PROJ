%board on it's initial state
initialGameState([
    [1,-1,1,-1,1,-1,1,-1],
    [-1,1,-1,1,-1,1,-1,1],
    [1,-1,1,-1,1,-1,1,-1],
    [-1,1,-1,1,-1,1,-1,1],
    [1,-1,1,-1,1,-1,1,-1],
    [-1,1,-1,1,-1,1,-1,1],
    [1,-1,1,-1,1,-1,1,-1],
    [-1,1,-1,1,-1,1,-1,1]
]).

%board on a mid game state
midGameState([
    [1,-1,-1,0,1,0,1,-1],
    [0,-1,0,0,0,1,0,-1],
    [-1,1,1,0,-1,0,1,-1],
    [0,0,-1,1,0,0,-1,0],
    [0,1,1,1,1,-1,1,0],
    [0,-1,-1,0,0,0,0,1],
    [1,-1,1,-1,1,0,-1,0],
    [-1,1,-1,-1,0,-1,-1,1]
]).

%board on a final game state, representing 1 win
finalGameState([
    [1,-1,-1,0,1,0,1,-1],
    [0,-1,0,0,0,1,0,-1],
    [-1,1,1,0,-1,0,-1,0],
    [0,0,-1,1,0,0,-1,0],
    [0,-1,0,1,1,1,0,0],
    [0,1,0,0,0,0,0,1],
    [0,0,0,0,-1,0,-1,0],
    [-1,1,1,-1,0,0,-1,0]
]).

testState([
    [0,-1,-1,0,1,0,1,-1],
    [0,-1,0,0,0,-1,0,-1],
    [-1,1,1,0,-1,0,-1,0],
    [0,0,-1,0,0,0,-1,0],
    [0,-1,0,1,1,0,0,1],
    [0,0,0,0,0,0,0,1],
    [0,0,1,0,1,0,1,1],
    [1,1,1,1,1,1,1,1]
]).

%generate GameState with given Size
generateBoard(GameState, Size):-
    buildBoard([], GameState, Size, 0, 1).

%create a board with given Size
buildBoard(FinalBoard, FinalBoard, Size, Size, _).
buildBoard(InitialBoard, FinalBoard, Size, RowIndex, Cell):-
    buildRow([], BuiltRow, Size, 0, Cell),
    append(InitialBoard, BuiltRow, UpdatedBoard),
    NewRowIndex is RowIndex+1,
    NewCell is -Cell,
    buildBoard(UpdatedBoard, FinalBoard, Size, NewRowIndex, NewCell).

%create a board row based on board Size and row initial Cell
buildRow(Row, BuiltRow, Size, Size, _):- BuiltRow=[Row].
buildRow(Row, BuiltRow, Size, ColIndex, Cell):-
    append(Row, [Cell], UpdatedRow),
    NewColIndex is ColIndex+1,
    NewCell is -Cell,
    buildRow(UpdatedRow, BuiltRow, Size, NewColIndex, NewCell).

character(0,' '). %character for an empty space representing a piece removed
character(-1,'X'). %character representing the blue player piece
character(1,'O'). %character representing the red player piece
character(2,'?'). %auxiliar character for floodfill, filling empty spaces

/*prints the board with the columns indicator
prints a line of X's on the top of the board representing the top side of the blue player 
*/
printBoard(Board) :-
    length(Board, Size),
    nl,
    printBoardHeader(Size),
    printMatrix(Board, 0, Size),
    printBoardBottom(Size).

printBoardHeader(Size) :-
    write('       '),
    printHeaderNumbers(1, Size), /* Columns indicator */
    write('       '),
    printSeparator(1, Size),
    write('       '),
    printXLine(1, Size), /* Print Xs on the top side */
    printBoardRowSeparator(Size).

printHeaderNumbers(Current, Size) :- Current=:=Size+1, write('|\n').
printHeaderNumbers(Current, Size) :-
    write('| '), write(Current), write(' '), CurrentN is Current+1,
    printHeaderNumbers(CurrentN, Size).

printSeparator(Current, Size) :- Current=:=Size+1, write('+\n').
printSeparator(Current, Size) :-
    write('+---'), CurrentN is Current+1,
    printSeparator(CurrentN, Size).

printXLine(Current, Size) :- Current=:=Size+1, write(' \n').
printXLine(Current, Size) :-
    write('  X '), CurrentN is Current+1,
    printXLine(CurrentN, Size).

printBoardRowSeparator(Size) :-
    write('---+   '),
    printSeparator(1, Size).

%prints a line of X's on the bottom of the board representing the bottom side of the blue player 
printBoardBottom(Size) :-
    write('       '),
    printXLine(1, Size). 


printMatrix([], _, _).
/*prints the matrix representing the board with the row indicators
prints a line of O's on the left side of the board representing the left side of the red player
*/
printMatrix([Head|Tail], N, Size):-
    write(' '),
    get_letter(N, Row), % Row indicator
    write(Row),
    write(' | O | '),  % Print Os on the left side
    printRow(Head),
    nl,
    printBoardRowSeparator(Size),
    N1 is N + 1,
    printMatrix(Tail, N1, Size).

%prints a line of O's on the right side of the board representing the right side of the red player
printRow([]):-
    write('O'). 

%prints a list representing a matrix row
printRow([Head|Tail]) :-
    character(Head, S),
    write(S),
    write(' | '),
    printRow(Tail).
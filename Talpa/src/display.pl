%board on it's initial state
initialGameState([
    [red,blue,red,blue,red,blue,red,blue],
    [blue,red,blue,red,blue,red,blue,red],
    [red,blue,red,blue,red,blue,red,blue],
    [blue,red,blue,red,blue,red,blue,red],
    [red,blue,red,blue,red,blue,red,blue],
    [blue,red,blue,red,blue,red,blue,red],
    [red,blue,red,blue,red,blue,red,blue],
    [blue,red,blue,red,blue,red,blue,red]
]).

%board on a mid game state
midGameState([
    [red,blue,blue,empty,red,empty,red,blue],
    [empty,blue,empty,empty,empty,red,empty,blue],
    [blue,red,red,empty,blue,empty,red,blue],
    [empty,empty,blue,red,empty,empty,blue,empty],
    [empty,red,red,red,red,blue,red,empty],
    [empty,blue,blue,empty,empty,empty,empty,red],
    [red,blue,red,blue,red,empty,blue,empty],
    [blue,red,blue,blue,empty,blue,blue,red]
]).

%board on a final game state, representing red win
finalGameState([
    [red,blue,blue,empty,red,empty,red,blue],
    [empty,blue,empty,empty,empty,red,empty,blue],
    [blue,red,red,empty,blue,empty,blue,empty],
    [empty,empty,blue,red,empty,empty,blue,empty],
    [empty,blue,empty,red,red,red,empty,empty],
    [empty,red,empty,empty,empty,empty,empty,red],
    [empty,empty,empty,empty,blue,empty,blue,empty],
    [blue,red,red,blue,empty,empty,blue,empty]
]).

symbol(empty,' '). %symbol for an empty space representing a piece removed
symbol(blue,'X'). %symbol representing the blue player
symbol(red,'O'). %symbol rrepresenting the red player

%rows
letter(0, 'A').
letter(1, 'B').
letter(2, 'C').
letter(3, 'D').
letter(4, 'E').
letter(5, 'F').
letter(6, 'G').
letter(7, 'H').

/*prints the board with the columns indicator
prints a line of X's on the top of the board representing the top side of the blue player 
*/
printBoard(X) :-
    nl,
    write('       | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |\n'), /* Columns indicator */
    write('       +---+---+---+---+---+---+---+---+\n'),
    write('         X   X   X   X   X   X   X   X  \n'), /* Print Xs on the top side */
    write('---+   +---+---+---+---+---+---+---+---+\n'),
    printMatrix(X, 0).

%prints a line of X's on the bottom of the board representing the bottom side of the blue player 
printMatrix([], 8):-
    write('         X   X   X   X   X   X   X   X  \n'). 

/*prints the matrix representing the board with the row indicators
prints a line of O's on the left side of the board representing the left side of the red player
*/
printMatrix([Head|Tail], N):-
    write(' '),
    letter(N, L), /* Row indicator */
    write(L),
    write(' | O | '),  /* Print Os on the left side */
    printRow(Head),
    write('\n---+   +---+---+---+---+---+---+---+---+\n'),
    N1 is N + 1,
    printMatrix(Tail, N1).

%prints a line of O's on the right side of the board representing the right side of the red player
printRow([]):-
    write('O'). 

%prints a list representing a matrix row
printRow([Head|Tail]) :-
    symbol(Head, S),
    write(S),
    write(' | '),
    printRow(Tail).
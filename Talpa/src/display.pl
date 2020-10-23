initBoard([
            [red,blue,red,blue,red,blue,red,blue],
            [blue,red,blue,red,blue,red,blue,red],
            [red,blue,red,blue,red,blue,red,blue],
            [blue,red,blue,red,blue,red,blue,red],
            [red,blue,red,blue,red,blue,red,blue],
            [blue,red,blue,red,blue,red,blue,red],
            [red,blue,red,blue,red,blue,red,blue],
            [blue,red,blue,red,blue,red,blue,red]
]).

symbol(empty,' ').
symbol(blue,'X').
symbol(red,'O').

letter(0, 'A').
letter(1, 'B').
letter(2, 'C').
letter(3, 'D').
letter(4, 'E').
letter(5, 'F').
letter(6, 'G').
letter(7, 'H').

printBoard(X) :-
    nl,
    write('       | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |\n'), /* Columns indicator */
    write('       +---+---+---+---+---+---+---+---+\n'),
    write('         X   X   X   X   X   X   X   X  \n'), /* Print Xs on the top side */
    write('---+   +---+---+---+---+---+---+---+---+\n'),
    printMatrix(X, 0).

printMatrix([], 8):-
    write('         X   X   X   X   X   X   X   X  \n'). /* Print Xs on the bottom side */

printMatrix([Head|Tail], N):-
    write(' '),
    letter(N, L), /* Row indicator */
    write(L),
    write(' | O | '),  /* Print Os on the left side */
    printLine(Head),
    write('\n---+   +---+---+---+---+---+---+---+---+\n'),
    N1 is N + 1,
    printMatrix(Tail, N1).


printLine([]):-
    write('O'). /* print Os on the right side */

printLine([Head|Tail]) :-
    symbol(Head, S),
    write(S),
    write(' | '),
    printLine(Tail).
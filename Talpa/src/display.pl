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

finalGameState([
    [red,blue,blue,empty,red,empty,red,blue],
    [empty,blue,empty,empty,empty,red,empty,blue],
    [blue,red,red,empty,blue,empty,blue,empty],
    [empty,empty,blue,red,empty,empty,blue,empty],
    [empty,blue,empty,red,red,red,empty,empty],
    [empty,red,empty,empty,empty,empty,empty,red],
    [empty,empty,empty,empty,blue,empty,blue,empty],
    [blue,red,red,blue,empty,empty,blue,empty]
]). /* RED victory */

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
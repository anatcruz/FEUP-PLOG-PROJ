displayinitialBoard([
            [red,blue,red,blue,red,blue,red,blue],
            [blue,red,blue,red,blue,red,blue,red],
            [red,blue,red,blue,red,blue,red,blue],
            [blue,red,blue,red,blue,red,blue,red],
            [red,blue,red,blue,red,blue,red,blue],
            [blue,red,blue,red,blue,red,blue,red],
            [red,blue,red,blue,red,blue,red,blue],
            [blue,red,blue,red,blue,red,blue,red]
]).

symbol(empty,S) :- S='.'.
symbol(blue,S) :- S='X'.
symbol(red,S) :- S='O'.

letter(1, L) :- L='A'.
letter(2, L) :- L='B'.
letter(3, L) :- L='C'.
letter(4, L) :- L='D'.
letter(5, L) :- L='E'.
letter(6, L) :- L='F'.
letter(7, L) :- L='G'.
letter(8, L) :- L='H'.

printBoard(X) :-
    nl,
    write('       | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |\n'),
    write('       +---+---+---+---+---+---+---+---+\n'),
    write('         X   X   X   X   X   X   X   X  \n'),
    write('---+   +---+---+---+---+---+---+---+---+\n'),
    printMatrix(X, 1).

printMatrix([], 9):-
    write('         X   X   X   X   X   X   X   X  \n').

printMatrix([Head|Tail], N):-
    letter(N, L),
    write(' '),
    write(L),
    N1 is N + 1,
    write(' | O | '),
    printLine(Head),
    write('\n---+   +---+---+---+---+---+---+---+---+\n'),
    printMatrix(Tail, N1).


printLine([]):-
    write('O').

printLine([Head|Tail]) :-
    symbol(Head, S),
    write(S),
    write(' | '),
    printLine(Tail).

play :-
    displayinitialBoard(Board),
    printBoard(Board).
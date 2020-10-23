readRow(Row) :-
    write('  -> Row    '),
    read(Row).

readColumn(Column) :-
    write('  -> Column '),
    read(Column).

validateRow('A', 0).
validateRow('B', 1).
validateRow('C', 2).
validateRow('D', 3).
validateRow('E', 4).
validateRow('F', 5).
validateRow('G', 6).
validateRow('H', 7).
validateRow(_Row, NewRow) :-
    write('ERROR! That row is not valid!\n'),
    readRow(Input),
    validateRow(Input, NewRow).

validateColumn(1, 0).
validateColumn(2, 1).
validateColumn(3, 2).
validateColumn(4, 3).
validateColumn(5, 4).
validateColumn(6, 5).
validateColumn(7, 6).
validateColumn(8, 7).
validateColumn(_Column, NewColumn) :-
    write('ERROR! That column is not valid!\n'),
    readColumn(Input),
    validateColumn(Input, NewColumn).

/* Lê a linha e verifica a validez no tabuleiro*/
manageRow(NewRow) :-
    readRow(Row),
    validateRow(Row, NewRow).

/* Lê a coluna e verifica a validez no tabuleiro*/
manageColumn(NewColumn) :-
    readColumn(Column),
    validateColumn(Column, NewColumn).


selectPiece(Board, FinalBoard, Player) :-
    write('\nSelect pice:\n'),
    manageRow(SelRow),
    manageColumn(SelColumn),
    replaceInMatrix(Board, SelRow, SelColumn, empty, FinalBoard).

movePiece(Board, FinalBoard, Player) :-
    write('\nMove to:\n'),
    manageRow(SelRow),
    manageColumn(SelColumn),
    replaceInMatrix(Board, SelRow, SelColumn, Player, FinalBoard).
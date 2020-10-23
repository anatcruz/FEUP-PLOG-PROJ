readRow(Row) :-
    write('  -> Row    '),
    read(Row).

readColumn(Column) :-
    write('  -> Column '),
    read(Column).

validateRow('A', 1).

validateRow('B', 2).
    
validateRow('C', 3).
    
validateRow('D', 4).
    
validateRow('E', 5).
    
validateRow('F', 6).

validateRow('G', 7).

validateRow('H', 8).

validateRow(_Row, NewRow) :-
    write('ERROR! That row is not valid!\n'),
    readRow(Input),
    validateRow(Input, NewRow).

validateColumn(1, 1).

validateColumn(2, 2).

validateColumn(3, 3).

validateColumn(4, 4).

validateColumn(5, 5).

validateColumn(6, 6).

validateColumn(7, 7).

validateColumn(8, 8).

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
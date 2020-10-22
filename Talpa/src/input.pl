readRow(Row) :-
    write('  -> Row    '),
    read(Row).

readColumn(Column) :-
    write('  -> Column '),
    read(Column).

validateRow('A', NewRow) :-
    NewRow = 1.

validateRow('B', NewRow) :-
    NewRow = 2.
    
validateRow('C', NewRow) :-
    NewRow = 3.
    
validateRow('D', NewRow) :-
    NewRow = 4.
    
validateRow('E', NewRow) :-
    NewRow = 5.
    
validateRow('F', NewRow) :-
    NewRow = 6.

validateRow('G', NewRow) :-
    NewRow = 7.

validateRow('H', NewRow) :-
    NewRow = 8.

validateRow(_Row, NewRow) :-
    write('ERROR! That row is not valid!\n'),
    readRow(Input),
    validateRow(Input, NewRow).

validateColumn(1, NewColumn) :-
    NewColumn = 1.

validateColumn(2, NewColumn) :-
    NewColumn = 2.

validateColumn(3, NewColumn) :-
    NewColumn = 3.

validateColumn(4, NewColumn) :-
    NewColumn = 4.

validateColumn(5, NewColumn) :-
    NewColumn = 5.

validateColumn(6, NewColumn) :-
    NewColumn = 6.

validateColumn(7, NewColumn) :-
    NewColumn = 7.

validateColumn(8, NewColumn) :-
    NewColumn = 8.

validateColumn(_Column, NewColumn) :-
    write('ERROR! That column is not valid!\n'),
    readColumn(Input),
    validateColumn(Input, NewColumn).

manageRow(NewRow) :-
    readRow(Row),
    validateRow(Row, NewRow).

manageColumn(NewColumn) :-
    readColumn(Column),
    validateColumn(Column, NewColumn).
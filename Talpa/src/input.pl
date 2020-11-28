%reads Row input code, ignoring newlines (ascii code 10)
readRow(Row) :-
    write('  -> Row    '),
    get_code(Row),
    Row\=10.

%reads Column input code, ignoring newlines (ascii code 10)
readColumn(Column) :-
    write('  -> Column '),
    get_code(Column),
    Column\=10.

validateRow(RowInput, NewRow, Size) :-
    peek_char('\n'),
    (
        (
            RowInput < 97,
            NewRow is RowInput - 65
        );
        (
            RowInput >= 97,
            NewRow is RowInput - 97
        )
    ),
    Valid is Size-1,
    between(0, Valid, NewRow),
    skip_line.

validateRow(_, _, _) :-
    write('\n! That row is not valid. Choose again !\n\n'), skip_line, fail.

validateColumn(ColumnInput, NewColumn, Size) :-
    peek_char('\n'),
    NewColumn is ColumnInput - 49,
    Valid is Size-1,
    between(0, Valid, NewColumn),
    skip_line.

validateColumn(_, _, _) :-
    write('\n! That column is not valid. Choose again !\n\n'), skip_line, fail.

%reads the input Row and checks if it is between the limits of the board
manageRow(NewRow, Size) :-
    repeat,
    readRow(Row),
    validateRow(Row, NewRow, Size).

%reads the input Column and checks if it is between the limits of the board
manageColumn(NewColumn, Size) :-
    repeat,
    readColumn(Column),
    validateColumn(Column, NewColumn, Size).

manageInputs(NewRow, NewColumn, Size) :-
    manageRow(NewRow, Size),
    manageColumn(NewColumn, Size), !.

/*the player selects the piece he wants to move
the inputs are checked if they are within the boundaries of the board and if the player is selecting his own piece
*/
selectPiecePosition(Board, Size, Player, SelRow, SelColumn):-
    repeat,
    write('\nSelect piece:\n'),
    manageInputs(InputRow, InputColumn, Size),
    validateContent(Board, Size, InputRow, InputColumn, Player, SelRow, SelColumn).

/*the player selects the position for the piece he wants to move
the inputs are checked if they are within the boundaries of the board
*/
movePiecePosition(Board, Size, Player, SelRow, SelColumn, FinalRow, FinalColumn):-
    repeat,
    write('\nMove to:\n'),
    manageInputs(MovRow, MovColumn, Size),
    verifyOrtMove(Board, Player, SelRow, SelColumn, MovRow, MovColumn, FinalRow, FinalColumn).

removePiecePosition(Board, Size, Player, SelRow, SelColumn):-
    repeat,
    write('\nRemove piece:\n'),
    manageInputs(InputRow, InputColumn, Size),
    verifyPlayer(Board, Size, InputRow, InputColumn, Player, SelRow, SelColumn).

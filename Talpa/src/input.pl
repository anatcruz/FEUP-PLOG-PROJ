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
    write('\nERROR! That row is not valid!\n\n'), skip_line, fail.

validateColumn(ColumnInput, NewColumn, Size) :-
    peek_char('\n'),
    NewColumn is ColumnInput - 49,
    Valid is Size-1,
    between(0, Valid, NewColumn),
    skip_line.

validateColumn(_, _, _) :-
    write('\nERROR! That column is not valid!\n\n'), skip_line, fail.

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

/*the player selects the piece he wants to move
the inputs are checked if they are within the boundaries of the board and if the player is selecting his own piece
on the board the piece the player wants to move is replaced by an empty space
then the piece is moved
*/
selectPiece(Board, Size, SelBoard, Player, SelRow, SelColumn) :-
    write('\nSelect piece:\n'),
    manageRow(InputRow, Size),
    manageColumn(InputColumn, Size),
    validateContent(Board, Size, InputRow, InputColumn, Player, SelRow, SelColumn),
    replaceInMatrix(Board, SelRow, SelColumn, 0, SelBoard).

/*the player selects the position for the piece he wants to move
the inputs are checked if they are within the boundaries of the board
it checks if the moving to position is valid
then the piece in the moving to position is replaced by the player
*/
movePiece(SelBoard, Size, FinalBoard, Player, SelRow, SelColumn) :-
    write('\nMove to:\n'),
    manageRow(MovRow, Size),
    manageColumn(MovColumn, Size),
    verifyOrtMove(SelBoard, Size, Player, SelRow, SelColumn, MovRow, MovColumn, FinalRow, FinalColumn),
    replaceInMatrix(SelBoard, FinalRow, FinalColumn, Player , FinalBoard).

removePiece(Board, Size, FinalBoard, Player) :-
    write('\nRemove piece:\n'),
    manageRow(InputRow, Size),
    manageColumn(InputColumn, Size),
    verifyPlayer(Board, Size, InputRow, InputColumn, Player, SelRow, SelColumn),
    replaceInMatrix(Board, SelRow, SelColumn, 0, FinalBoard).

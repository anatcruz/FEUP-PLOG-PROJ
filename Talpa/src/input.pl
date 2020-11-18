%reads Row input
readRow(Row) :-
    write('  -> Row    '),
    get_code(Row).

%reads Column input
readColumn(Column) :-
    write('  -> Column '),
    get_code(Column).

validateRow(RowInput, NewRow, Size) :-
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
    between(0, Valid, NewRow).

validateRow(_, _, _) :-
    write('ERROR! That row is not valid!\n'), fail.

validateColumn(ColumnInput, NewColumn, Size) :-
    NewColumn is ColumnInput - 49,
    Valid is Size-1,
    between(0, Valid, NewColumn),
    skip_line.

validateColumn(_, _, _) :-
    write('ERROR! That column is not valid!\n'), skip_line, fail.

%reads the input Row and checks if it is between the limits of the board
manageRow(NewRow, Size) :-
    repeat,
    readRow(Row),
    skip_line,
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
selectPiece(Board, Size, SelBoard, Player, InputRow, InputColumn) :-
    write('\nSelect pice:\n'),
    manageRow(SelRow, Size),
    manageColumn(SelColumn, Size),
    validateContent(Board, Size, SelRow, SelColumn, Player, InputRow, InputColumn),
    replaceInMatrix(Board, InputRow, InputColumn, 0, SelBoard).

/*the player selects the position for the piece he wants to move
the inputs are checked if they are within the boundaries of the board
it checks if the moving to position is valid
then the piece in the moving to position is replaced by the player
*/
movePiece(SelBoard, Size, FinalBoard, Player, InputRow, InputColumn) :-
    write('\nMove to:\n'),
    manageRow(MovRow, Size),
    manageColumn(MovColumn, Size),
    verifyOrtMove(SelBoard, Size, Player, InputRow, InputColumn, MovRow, MovColumn, FinalRow, FinalColumn),
    replaceInMatrix(SelBoard, FinalRow, FinalColumn, Player , FinalBoard).

removePiece(Board, Size, FinalBoard, Player) :-
    write('\nSelect pice:\n'),
    manageRow(SelRow, Size),
    manageColumn(SelColumn, Size),
    verifyPlayer(Board, Size, SelRow, SelColumn, Player, InputRow, InputColumn),
    replaceInMatrix(Board, InputRow, InputColumn, 0, FinalBoard).
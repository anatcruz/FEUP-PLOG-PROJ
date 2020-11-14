%reads Row input
readRow(Row) :-
    write('  -> Row    '),
    get_char(Row).

%reads Column input
readColumn(Column) :-
    write('  -> Column '),
    get_code(Column).

validateRow(RowInput, NewRow, Size) :-
    (letter(Number, RowInput) ; letter_lower(Number, RowInput)),
    Number < Size, 
    NewRow = Number.


validateRow(RowInput, NewRow, Size) :-
    write('ERROR! That row is not valid!\n'),
    readRow(Input),
    validateRow(Input, NewRow, Size).

column_code(49, 0).
column_code(X, Y) :-
    X1 is X - 1, column_code(X1, Y1), Y is Y1 + 1.

validateColumn(ColumnInput, NewColumn, Size) :-
    peek_char(Char),
    Char == '\n',
    column_code(ColumnInput, Number), 
    Number < Size, NewColumn is Number, skip_line.

validateColumn(_, NewColumn, Size) :-
    write('ERROR! That column is not valid!\n'), 
    readColumn(Column),
    validateColumn(Column, NewColumn, Size).

%reads the input Row and checks if it is between the limits of the board
manageRow(NewRow, Size) :-
    readRow(Row),
    skip_line,
    validateRow(Row, NewRow, Size).

%reads the input Column and checks if it is between the limits of the board
manageColumn(NewColumn, Size) :-
    readColumn(Column),
    validateColumn(Column, NewColumn, Size).

/*the player selects the piece he wants to move
the inputs are checked if they are within the boundaries of the board and if the player is selecting his own piece
on the board the piece the player wants to move is replaced by an empty space
then the piece is moved
*/
selectPiece(Board, FinalBoard, Player) :-
    length(Board, Size),
    write('\nSelect pice:\n'),
    manageRow(SelRow, Size),
    manageColumn(SelColumn, Size),
    validateContent(Board, Size, SelRow, SelColumn, Player, FinalRow, FinalColumn),
    replaceInMatrix(Board, FinalRow, FinalColumn, 0, SelBoard),
    movePiece(SelBoard, Size, FinalBoard, Player, FinalRow, FinalColumn).

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
%reads Row input
readRow(Row) :-
    write('  -> Row    '),
    get_char(Row).

%reads Column input
readColumn(Column) :-
    write('  -> Column '),
    get_code(Column).

%rows
letter(0, 'A').
letter(1, 'B').
letter(2, 'C').
letter(3, 'D').
letter(4, 'E').
letter(5, 'F').
letter(6, 'G').
letter(7, 'H').

letter_lower(0, 'a').
letter_lower(1, 'b').
letter_lower(2, 'c').
letter_lower(3, 'd').
letter_lower(4, 'e').
letter_lower(5, 'f').
letter_lower(6, 'g').
letter_lower(7, 'h').

validateRow(RowInput, NewRow, Size) :-
    (letter(Number, RowInput) ; letter_lower(Number, RowInput)),
    Valid is Size-1,
    between(0, Valid, Number),
    NewRow = Number.

validateRow(_, NewRow, Size) :-
    write('ERROR! That row is not valid!\n'), fail.

validateColumn(ColumnInput, NewColumn, Size) :-
    NewColumn is ColumnInput - 49,
    Valid is Size-1,
    between(0, Valid, NewColumn),
    skip_line.

validateColumn(_, NewColumn, Size) :-
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
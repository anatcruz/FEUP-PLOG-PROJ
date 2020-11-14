%reads Row input
readRow(Row) :-
    write('  -> Row    '),
    read(Row).

%reads Column input
readColumn(Column) :-
    write('  -> Column '),
    read(Column).

%checks if the Row selected is between the limits of the board
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

%checks if the Column selected is between the limits of the board
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

%reads the input Row and checks if it is between the limits of the board
manageRow(NewRow) :-
    readRow(Row),
    validateRow(Row, NewRow).

%reads the input Column and checks if it is between the limits of the board
manageColumn(NewColumn) :-
    readColumn(Column),
    validateColumn(Column, NewColumn).

/*the player selects the piece he wants to move
the inputs are checked if they are within the boundaries of the board and if the player is selecting his own piece
on the board the piece the player wants to move is replaced by an empty space
then the piece is moved
*/
selectPiece(Board, FinalBoard, Player) :-
    write('\nSelect pice:\n'),
    manageRow(SelRow),
    manageColumn(SelColumn),
    validateContent(Board, SelRow, SelColumn, Player, FinalRow, FinalColumn),
    replaceInMatrix(Board, FinalRow, FinalColumn, 0, SelBoard),
    movePiece(SelBoard, FinalBoard, Player, FinalRow, FinalColumn).

/*the player selects the position for the piece he wants to move
the inputs are checked if they are within the boundaries of the board
it checks if the moving to position is valid
then the piece in the moving to position is replaced by the player
*/
movePiece(SelBoard, FinalBoard, Player, SelRow, SelColumn) :-
    write('\nMove to:\n'),
    manageRow(MovRow),
    manageColumn(MovColumn),
    verifyOrtMove(SelBoard, Player, SelRow, SelColumn, MovRow, MovColumn, FinalRow, FinalColumn),
    replaceInMatrix(SelBoard, FinalRow, FinalColumn, Player , FinalBoard).
%readRow(+Row)
/*
Reads Row input code, ignoring newlines (ascii code 10)
*/
readRow(Row) :-
    write('  -> Row    '),
    get_code(Row),
    Row\=10.

%readColumn(+Column)
/*
Reads Column input code, ignoring newlines (ascii code 10)
*/
readColumn(Column) :-
    write('  -> Column '),
    get_code(Column),
    Column\=10.

%validateRow(+RowInput,-NewRow,+Size)
/*
Checks if the row input is valid by calculating it's index, converting ascii code to number, being the first row A with index 0
ascii code for A is 65; ascii code for a is 97
the index has to be within the limits of the board
the next char has to be a newline (else 2 chars in input, thus failing)
*/
validateRow(RowInput, NewRow, Size) :-
    peek_char('\n'),
    (
        (   %upper case letter
            RowInput < 97,
            NewRow is RowInput - 65
        );
        (   %lower case letter
            RowInput >= 97,
            NewRow is RowInput - 97
        )
    ),
    Valid is Size-1,
    between(0, Valid, NewRow),
    skip_line.

%validateRow(+RowInput,-NewRow,+Size)
/*
If the verification above fails, then it outputs a error message and the user is asked for a new input
*/
validateRow(_, _, _) :-
    write('\n! That row is not valid. Choose again !\n\n'), skip_line, fail.

%validateColumn(+ColumnInput,-NewColumn,+Size)
/*
Checks if the column input is valid by calculating it's index, converting ascii code to number, being the first collumn 1 index 0
the index has to be within the limits of the board
the next char has to be a newline (else 2 chars in input, thus failing)
*/
validateColumn(ColumnInput, NewColumn, Size) :-
    peek_char('\n'),
    NewColumn is ColumnInput - 49,
    Valid is Size-1,
    between(0, Valid, NewColumn),
    skip_line.

%validateColumn(+ColumnInput,-NewColumn,+Size)
/*
If the verification above fails, then it outputs a error message and the user is asked for a new input
*/
validateColumn(_, _, _) :-
    write('\n! That column is not valid. Choose again !\n\n'), skip_line, fail.

%manageRow(-NewRow, +Size)
/*
Reads the input Row and checks if it is between the limits of the board
*/
manageRow(NewRow, Size) :-
    repeat,
    readRow(Row),
    validateRow(Row, NewRow, Size).

%manageColumn(-NewColumn,+Size)
/*
Reads the input Column and checks if it is between the limits of the board
*/
manageColumn(NewColumn, Size) :-
    repeat,
    readColumn(Column),
    validateColumn(Column, NewColumn, Size).

%manageInputs(-NewRow,-NewColumn,+Size)
/*
Reads and checks both row and column inputs
*/
manageInputs(NewRow, NewColumn, Size) :-
    manageRow(NewRow, Size),
    manageColumn(NewColumn, Size), !.

%selectPiecePosition(+Board,+Size,+Player,-SelRow,-SelColumn)
/*
The player selects the piece he wants to move
the inputs are checked if they are within the boundaries of the board,
if the player is selecting his own piece,
and if there are any move possible for that piece
*/
selectPiecePosition(Board, Size, Player, SelRow, SelColumn):-
    repeat,
    write('\nSelect piece:\n'),
    manageInputs(InputRow, InputColumn, Size),
    validateContent(Board, Size, InputRow, InputColumn, Player, SelRow, SelColumn).

%movePiecePosition(+Board,+Size,+Player,+SelRow,+SelColumn,-FinalRow,-FinalColumn)
/*
The player selects the position for the piece he wants to move
the inputs are checked if they are within the boundaries of the board,
and if the movement is valid
*/
movePiecePosition(Board, Size, Player, SelRow, SelColumn, FinalRow, FinalColumn):-
    repeat,
    write('\nMove to:\n'),
    manageInputs(MovRow, MovColumn, Size),
    verifyOrtMove(Board, Player, SelRow, SelColumn, MovRow, MovColumn, FinalRow, FinalColumn).

%removePiecePosition(+Board,+Size,+Player,-SelRow,-SelColumn)
/*
The player selects the piece to be removed
the inputs are checked if they are within the boundaries of the board,
and if the players selects their own piece
*/
removePiecePosition(Board, Size, Player, SelRow, SelColumn):-
    repeat,
    write('\nRemove piece:\n'),
    manageInputs(InputRow, InputColumn, Size),
    verifyPlayer(Board, Size, InputRow, InputColumn, Player, SelRow, SelColumn).

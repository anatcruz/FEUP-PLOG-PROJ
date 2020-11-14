/*checks if the player is selecting his own piece
if not, then he is asked again to input the position of the piece he wants to move
*/
validateContent(Board, SelRow, SelColumn, Player, FinalRow, FinalColumn) :-
    getValueFromMatrix(Board, SelRow, SelColumn, Value),
    Player is Value,
    verifyPossibleMove(Board, SelRow, SelColumn, Player),
    FinalRow is SelRow, FinalColumn is SelColumn;
    (
        write('\nERROR! You can not play that piece!\n \nSelect piece:\n'),
        manageRow(NewRow),
        manageColumn(NewColumn),
        validateContent(Board, NewRow, NewColumn, Player, FinalRow, FinalColumn)
    ).

verifyPossibleMove(Board, SelRow, SelColumn, Player) :-
    length(Board, Size),
    ((SelRow>0, Row is SelRow-1, getValueFromMatrix(Board, Row, SelColumn, Enemy), Enemy is -Player);
    (SelRow<Size, Row is SelRow+1, getValueFromMatrix(Board, Row, SelColumn, Enemy), Enemy is -Player);
    (SelColumn>0, Column is SelColumn-1, getValueFromMatrix(Board, SelRow, Column, Enemy), Enemy is -Player);
    (SelColumn<Size, Column is SelColumn+1, getValueFromMatrix(Board, SelRow, Column, Enemy), Enemy is -Player)).

/*check if the player is moving his piece correctly
the movements must be orthogonal
when the movement is within the same row, the player can only select the position immediately to the right or left
when the movement is within the same column, the player can only select the position immediately to the top or down
when not given a valid position the player is asked again to write the position to move to
*/
verifyOrtMove(SelBoard, Player, SelRow, SelColumn, MovRow, MovColumn, FinalRow, FinalColumn) :-
    getValueFromMatrix(SelBoard, MovRow, MovColumn, Enemy),
    (
        (MovRow=:=SelRow, (MovColumn=:=SelColumn+1 ; MovColumn=:=SelColumn-1));  /*Same row*/
        (MovColumn=:=SelColumn, (MovRow=:=SelRow+1 ; MovRow=:=SelRow-1)) /*Same column */
    ),
    Enemy is -Player, FinalRow is MovRow, FinalColumn is MovColumn;
    (
        write('\nERROR! That is not a valid move!\n \nMove to:\n'),
        manageRow(NewRow),
        manageColumn(NewColumn),
        verifyOrtMove(SelBoard, Player, SelRow, SelColumn, NewRow, NewColumn, FinalRow, FinalColumn)
    ).

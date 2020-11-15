/*checks if the player is selecting his own piece
if not, then he is asked again to input the position of the piece he wants to move
*/
validateContent(Board, Size, SelRow, SelColumn, Player, FinalRow, FinalColumn) :-
    getValueFromMatrix(Board, SelRow, SelColumn, Value),
    Player is Value,
    verifyPossibleMove(Board, Size, SelRow, SelColumn, Player, ListOfMoves),
    FinalRow is SelRow, FinalColumn is SelColumn;
    (
        write('\nERROR! You can not play that piece!\n \nSelect piece:\n'),
        manageRow(NewRow, Size),
        manageColumn(NewColumn, Size),
        validateContent(Board, Size, NewRow, NewColumn, Player, FinalRow, FinalColumn)
    ).

verifyPossibleMove(GameState, Size, SelRow, SelColumn, Player, ListOfMoves) :-
    checkDownMove(GameState, Size, SelRow, SelColumn, Player, DownMove),
    checkUpMove(GameState, Size, SelRow, SelColumn, Player, UpMove),
    checkLeftMove(GameState, Size, SelRow, SelColumn, Player, LeftMove),
    checkRightMove(GameState, Size, SelRow, SelColumn, Player, RightMove),
    appendListNotEmpty([], DownMove, L),
    appendListNotEmpty(L, UpMove, L1),
    appendListNotEmpty(L1, LeftMove, L2),
    appendListNotEmpty(L2, RightMove, ListOfMoves), !,
    \+isEmpty(ListOfMoves).
 
checkDownMove(GameState, Size, Row, Col, Player, DownMove):-
    Row>0, NewRow is Row-1,
    getValueFromMatrix(GameState, NewRow, Col, Enemy),
    Enemy is -Player,
    append([], [NewRow, Col], DownMove).

checkDownMove(GameState, Size, Row, Col, Player, []).

checkUpMove(GameState, Size, Row, Col, Player, UpMove):-
    Row<Size, NewRow is Row+1,
    getValueFromMatrix(GameState, NewRow, Col, Enemy),
    Enemy is -Player,
    append([], [NewRow, Col], UpMove).

checkUpMove(GameState, Size, Row, Col, Player, []).

checkLeftMove(GameState, Size, Row, Col, Player, LeftMove):-
    Col>0, NewCol is Col-1,
    getValueFromMatrix(GameState, Row, NewCol, Enemy),
    Enemy is -Player,
    append([], [Row, NewCol], LeftMove).

checkLeftMove(GameState, Size, Row, Col, Player, []).

checkRightMove(GameState, Size, Row, Col, Player, LeftMove):-
    Col<Size, NewCol is Col+1,
    getValueFromMatrix(GameState, Row, NewCol, Enemy),
    Enemy is -Player,
    append([], [Row, NewCol], LeftMove).

checkRightMove(GameState, Size, Row, Col, Player, []).

/*check if the player is moving his piece correctly
the movements must be orthogonal
when the movement is within the same row, the player can only select the position immediately to the right or left
when the movement is within the same column, the player can only select the position immediately to the top or down
when not given a valid position the player is asked again to write the position to move to
*/
verifyOrtMove(SelBoard, Size, Player, SelRow, SelColumn, MovRow, MovColumn, FinalRow, FinalColumn) :-
    getValueFromMatrix(SelBoard, MovRow, MovColumn, Enemy),
    (
        (MovRow=:=SelRow, (MovColumn=:=SelColumn+1 ; MovColumn=:=SelColumn-1));  /*Same row*/
        (MovColumn=:=SelColumn, (MovRow=:=SelRow+1 ; MovRow=:=SelRow-1)) /*Same column */
    ),
    Enemy is -Player, FinalRow is MovRow, FinalColumn is MovColumn;
    (
        write('\nERROR! That is not a valid move!\n \nMove to:\n'),
        manageRow(NewRow, Size),
        manageColumn(NewColumn, Size),
        verifyOrtMove(SelBoard, Size, Player, SelRow, SelColumn, NewRow, NewColumn, FinalRow, FinalColumn)
    ).

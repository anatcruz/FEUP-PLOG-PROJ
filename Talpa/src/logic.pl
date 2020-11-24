/*checks if the player is selecting his own piece
if not, then he is asked again to input the position of the piece he wants to move
*/

verifyPlayer(Board, Size, InputRow, InputColumn, Player, SelRow, SelColumn) :-
    isPlayer(Board, InputRow, InputColumn, Player),
    SelRow is InputRow, SelColumn is InputColumn;
    (
        write('\nERROR! You can not play that piece!\n \nRemove piece:\n'),
        manageRow(NewRow, Size),
        manageColumn(NewColumn, Size),
        verifyPlayer(Board, Size, NewRow, NewColumn, Player, SelRow, SelColumn)
    ).

validateContent(Board, Size, InputRow, InputColumn, Player, SelRow, SelColumn) :-
    isPlayer(Board, InputRow, InputColumn, Player),
    verifyPossibleMove(Board, Size, InputRow, InputColumn, Player, _),
    SelRow is InputRow, SelColumn is InputColumn;
    (
        write('\nERROR! You can not play that piece!\n \nSelect piece:\n'),
        manageRow(NewRow, Size),
        manageColumn(NewColumn, Size),
        validateContent(Board, Size, NewRow, NewColumn, Player, SelRow, SelColumn)
    ).

verifyPossibleMove(GameState, Size, SelRow, SelColumn, Player, ListOfMoves) :-
    checkMove(GameState, Size, SelRow, SelColumn, Player, ListOfMoves),
    \+isEmpty(ListOfMoves).

checkMove(GameState, Size, SelRow, SelColumn, Player, ListOfMoves) :-
    checkDownMove(GameState, Size, SelRow, SelColumn, Player, DownMove),
    checkUpMove(GameState, Size, SelRow, SelColumn, Player, UpMove),
    checkLeftMove(GameState, Size, SelRow, SelColumn, Player, LeftMove),
    checkRightMove(GameState, Size, SelRow, SelColumn, Player, RightMove),
    appendNotEmpty([], DownMove, L),
    appendNotEmpty(L, UpMove, L1),
    appendNotEmpty(L1, LeftMove, L2),
    appendNotEmpty(L2, RightMove, ListOfMoves), !.


checkDownMove(GameState, _, Row, Col, Player, DownMove):-
    Row>0, NewRow is Row-1,
    isEnemy(GameState, NewRow, Col, Player),
    DownMove = [NewRow-Col].

checkDownMove(_, _, _, _, _, []).

checkUpMove(GameState, Size, Row, Col, Player, UpMove):-
    Row<Size, NewRow is Row+1,
    isEnemy(GameState, NewRow, Col, Player),
    UpMove = [NewRow-Col].

checkUpMove(_, _, _, _, _, []).

checkLeftMove(GameState, _, Row, Col, Player, LeftMove):-
    Col>0, NewCol is Col-1,
    isEnemy(GameState, Row, NewCol, Player),
    LeftMove = [Row-NewCol].

checkLeftMove(_, _, _, _, _, []).

checkRightMove(GameState, Size, Row, Col, Player, RightMove):-
    Col<Size, NewCol is Col+1,
    isEnemy(GameState, Row, NewCol, Player),
    RightMove = [Row-NewCol].

checkRightMove(_, _, _, _, _, []).

/*check if the player is moving his piece correctly
the movements must be orthogonal
when the movement is within the same row, the player can only select the position immediately to the right or left
when the movement is within the same column, the player can only select the position immediately to the top or down
when not given a valid position the player is asked again to write the position to move to
*/
verifyOrtMove(SelBoard, Size, Player, SelRow, SelColumn, MovRow, MovColumn, FinalRow, FinalColumn) :-
    isEnemy(SelBoard, MovRow, MovColumn, Player),
    (
        (MovRow=:=SelRow, (MovColumn=:=SelColumn+1 ; MovColumn=:=SelColumn-1));  /*Same row*/
        (MovColumn=:=SelColumn, (MovRow=:=SelRow+1 ; MovRow=:=SelRow-1)) /*Same column */
    ),
    FinalRow is MovRow, FinalColumn is MovColumn;
    (
        write('\nERROR! That is not a valid move!\n \nMove to:\n'),
        manageRow(NewRow, Size),
        manageColumn(NewColumn, Size),
        verifyOrtMove(SelBoard, Size, Player, SelRow, SelColumn, NewRow, NewColumn, FinalRow, FinalColumn)
    ).

/* ListOfPossibleMoves: [[SelectedRow-SelectedColumn, MoveRow-MoveColumn], [SelRow2-SelCol2, MovRow2-MovCol2], ...]*/
valid_moves(GameState, Size, Player, ListOfPossibleMoves):-
    getPlayerInMatrix(GameState, Size, Player, Positions),
    getAllPossibleMoves(GameState, Size, Player, Positions, ListOfPossibleMoves),
    \+isEmpty(ListOfPossibleMoves).

valid_moves(_, _, _, _):-
    write('\nNo moves available, remove your own piece\n'),
    fail.
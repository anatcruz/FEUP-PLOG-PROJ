%verifyPlayer(+Board, +InputRow, +InputColumn, +Player, -SelRow, -SelColumn)
/*
Verifies if the player is selecting his own piece
*/
verifyPlayer(Board, InputRow, InputColumn, Player, SelRow, SelColumn):-
    getValueFromMatrix(Board, InputRow, InputColumn, Player),
    SelRow is InputRow, SelColumn is InputColumn.

/*
If not, write proper message error and fail predicate
*/
verifyPlayer(_, _, _, _, _, _):-
    write('\n! That is not your piece. Choose again !\n'), fail.


%verifyPossibleMove(+GameState, +Size, +SelectedRow, +SelectedColumn, +Player, -ListOfMoves)
/*
Verifies if piece in the given position has any possible moves
*/
verifyPossibleMove(GameState, Size, SelRow, SelColumn, Player, ListOfMoves):-
    checkMove(GameState, Size, SelRow, SelColumn, Player, ListOfMoves),
    \+isEmpty(ListOfMoves).

/*
If list is empty, write proper message error and fail predicate
*/
verifyPossibleMove(_, _, _, _, _, _):-
    write('\n! No available moves for that piece. Choose again !\n'), fail.


%validateContent(+Board, +Size, +InputRow, +InputColumn, +Player, -SelectedRow, -SelectedColumn)
/*
Checks if piece in the selected position is valid: 
verifies if it is a piece from the given player
and if the piece has any possible moves
*/
validateContent(Board, Size, InputRow, InputColumn, Player, SelRow, SelColumn):-
    verifyPlayer(Board, InputRow, InputColumn, Player, PlayerRow, PlayerColumn), !,
    verifyPossibleMove(Board, Size, PlayerRow, PlayerColumn, Player, _),
    SelRow is PlayerRow, SelColumn is PlayerColumn.


%checkMove(+GameState, +Size, +SelectedRow, +SelectedColumn, +Player, -ListOfMoves)
/*
Checks all surrounding orthogonal positions from the given position
Returns a list with all the possible moves for that piece (as [MoveRow1-MoveColumn1, ...])
*/
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

%verifyOrtMove(+SelBoard, +Player, +SelRow, +SelColumn, +MovRow, +MovColumn, -FinalRow, -FinalColumn)
/*
check if the player is moving his piece correctly
the movements must be orthogonal
when the movement is within the same row, the player can only select the position immediately to the right or left
when the movement is within the same column, the player can only select the position immediately to the top or down
*/
verifyOrtMove(SelBoard, Player, SelRow, SelColumn, MovRow, MovColumn, FinalRow, FinalColumn) :-
    isEnemy(SelBoard, MovRow, MovColumn, Player),
    (
        (MovRow=:=SelRow, (MovColumn=:=SelColumn+1 ; MovColumn=:=SelColumn-1));  /*Same row*/
        (MovColumn=:=SelColumn, (MovRow=:=SelRow+1 ; MovRow=:=SelRow-1)) /*Same column */
    ),
    FinalRow is MovRow, FinalColumn is MovColumn.

/*
If not, write proper message error and fail predicate
*/
verifyOrtMove(_, _, _, _, _, _, _, _):-
    write('\n! That is not a valid move. Choose again !\n'), fail.



getAllPossibleMoves(GameState, Size, Player, Positions, ListOfPossibleMoves):-
	getAllPossibleMoves(GameState, Size, Player, Positions, [], ListOfPossibleMoves).

getAllPossibleMoves(_, _, _, [], ListOfPossibleMoves, ListOfPossibleMoves).
getAllPossibleMoves(GameState, Size, Player, [Row-Column|PosRest], ListInterm, ListOfPossibleMoves):-
	checkMove(GameState, Size, Row, Column, Player, Moves),
	appendMoves(Row-Column, Moves, CurrentMoves),
	appendNotEmpty(ListInterm, CurrentMoves, NewList),
	getAllPossibleMoves(GameState, Size, Player, PosRest, NewList, ListOfPossibleMoves), !.


%valid_moves(+GameState, +Size, +Player, -ListOfMoves)
/*
Gets all the possible moves for all the current pieces of the given player
Returns a list with all the possible moves for the player (as [SelectedRow-SelectedColumn, MoveRow-MoveColumn], ...])
*/
valid_moves(GameState, Size, Player, ListOfMoves):-
    getPlayerInMatrix(GameState, Size, Player, Positions),
    getAllPossibleMoves(GameState, Size, Player, Positions, ListOfMoves),
    \+isEmpty(ListOfMoves).

/*
If list is empty, write proper message error and fail predicate
*/
valid_moves(_, _, _, _):-
    write('\nNo moves available, remove your own piece\n'), fail.
%verifyPlayer(+Board, +SelectedPosition, +Player)
/*
Verifies if the player is selecting his own piece
*/
verifyPlayer(Board, SelectedRow-SelectedColumn, Player):-
    getValueFromMatrix(Board, SelectedRow, SelectedColumn, Player).

/*
If not, write proper message error and fail predicate
*/
verifyPlayer(_, _, _):-
    write('\n! That is not your piece. Choose again !\n'), fail.


%verifyPossibleMove(+GameState, +Size, +SelectedPosition, +Player, -ListOfMoves)
/*
Verifies if piece in the given position has any possible moves
*/
verifyPossibleMove(GameState, Size, SelectedRow-SelectedColumn, Player, ListOfMoves):-
    checkMove(GameState, Size, SelectedRow, SelectedColumn, Player, ListOfMoves),
    \+isEmpty(ListOfMoves).

/*
If list is empty, write proper message error and fail predicate
*/
verifyPossibleMove(_, _, _, _, _):-
    write('\n! No available moves for that piece. Choose again !\n'), fail.


%validateContent(+Board, +Size, +SelectedPosition, +Player)
/*
Checks if piece in the selected position is valid: 
verifies if it is a piece from the given player
and if the piece has any possible moves
*/
validateContent(Board, Size, SelectedRow-SelectedColumn, Player):-
    verifyPlayer(Board, SelectedRow-SelectedColumn, Player), !,
    verifyPossibleMove(Board, Size, SelectedRow-SelectedColumn, Player, _).


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

%verifyOrtMove(+SelBoard, +Player, +SelectedPosition, +MovePosition)
/*
check if the player is moving his piece correctly
the movements must be orthogonal
when the movement is within the same row, the player can only select the position immediately to the right or left
when the movement is within the same column, the player can only select the position immediately to the top or down
*/
verifyOrtMove(SelBoard, Player, SelRow-SelColumn, MoveRow-MoveColumn) :-
    isEnemy(SelBoard, MoveRow, MoveColumn, Player),
    (
        (MoveRow=:=SelRow, (MoveColumn=:=SelColumn+1 ; MoveColumn=:=SelColumn-1));  /*Same row*/
        (MoveColumn=:=SelColumn, (MoveRow=:=SelRow+1 ; MoveRow=:=SelRow-1)) /*Same column */
    ).

/*
If not, write proper message error and fail predicate
*/
verifyOrtMove(_, _, _, _):-
    write('\n! That is not a valid move. Choose again !\n'), fail.

%getAllPossibleMoves(+GameState, +Size, +Player, +Positions, -ListOfPossibleMoves)
/*
For all the positions passed, it checks the available moves for each
the listOfPossibleMoves stores the moves as as [[SelectedRow-SelectedColumn, MoveRow-MoveColumn], ...]
*/

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
Returns a list with all the possible moves for the player (as [[SelectedRow-SelectedColumn, MoveRow-MoveColumn], ...])
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
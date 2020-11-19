/*checks if the player is selecting his own piece
if not, then he is asked again to input the position of the piece he wants to move
*/

verifyPlayer(Board, Size, SelRow, SelColumn, Player, FinalRow, FinalColumn) :-
    isPlayer(Board, SelRow, SelColumn, Player),
    FinalRow is SelRow, FinalColumn is SelColumn;
    (
        write('\nERROR! You can not play that piece!\n \nSelect piece:\n'),
        manageRow(NewRow, Size),
        manageColumn(NewColumn, Size),
        verifyPlayer(Board, Size, NewRow, NewColumn, Player, FinalRow, FinalColumn)
    ).

validateContent(Board, Size, SelRow, SelColumn, Player, FinalRow, FinalColumn) :-
    isPlayer(Board, SelRow, SelColumn, Player),
    verifyPossibleMove(Board, Size, SelRow, SelColumn, Player, _),
    FinalRow is SelRow, FinalColumn is SelColumn;
    (
        write('\nERROR! You can not play that piece!\n \nSelect piece:\n'),
        manageRow(NewRow, Size),
        manageColumn(NewColumn, Size),
        validateContent(Board, Size, NewRow, NewColumn, Player, FinalRow, FinalColumn)
    ).

verifyPossibleMove(GameState, Size, SelRow, SelColumn, Player, ListOfMoves) :-
    checkMove(GameState, Size, SelRow, SelColumn, Player, ListOfMoves), !,
    \+isEmpty(ListOfMoves),
    write('\nMoves available: '), printMovesList(ListOfMoves), nl.

checkMove(GameState, Size, SelRow, SelColumn, Player, ListOfMoves) :-
    checkDownMove(GameState, Size, SelRow, SelColumn, Player, DownMove),
    checkUpMove(GameState, Size, SelRow, SelColumn, Player, UpMove),
    checkLeftMove(GameState, Size, SelRow, SelColumn, Player, LeftMove),
    checkRightMove(GameState, Size, SelRow, SelColumn, Player, RightMove),
    appendListNotEmpty([], DownMove, L),
    appendListNotEmpty(L, UpMove, L1),
    appendListNotEmpty(L1, LeftMove, L2),
    appendListNotEmpty(L2, RightMove, ListOfMoves).


checkDownMove(GameState, _, Row, Col, Player, DownMove):-
    Row>0, NewRow is Row-1,
    isEnemy(GameState, NewRow, Col, Player),
    append([], [NewRow, Col], DownMove).

checkDownMove(_, _, _, _, _, []).

checkUpMove(GameState, Size, Row, Col, Player, UpMove):-
    Row<Size, NewRow is Row+1,
    isEnemy(GameState, NewRow, Col, Player),
    append([], [NewRow, Col], UpMove).

checkUpMove(_, _, _, _, _, []).

checkLeftMove(GameState, _, Row, Col, Player, LeftMove):-
    Col>0, NewCol is Col-1,
    isEnemy(GameState, Row, NewCol, Player),
    append([], [Row, NewCol], LeftMove).

checkLeftMove(_, _, _, _, _, []).

checkRightMove(GameState, Size, Row, Col, Player, RightMove):-
    Col<Size, NewCol is Col+1,
    isEnemy(GameState, Row, NewCol, Player),
    append([], [Row, NewCol], RightMove).

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


findPlayerInRow(GameState, List, Size, Row, Column, Player, ListOfMoves) :-
	findPlayerInRow(GameState, List, Size, Row, Column, Player, [], ListOfMoves).

findPlayerInRow(_, [], Size, _, Size, _, ListOfMoves, ListOfMoves).
findPlayerInRow(GameState, [_|Tail], Size, Row, Column, Player, Moves, ListOfMoves) :-
	(
		isPlayer(GameState, Row, Column, Player),
		checkMove(GameState, Size, Row, Column, Player, ListInterm),
		append(Moves, ListInterm, NewList),
		X is Column + 1,
		findPlayerInRow(GameState, Tail, Size, Row, X, Player, NewList, ListOfMoves)
	);
	(
		X is Column + 1,
		findPlayerInRow(GameState, Tail, Size, Row, X, Player, Moves, ListOfMoves)
	).

findPlayerInMatrix(GameState, Size, Player, ListOfMoves) :-
	findPlayerInMatrix(GameState, GameState, Size, 0, Player, [], ListOfMoves).

findPlayerInMatrix(_, [], Size, Size, _, ListOfMoves, ListOfMoves).
findPlayerInMatrix(GameState, [Head|Tail], Size, Row, Player, ListInterm, ListOfMoves) :-
	findPlayerInRow(GameState, Head, Size, Row, 0, Player, List),
	append(ListInterm, List, NewList),
	X is Row + 1,
	findPlayerInMatrix(GameState, Tail, Size, X, Player, NewList, ListOfMoves).

checkAvailableMoves(GameState, Size, Player):-
    findPlayerInMatrix(GameState, Size, Player, Moves),
    (
        (
            \+isEmpty(Moves)
        );
        (
            write('No moves available, remove your own piece\n'),
            fail
        )
    ).

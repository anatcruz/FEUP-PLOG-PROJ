bot_play(Board, FinalBoard, Size, Player):-
    selectPieceBot(Board, Size, SelBoard, Player, InputRow, InputColumn).

chose_position_available(ListOfPositions, Row, Column):-
    length(ListOfPositions, Length),
    Length1 is Length-1,
    random(0, Length1, SelIndex),
    nth0(SelIndex, ListOfPositions, SelectedPosition),
    getPosition(SelectedPosition, Row, Column),
    write('\nSelected: '), printMove([Row, Column]), nl, !.

selectPieceBot(Board, Size, SelBoard, Player, SelRow, SelColumn):-
    getPlayerInMatrix(Board, Size, Player, ListOfPositions),
    write('\nAvailable Player positions: '), printMovesList(ListOfPositions), nl,
    repeat,
    chose_position_available(ListOfPositions, Row, Column),
    checkMove(Board, Size, Row, Column, Player, ListOfMoves),
    write('\nAvailable Moves: '), printMovesList(ListOfMoves), nl,
    \+isEmpty(ListOfMoves),
    replaceInMatrix(Board, Row, Column, 0, SelBoard),
    printBoard(SelBoard).
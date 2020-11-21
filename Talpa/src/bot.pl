bot_play(Board, FinalBoard, Size, Player):-
    selectPieceBot(Board, Size, SelBoard, Player, ListOfMoves),
    movePieceBot(SelBoard, FinalBoard, Player, ListOfMoves),
    printBoard(FinalBoard).

selectPieceBot(Board, Size, SelBoard, Player, ListOfMoves):-
    valid_moves(Board, Size, Player, ListOfValidMoves),
    random_member(SelMove, ListOfValidMoves),
    getPositionAndMoves(SelMove, Position, ListOfMoves),
    getPosition(Position, SelRow, SelColumn),
    write('\nSelected: '), printMove(Position), nl,
    replaceInMatrix(Board, SelRow, SelColumn, 0, SelBoard).

movePieceBot(SelBoard, FinalBoard, Player, ListOfMoves):-
    random_member(SelectedMove, ListOfMoves),
    getPosition(SelectedMove, MovRow, MovColumn),
    write('\nMove to: '), printMove([MovRow, MovColumn]), nl,
    replaceInMatrix(SelBoard, MovRow, MovColumn, Player, FinalBoard).
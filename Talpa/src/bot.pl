bot_play(Board, FinalBoard, Size, Player):-
    ((Player is 1, write('\nRED(O) turn\n')) ; (Player is -1, write('\nBLUE(X) turn\n'))),
    (
        (
            valid_moves(Board, Size, Player, ListOfValidMoves),
            selectPieceBot(Board, Size, SelBoard, Player, ListOfValidMoves, ListOfMoves),
            movePieceBot(SelBoard, FinalBoard, Player, ListOfMoves)
        );
        (
            removePieceBot(Board, Size, FinalBoard, Player)
        )

    ),
    printBoard(FinalBoard).

selectPieceBot(Board, Size, SelBoard, Player, ListOfValidMoves, ListOfMoves):-
    random_member(SelMove, ListOfValidMoves),
    getPositionAndMoves(SelMove, Position, ListOfMoves),
    getPosition(Position, SelRow, SelColumn),
    write('\nSelected: '), printMove(Position), nl,
    replaceInMatrix(Board, SelRow, SelColumn, 0, SelBoard).

movePieceBot(SelBoard, FinalBoard, Player, ListOfMoves):-
    random_member(SelMove, ListOfMoves),
    getPosition(SelMove, MovRow, MovColumn),
    write('\nMove to: '), printMove(SelMove), nl,
    replaceInMatrix(SelBoard, MovRow, MovColumn, Player, FinalBoard).

removePieceBot(Board, Size, FinalBoard, Player):-
    getPlayerInMatrix(Board, Size, Player, Positions),
    write(Positions),
    random_member(SelPosition, Positions),
    getPosition(SelPosition, SelRow, SelColumn),
    write('\nRemoved: '), printMove(SelPosition), nl,
    replaceInMatrix(Board, SelRow, SelColumn, 0, FinalBoard).
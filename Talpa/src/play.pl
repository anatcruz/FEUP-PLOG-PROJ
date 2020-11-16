initial(GameState) :- %initialGameState(GameState).
            %midGameState(GameState).
            testState(GameState).
            %finalGameState(GameState).
            %generateBoard(GameState, 3).

gameLoop(Board) :-
    display_game(Board, FinalBoardRed, 1),
    display_game(FinalBoardRed, FinalBoardBlue, -1),
    gameLoop(FinalBoardBlue).


display_game(Board, FinalBoard, Player) :-
    length(Board, Size),
    ((Player is 1, write('\nRED(O) turn\n')) ; (Player is -1, write('\nBLUE(X) turn\n'))),
    checkAvailableMoves(Board, Size, Player, HasMoves),
    (
        (
            HasMoves is 1,
            selectPiece(Board, Size, SelBoard, Player, InputRow, InputColumn),
            movePiece(SelBoard, Size, FinalBoard, Player, InputRow, InputColumn)
        );
        (
            HasMoves is 0,
            removePiece(Board, Size, FinalBoard, Player)
        )
    ),
    printBoard(FinalBoard).
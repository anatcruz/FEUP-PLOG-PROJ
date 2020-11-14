initial(GameState) :- initialGameState(GameState).
            %midGameState(GameState).
            %finalGameState(GameState).

gameLoop(Board) :-
    display_game(Board, FinalBoardRed, 1),
    display_game(FinalBoardRed, FinalBoardBlue, -1),
    gameLoop(FinalBoardBlue).


display_game(Board, FinalBoard, Player) :-
    ((Player is 1, write('\nRED(0) turn\n')); (Player is -1, write('\nBLUE(X) turn\n'))),
    selectPiece(Board, FinalBoard, Player),
    printBoard(FinalBoard).
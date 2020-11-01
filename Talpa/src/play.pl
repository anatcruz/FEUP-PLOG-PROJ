initial(GameState) :- initialGameState(GameState).
            %midGameState(GameState).
            %finalGameState(GameState).

gameLoop(Board) :-
    display_game(Board, FinalBoardRed, red),
    display_game(FinalBoardBRed, FinalBoardBlue, blue),
    gameLoop(FinalBoardBlue).


display_game(Board, FinalBoard, Player) :-
    ((Player==blue, write('\nBLUE(X) turn\n')); (Player==red, write('\nRED(O) turn\n'))),
    selectPiece(Board, FinalBoard, Player),
    printBoard(FinalBoard).
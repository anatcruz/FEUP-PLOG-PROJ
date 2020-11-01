initial(GameState) :- initialGameState(GameState).
            %midGameState(GameState).
            %finalGameState(GameState).

gameLoop(Board) :-
    display_game(Board, FinalBoardBlue, blue),
    display_game(FinalBoardBlue, FinalBoardRed, red),
    gameLoop(FinalBoardRed).


display_game(Board, FinalBoard, Player) :-
    ((Player==blue, write('\nBLUE(X) turn\n')); (Player==red, write('\nRED(O) turn\n'))),
    selectPiece(Board, FinalBoard, Player),
    printBoard(FinalBoard).
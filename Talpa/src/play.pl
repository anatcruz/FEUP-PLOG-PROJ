initial(GameState) :- %initialGameState(GameState).
            midGameState(GameState).
            %testState(GameState).
            %finalGameState(GameState).
            %generateBoard(GameState, 3).

gameLoop(Board) :-
    display_game(Board, FinalBoardRed, 1),
    display_game(FinalBoardRed, FinalBoardBlue, -1),
    gameLoop(FinalBoardBlue).


display_game(Board, FinalBoard, Player) :-
    checkAvailableMoves(Board),
    ((Player is 1, write('\nRED(O) turn\n')); (Player is -1, write('\nBLUE(X) turn\n'))),
    selectPiece(Board, FinalBoard, Player),
    printBoard(FinalBoard).
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
    length(Board, Size),
    checkAvailableMoves(Board, Player),
    ((Player is 1, write('\nRED(O) turn\n')); (Player is -1, write('\nBLUE(X) turn\n'))),
    selectPiece(Board, Size, SelBoard, Player, InputRow, InputColumn, FinalBoard),
    movePiece(SelBoard, Size, FinalBoard, Player, InputRow, InputColumn),
    printBoard(FinalBoard).
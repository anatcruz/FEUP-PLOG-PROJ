play:-
    initBoard(Board),
    printBoard(Board),
    gameLoop(Board).

gameLoop(Board) :-
    playerTurn(Board, FinalBoardBlue, blue),
    playerTurn(FinalBoardBlue, FinalBoardRed, red),
    gameLoop(FinalBoardRed).


playerTurn(Board, FinalBoard, Player) :-
    (Player==blue, write('\n BLUE(X) turn\n'); Player==red, write('\n RED(O) turn\n')),
    selectPiece(Board, SelBoard, Player),
    printBoard(FinalBoard).
    /*movePiece(SelBoard, FinalBoard, Player),*/
    /*printBoard(FinalBoard).*/
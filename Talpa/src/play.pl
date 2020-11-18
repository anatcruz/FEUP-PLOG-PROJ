initial(GameState) :- %initialGameState(GameState).
            %midGameState(GameState).
            testState(GameState).
            %finalGameState(GameState).
            %generateBoard(GameState, 3).

gameLoop(Board) :-
    length(Board, Size),
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
    printBoard(FinalBoard),
    ((write('Red Won?\n'), checkRedVictory(FinalBoard, Size, 0, 0), write('\nRed Won\n')) ; (write('Blue Won?\n'), checkBlueVictory(FinalBoard, Size, 0, 0), write('\nBlue Won\n')) ; true).

checkRedVictory(Board, Size, Row, Col):-
    format("Check Start, Row~w Col~w \n", [Row,Col]),
    Row < Size,
    (
        (
            tryFloodFill(Board, Size, Row, Col, FinalBoard),
            FinalCol is Size-1,
            checkRedPath(FinalBoard, Size, 0, FinalCol)
        );
        (
            NextRow is Row + 1,
            checkRedVictory(Board, Size, NextRow, Col)
        )
    ).

tryFloodFill(Board, Size, Row, Col, FinalBoard):-
    getValueFromMatrix(Board, Row, Col, 0),
    floodFill(Board, Size, Row, Col, 0, 2, FinalBoard), !,
    Board \= FinalBoard.
    

checkRedPath(Board, Size, Row, Col):-
    format("Check End, Row~w Col~w \n", [Row,Col]),
    Row < Size,
    (
        (
            getValueFromMatrix(Board, Row, Col, 2)
        );
        (
            NextRow is Row + 1,
            checkRedPath(Board, Size, NextRow, Col)
        )
    ).

checkBlueVictory(Board, Size, Row, Col):-
    format("Check Start, Row~w Col~w \n", [Row,Col]),
    Col < Size,
    (
        (
            tryFloodFill(Board, Size, Row, Col, FinalBoard),
            FinalRow is Size-1,
            checkBluePath(FinalBoard, Size, FinalRow, 0)
        );
        (
            NextCol is Col + 1,
            checkBlueVictory(Board, Size, Row, NextCol)
        )
    ).
    

checkBluePath(Board, Size, Row, Col):-
    format("Check End, Row~w Col~w \n", [Row,Col]),
    Col < Size,
    (
        (
            getValueFromMatrix(Board, Row, Col, 2)
        );
        (
            NextCol is Col + 1,
            checkBluePath(Board, Size, Row, NextCol)
        )
    ).
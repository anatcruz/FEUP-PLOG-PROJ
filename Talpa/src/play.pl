initial(GameState) :- %initialGameState(GameState).
            %midGameState(GameState).
            testState(GameState).
            %finalGameState(GameState).
            %generateBoard(GameState, 3).

gameLoop(Board, Player) :-
    (
        length(Board, Size),
        checkVictory(Player, Board, Size)
    );
    (
        display_game(Board, FinalBoard, Player),
        Enemy is -Player,
        write(FinalBoard),
        gameLoop(FinalBoard, Enemy)
    ).


display_game(Board, FinalBoard, Player) :-
    length(Board, Size),
    ((Player is 1, write('\nRED(O) turn\n')) ; (Player is -1, write('\nBLUE(X) turn\n'))),
    (
        (
            checkAvailableMoves(Board, Size, Player),
            selectPiece(Board, Size, SelBoard, Player, InputRow, InputColumn),
            movePiece(SelBoard, Size, FinalBoard, Player, InputRow, InputColumn)
        );
        (
            removePiece(Board, Size, FinalBoard, Player)
        )
    ),
    printBoard(FinalBoard).

checkVictory(Player, Board, Size):-
    (
        checkWinner(Player, Board, Size, 0, 0),
        format("\n~w player won\n", [Player])
    );
    (
        Enemy is -Player,
        checkWinner(Enemy, Board, Size, 0, 0),
        format("\n~w player won\n", [Enemy])
    );
    fail.

checkWinner(1, Board, Size, Row, Col):-
    Row < Size,
    (
        (
            tryFloodFill(Board, Size, Row, Col, FinalBoard),
            FinalCol is Size-1,
            checkRedPath(FinalBoard, Size, 0, FinalCol)
        );
        (
            NextRow is Row + 1,
            checkWinner(1, Board, Size, NextRow, Col)
        )
    ).

checkWinner(-1, Board, Size, Row, Col):-
    Col < Size,
    (
        (
            tryFloodFill(Board, Size, Row, Col, FinalBoard),
            FinalRow is Size-1,
            checkBluePath(FinalBoard, Size, FinalRow, 0)
        );
        (
            NextCol is Col + 1,
            checkWinner(-1, Board, Size, Row, NextCol)
        )
    ).
    

checkRedPath(Board, Size, Row, Col):-
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
    

checkBluePath(Board, Size, Row, Col):-
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

tryFloodFill(Board, Size, Row, Col, FinalBoard):-
    getValueFromMatrix(Board, Row, Col, 0),
    floodFill(Board, Size, Row, Col, 0, 2, FinalBoard), !,
    Board \= FinalBoard.
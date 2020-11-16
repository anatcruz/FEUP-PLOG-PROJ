initial(GameState) :- %initialGameState(GameState).
            %midGameState(GameState).
            %testState(GameState).
            finalGameState(GameState).
            %generateBoard(GameState, 3).

gameLoop(Board) :-
    length(Board, Size),
    (
        (
            checkRedVictory(Board, Size, 0, 0),
            write('\nRed Won\n')
        );
        (
            write('\nRed did not win yet\n')
        )
    ).
    /*display_game(Board, FinalBoardRed, 1),
    display_game(FinalBoardRed, FinalBoardBlue, -1),
    gameLoop(FinalBoardBlue).*/


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

checkRedVictory(Board, Size, Row, Col):-
    format("Check Start, Row~w Col~w \n", [Row,Col]),
    Row < Size,
    (
        (
            getValueFromMatrix(Board, Row, Col, 0),
            floodFill(Board, Size, Row, Col, 0, 2, FinalBoard),
            FinalCol is Size-1,
            (checkRedPath(FinalBoard, Size, 0, FinalCol) ; (NextRow is Row + 1, !, checkRedVictory(Board, Size, NextRow, Col)))
        );
        (
            NextRow is Row + 1, !,
            checkRedVictory(Board, Size, NextRow, Col)
        )
    ).
    

checkRedPath(Board, Size, Row, Col):-
    format("Check End, Row~w Col~w \n", [Row,Col]),
    Row < Size,
    (
        (
            getValueFromMatrix(Board, Row, Col, 2)
        );
        (
            NextRow is Row + 1, !,
            checkRedPath(Board, Size, NextRow, Col)
        )
    ).
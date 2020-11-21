initial(GameState, Size) :- %generateBoard(GameState, Size).
                            %initialGameState(GameState).
                            %midGameState(GameState).
                            testState(GameState).
                            %finalGameState(GameState).

gameLoop(Board, Size, Player) :-
    /*display_game(Board, FinalBoard, Size, Player),
    Enemy is -Player,
    (
        checkVictory(Player, FinalBoard, Size);
        gameLoop(FinalBoard, Size, Enemy)
    ).*/
    bot_play(Board, FinalBoard, Size, Player).


display_game(Board, FinalBoard, Size, Player) :-
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

    %Check victory from players
%Check victory from the enemy first
checkVictory(Player, Board, Size):-
    Enemy is -Player,
    checkWinner(Enemy, Board, Size, 0, 0),
    printWinner(Enemy).

%Check victory from the player after
checkVictory(Player, Board, Size):-
    checkWinner(Player, Board, Size, 0, 0),
    printWinner(Player).


%Check if red player (O) won, using checkRedPath to avaliate board after floodfill
checkWinner(1, Board, Size, Row, Col):-
    Row < Size,
    tryFloodFill(Board, Size, Row, Col, FinalBoard),
    FinalCol is Size-1,
    checkRedPath(FinalBoard, Size, 0, FinalCol).

%If checkRedPath failed check next row
checkWinner(1, Board, Size, Row, Col):-
    Row < Size,
    NextRow is Row + 1,
    checkWinner(1, Board, Size, NextRow, Col).


%Check if blue player (X) won, using checkBluePath to avaliate board after floodfill
checkWinner(-1, Board, Size, Row, Col):-
    Col < Size,
    tryFloodFill(Board, Size, Row, Col, FinalBoard),
    FinalRow is Size-1,
    checkBluePath(FinalBoard, Size, FinalRow, 0).

%If checkBluePath failed check next column
checkWinner(-1, Board, Size, Row, Col):-
    Col < Size,
    NextCol is Col + 1,
    checkWinner(-1, Board, Size, Row, NextCol).

    
%Auxiliar to check if there is a floodfill replaced char in the final column, meaning a path for the red player
checkRedPath(Board, Size, Row, FinalCol):-
    Row < Size,
    getValueFromMatrix(Board, Row, FinalCol, 2).

%If failed, check for a path in the next row and final column
checkRedPath(Board, Size, Row, FinalCol):-
    Row < Size,
    NextRow is Row + 1,
    checkRedPath(Board, Size, NextRow, FinalCol).


%Auxiliar to check if there is a floodfill replaced char in the final row, meaning a path for the blue player
checkBluePath(Board, Size, FinalRow, Col):-
    Col < Size,
    getValueFromMatrix(Board, FinalRow, Col, 2).

%If failed, check for a path in the next column and final row
checkBluePath(Board, Size, FinalRow, Col):-
    Col < Size,
    NextCol is Col + 1,
    checkBluePath(Board, Size, FinalRow, NextCol).
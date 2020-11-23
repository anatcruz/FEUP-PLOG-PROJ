initial(GameState, Size) :- generateBoard(GameState, Size).
                            %initialGameState(GameState).
                            %midGameState(GameState).
                            %testState(GameState).
                            %finalGameState(GameState).

display_game(GameState, Player):-
    printBoard(GameState),
    printTurn(Player).

/*Selects a piece and a position to move if there are available moves for the player*/
choose_move(GameState, Size, Player, Move):-
    valid_moves(GameState, Size, Player, _),
    selectPiece(GameState, Size, Player, SelRow, SelColumn),
    movePiece(GameState, Size, Player, SelRow, SelColumn, FinalRow, FinalColumn),
    Move = [SelRow, SelColumn, FinalRow, FinalColumn].

/*If no available moves then select a piece to remove*/
choose_move(GameState, Size, Player, Move):-
    removePiece(GameState, Size, Player, SelRow, SelColumn),
    Move = [SelRow, SelColumn].

/*Move when available moves,
replacing on board selected position with empty space and moving position with player piece*/
move(GameState, Player, Move, NewGameState):-
    (nth0(0, Move, SelRow), nth0(1, Move, SelColumn), nth0(2, Move, FinalRow), nth0(3, Move, FinalColumn)),
    replaceInMatrix(GameState, SelRow, SelColumn, 0, UpdatedGameState),
    replaceInMatrix(UpdatedGameState, FinalRow, FinalColumn, Player, NewGameState).

/*Move when no available moves, replacing selected position on board with empty space*/
move(GameState, Player, [Row, Column |_], NewGameState):-
    replaceInMatrix(GameState, Row, Column, 0, NewGameState).

playerTurn(GameState, NewGameState, Size, Player) :-
    printTurn(Player),
    choose_move(GameState, Size, Player, Move),
    move(GameState, Player, Move, NewGameState),
    printBoard(NewGameState).

botTurn(GameState, NewGameState, Size, Player, Level) :-
    printTurn(Player),
    choose_move(GameState, Size, Player, Level, Move),
    move(GameState, Player, Move, NewGameState),
    printBoard(NewGameState).

playerVSplayer(GameState, Size, Player):-
    playerTurn(GameState, NewGameState, Size, Player),
    (
        game_over(Player, NewGameState, Size);
        Enemy is -Player, playerVSplayer(NewGameState, Size, Enemy)
    ).

playerVSbotRandom(GameState, Size, Player) :-
    playerTurn(GameState, UpdatedGameState, Size, Player),
    (
        game_over(Player, UpdatedGameState, Size);
        (
            Enemy is -Player,
            botTurn(UpdatedGameState, NewGameState, Size, Enemy, 1),
            (
                game_over(Enemy, NewGameState, Size);
                enterContinue, playerVSbotRandom(NewGameState, Size, Player)
            )
        )  
    ).

    %Check victory from players
%Check victory from the enemy first
game_over(Player, Board, Size):-
    Enemy is -Player,
    checkWinner(Enemy, Board, Size, 0, 0),
    printWinner(Enemy).

%Check victory from the player after
game_over(Player, Board, Size):-
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
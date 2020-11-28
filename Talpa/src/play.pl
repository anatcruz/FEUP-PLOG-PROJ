initial(GameState, Size) :- %generateBoard(GameState, Size).
                            %initialGameState(GameState).
                            %midGameState(GameState).
                            testState(GameState).
                            %finalGameState(GameState).

initialize(GameState, Size):-
    initial(GameState, Size),
    printBoard(GameState).

play(GameState, Size, Player, _, _):-
    game_over(GameState, Size, Player, Winner), !, printWinner(Winner).

play(GameState, Size, Player, PlayerType, EnemyType):-
    printTurn(Player),
    choose_move(GameState, Size, Player, PlayerType, Move),
    move(GameState, Player, Move, NewGameState),
    printBoard(NewGameState),
    Enemy is -Player,
    !, play(NewGameState, Size, Enemy, EnemyType, PlayerType).

/*Selects a piece and a position to move if there are available moves for the player*/
choose_move(GameState, Size, Player, 'Player', Move):-
    valid_moves(GameState, Size, Player, _),
    selectPiecePosition(GameState, Size, Player, SelRow, SelColumn),
    movePiecePosition(GameState, Size, Player, SelRow, SelColumn, FinalRow, FinalColumn),
    Move = [SelRow-SelColumn, FinalRow-FinalColumn].

/*If no available moves then select a piece to remove*/
choose_move(GameState, Size, Player, 'Player', Move):-
    removePiecePosition(GameState, Size, Player, SelRow, SelColumn),
    Move = SelRow-SelColumn.

/*Move when available moves,
replacing on board selected position with empty space and moving position with player piece*/
move(GameState, Player, Move, NewGameState):-
    getSelAndMovePosition(Move, SelRow-SelColumn, FinalRow-FinalColumn),
    replaceInMatrix(GameState, SelRow, SelColumn, 0, UpdatedGameState),
    replaceInMatrix(UpdatedGameState, FinalRow, FinalColumn, Player, NewGameState).

/*Move when no available moves, replacing selected position on board with empty space*/
move(GameState, Player, Row-Column, NewGameState):-
    replaceInMatrix(GameState, Row, Column, 0, NewGameState).


    %Check victory from players
%Check victory from the current player first (last round enemy)
game_over(GameState, Size, Player, Player):-
    checkWinner(Player, GameState, Size, 0, 0).

%Check victory from the current enemy after
game_over(GameState, Size, Player, Enemy):-
    Enemy is -Player,
    checkWinner(Enemy, GameState, Size, 0, 0).


%Check if red player (O) won, using checkHorizontalPath to avaliate board after floodfill
checkWinner(1, GameState, Size, Row, Column):-
    Row < Size,
    tryFloodFill(GameState, Size, Row, Column, FinalGameState),
    FinalCol is Size-1,
    checkHorizontalPath(FinalGameState, 0, FinalCol).

%If FloodFill try or checkHorizontalPath failed check next row
checkWinner(1, GameState, Size, Row, Column):-
    Row < Size,
    NextRow is Row + 1,
    checkWinner(1, GameState, Size, NextRow, Column).

%Check if blue player (X) won, transposing matrix and using checkWinner for red player to check for an horizontal path
checkWinner(-1, GameState, Size, Row, Column):-
    transpose(GameState, Transpose),
    checkWinner(1, Transpose, Size, Row, Column).
    
%Auxiliar to check if there is a floodfill replaced char in the final column, meaning a path for the red player
checkHorizontalPath(GameState, Row, FinalCol):-
    Row =< FinalCol,
    getValueFromMatrix(GameState, Row, FinalCol, 2).

%If failed, check for a path in the next row and final column
checkHorizontalPath(GameState, Row, FinalCol):-
    Row =< FinalCol,
    NextRow is Row + 1,
    checkHorizontalPath(GameState, NextRow, FinalCol).
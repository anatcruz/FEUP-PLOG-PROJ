%initial(-GameState, +Size)
/*
Returns the initial GameState with the given Size
*/
initial(GameState, Size) :- generateBoard(GameState, Size).
                            %initialGameState(GameState).
                            %midGameState(GameState).
                            %testState(GameState).
                            %finalGameState(GameState).

%initialize(-GameState, +Size)
/*
Returns created GameState and displays it
*/
initialize(GameState, Size):-
    initial(GameState, Size),
    display_game(GameState).

%play(+GameState, +Size, +Player, +PlayerType, +EnemyType)
/*
Verifies if the game is over (a player created a path)
and prints the Winner
*/
play(GameState, Size, Player, _, _):-
    game_over(GameState, Size, Player, Winner), !, printWinner(Winner).

/*
If game is not over,
print the current player turn, 
if the current player is a bot, the program sleeps for 1 second,
player chooses a move according to its type, makes the move and prints the board afterwards,
and call the play predicate to make the enemy play
*/
play(GameState, Size, Player, PlayerType, EnemyType):-
    printTurn(Player),
    botWait(PlayerType, EnemyType),
    choose_move(GameState, Size, Player, PlayerType, Move),
    move(GameState, Player, Move, NewGameState),
    display_game(NewGameState),
    Enemy is -Player,
    !, play(NewGameState, Size, Enemy, EnemyType, PlayerType).

%choose_move(+GameState, +Size, +Player, +PlayerType, -Move)
/*
Selects a piece and a position to move if there are available moves for the player,
returning the move selected
*/
choose_move(GameState, Size, Player, 'Player', [SelectedPosition, MovePosition]):-
    valid_moves(GameState, Size, Player, _),
    selectPiecePosition(GameState, Size, Player, SelectedPosition),
    movePiecePosition(GameState, Size, Player, SelectedPosition, MovePosition).

/*
If no available moves then select a piece to remove, returning the move selected
*/
choose_move(GameState, Size, Player, 'Player', SelectedPosition):-
    removePiecePosition(GameState, Size, Player, SelectedPosition).


%move(+GameState, +Player, +Move, -NewGameState)
/*
Move when available moves (and in this case Move is [SelectedRow-SelectedColumn, MoveRow-MoveColumn]),
replacing on board the selected position with empty space and moving position with player piece,
returning the board after the move
*/
move(GameState, Player, Move, NewGameState):-
    getSelAndMovePosition(Move, SelRow-SelColumn, FinalRow-FinalColumn),
    replaceInMatrix(GameState, SelRow, SelColumn, 0, UpdatedGameState),
    replaceInMatrix(UpdatedGameState, FinalRow, FinalColumn, Player, NewGameState).

/*
Move when no available moves (and in this case Move is SelectedRow-SelectedColumn),
replacing selected position on board with empty space,
returning the board after the remove
*/
move(GameState, Player, Row-Column, NewGameState):-
    replaceInMatrix(GameState, Row, Column, 0, NewGameState).


%game_over(+GameState, +Size, +Player, -Winner)
/*
Check victory from the current player first (last round enemy)
*/
game_over(GameState, Size, Player, Player):-
    checkWinner(Player, GameState, Size, 0, 0).

/*
Check victory from the current enemy after
*/
game_over(GameState, Size, Player, Enemy):-
    Enemy is -Player,
    checkWinner(Enemy, GameState, Size, 0, 0).


%checkWinner(+Player, +GameState, +Size, +Row, +Column)
/*
Check if red player (1) won (there is a path linking left side to right side),
using checkHorizontalPath to avaliate board after floodfill
*/
checkWinner(1, GameState, Size, Row, Column):-
    Row < Size,
    tryFloodFill(GameState, Size, Row, Column, FinalGameState),
    FinalCol is Size-1,
    checkHorizontalPath(FinalGameState, 0, FinalCol).

/*
If FloodFill try or checkHorizontalPath failed check next row
*/
checkWinner(1, GameState, Size, Row, Column):-
    Row < Size,
    NextRow is Row + 1,
    checkWinner(1, GameState, Size, NextRow, Column).

/*
Check if blue player (-1) won,
transposing GameState matrix and using checkWinner for red player (1) to check for a path on transpose matrix
*/
checkWinner(-1, GameState, Size, Row, Column):-
    transpose(GameState, Transpose),
    checkWinner(1, Transpose, Size, Row, Column).


%checkHorizontalPath(+GameState, +Row, +FinalCol)
/*
Check if there is a floodfill replaced char in the final column, meaning a path for the red player
*/
checkHorizontalPath(GameState, Row, FinalCol):-
    Row =< FinalCol,
    getValueFromMatrix(GameState, Row, FinalCol, 2).

/*
If failed, check for a path in the next row and final column
*/
checkHorizontalPath(GameState, Row, FinalCol):-
    Row =< FinalCol,
    NextRow is Row + 1,
    checkHorizontalPath(GameState, NextRow, FinalCol).
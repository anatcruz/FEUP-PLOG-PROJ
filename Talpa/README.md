# Talpa

## T6 Talpa_1
| Name             | Number    | E-Mail               |
| ---------------- | --------- | ---------------------|
| Ana Teresa Feliciano da Cruz  | 201806460 | up201806460@fe.up.pt |
| André Filipe Meireles do Nascimento | 201806461 | up201806461@fe.up.pt |

---

## Installation and Execution

### Windows
 Execute `spqin.exe`, click on `File`, then `Consult` and select the file `talpa.pl`. On the SicStus console type `play.` and press enter.

### Linux
We don't know, but will figure it out

## Game Description 

Talpa is a 2-players game that belongs to Connection Games family. It is played on a square board with variable size. While in most connection games players try to make a chain built of their pieces, in Talpa players remove pieces to make a path of empty spaces.

The goal is to make a path that connects both player sides, marked by the player's character, of the board.

### Rules

Initially the board is filled with blue and red pieces, forming a checkerboard pattern. A player moves by picking up one of his pieces and capturing an orthogonally adjacent opponent's piece. The captured piece is removed from the board and replaced by the capturing piece. The capture is mandatory if possible. When capturing becomes impossible, players remove one of their pieces per turn. A player loses the game immediately if he makes a move that opens the path for the other player.

No draws are possible in Talpa.

---

[Description](https://www.boardgamegeek.com/boardgame/80657/talpa) | [Rules](https://nestorgames.com/rulebooks/TALPA_EN.pdf) | [Buy](https://nestorgames.com/#talpa_detail)

---

## Game Logic

### Game State Representation

#### **Board**

The board is represented by a list of sublists, each sublist is a row of the board. On each place of the board exists one out of three characters:

- `1` - Red player's piece
- `2` - Blue player's piece
- `0` - empty cell to create a path to victory!

##### **Possible GameStates**

**Initial:**

```
initialGameState([
    [1,-1,1,-1,1,-1,1,-1],
    [-1,1,-1,1,-1,1,-1,1],
    [1,-1,1,-1,1,-1,1,-1],
    [-1,1,-1,1,-1,1,-1,1],
    [1,-1,1,-1,1,-1,1,-1],
    [-1,1,-1,1,-1,1,-1,1],
    [1,-1,1,-1,1,-1,1,-1],
    [-1,1,-1,1,-1,1,-1,1]
]).
```

**Mid game:**

```
midGameState([
    [1,-1,-1,0,1,0,1,-1],
    [0,-1,0,0,0,1,0,-1],
    [-1,1,1,0,-1,0,1,-1],
    [0,0,-1,1,0,0,-1,0],
    [0,1,1,1,1,-1,1,0],
    [0,-1,-1,0,0,0,0,1],
    [1,-1,1,-1,1,0,-1,0],
    [-1,1,-1,-1,0,-1,-1,1]
]).
```

**End game:**

(representing RED victory)

```
finalGameState([
    [1,-1,-1,0,1,0,1,-1],
    [0,-1,0,0,0,1,0,-1],
    [-1,1,1,0,-1,0,-1,0],
    [0,0,-1,1,0,0,-1,0],
    [0,-1,0,1,1,1,0,0],
    [0,1,0,0,0,0,0,1],
    [0,0,0,0,-1,0,-1,0],
    [-1,1,1,-1,0,0,-1,0]
]).
```

#### **Player**

The player´s type can have one out of three values:

- `Player` - it is a human's turn
- `Random` - it is a random bot's turn
- `Greedy` - it is a greedy bot's turn
---

### Game State Visualization

#### Menus

When iniciating the game with the predicate `play/0`, it is displayed a main menu with the options: play, rules, collaborators and exit. Each of these options leads to another menu, but being in any of the other menus, the user is able to go back to the main menu by pressing `0` and then enter. 

All the menus after the Play menu have options about the board size, the game type, the bot's difficulties and the first player. 
The user to select an option just needs to press the corresponding number and enter.
The inputs are read by `readMenuOption(-Option)` and checked by `validateMenuOption(OptionInput, ValidOption, NumOptions)`.

After that the `initial(-GameState, +Size)` and the `printBoard(+GameState)` are called to display the board.

#### Board

We used `genarateBoard(-GameState,+Size)` to create the board with the chosen size, this builds the board row by row with the predicate `buildRow(+Row,-BuiltRow,+Size,+ColIndex,+Cell)`.

Then the board is printed by `printBoard(+Board)`, that calls `printBoardHeader(+Size)`, printing the columns indicator, the separators anda line of X's on the top of the board representing the top side of the blue player.

It also calls the `printMatrix(+Board,+N,+Size)` that prints the matrix with the row indicators (using `get_letter(+Row, -Letter)` to represent the Row with the corresponding Letter), calls `printRow(List)` that uses the `character(+MatrixValue, -Character)` (to represent the MatrixValue with the corresponding Character, which represents a cell in the board), prints the separators and a line of O's on the left side of the board representing the left side of the red player.

At last it is called the `printBoardBottom(+Size)` that prints a line of X's on the bottom of the board representing the bottom side of the blue player.

To display **Blue** and **Red** player's **pieces** we used the characters `X` and `O` respectively, and for the **empty board cells** used a `white space`.

**Initial Board console view:**

![initalGameState](img/initialGameState.jpg)

**Mid game Board console view:**

![midGameState](img/midGameState.jpg)


**Game end Board console view:**

(representing RED victory)

![finalGameState](img/finalGameState.jpg)

---
### Valid Moves

The `valid_moves(+GameState,+Size,+Player,-ListOfPossibleMoves)` returns on ListOfPossibleMoves a list of moves in the format `[[SelectedRow-SelectedColumn, MoveRow-MoveColumn], [SelRow2-SelCol2, MovRow2-MovCol2], ...]`.
This predicate first calls `getPlayerInMatrix(+GameState,+Size,+Player,-Positions)` that goes through the board and gets the position of all the player's pieces, the positions are stored in Positions.

Then it is called `getAllPossibleMoves(+GameState,+Size,+Palyer,+Positions,-ListOfPossibleMoves)` that using `checkMove(+GameState,+Size,+SelRow,+SelColumn,+Player,-ListOfMoves)` sees if there are any possible movements in all directions (up, down, right and left). This verification consists of checking the existence of an enemy's piece in the surrounding orthogonal position.

The predicate will fail if the ListOfPossible moves is empty, meaning there aren't any available moves, so the player now has to remove their own piece.

---
### Making moves

For the player to be able to execute a move, the `choose_move(+GameState,+Size,+Player,+PlayerType,-Move)` predicate is executed first. This predicate calls, in case there are available movements, the `selectPiecePosition(+Board,+Size,Player,-SelRow,-SelColumn)` and `movePiecePosition(+Board,+Size,+Player,+SelRow,+SelColumn,-FinalRow,-FinalColumn)`, in the other case it only calls `removePiecePosition(+Board,+Size,+Player,-SelRow,-SelColumn)`.

The `selectPiecePosition` asks the player for position inputs for the selected piece and checks both row and column inputs (`manageInputs`), if the player is selecting one of their pieces and if there is any possible movement for that position. If any of this verifications fails, the predicate asks again for input.

The `movePiecePosition` asks the player for position inputs for the piece they want to replace, checks both row and column inputs (`manageInputs`) and verifies if the moving position is orthogonal and adjacent. If any of this verifications fails, the predicate asks again for input.

The `removePiecePosition` is similar to `selectPiecePosition`, but only verifies the inputs and if the player is selecting one of their pieces. Once that this predicate is called knowing that there aren't any available moves.

Lastely, if all the verifications checks out, then it is called `move(+GameState,+Player,+Move,-NewGameState)` that replaces the old player's position for an empty space and the piece at the moving position to the player's piece, obtaining the new GameState.

### Game Over
 
To check if the game is over , according to the rules already presented, we use `game_over(+GameState, +Size, +Player, -Winner)`. This predicate uses `checkWinner(+Player, +GameState, +Size, +Row, +Column)`, first checking if the current Player won (since he was last round enemy and `play/5` calls `game_over/4` before the player turn) and then checking if the current Player´s adversary won.
 
To verify if the red player won `checkWinner/4` uses, row by row, `tryFloodFill(+Matrix, +Size, +Row, +Column, +FinalMatrix)` to floodfill from the current row and first column, and `checkHorizontalPath(+GameState, +Row, +FinalCol)` to check if there is a floodfill character in the final column, meaning there is a path from the left to the right side of the board. Reaching the final row and no path is found means the red player did not win yet.
 
To verify if the blue player won we simply use the transpose board matrix and use the `checkWinner/4` for the red player.

---
### Computer Move
 
To choose a computer move the `choose_move(+GameState, +Size, +Player, +Level, -Move)` predicate is used, where `Level` will be 'Easy' or 'Normal', the two difficulties we implemented in our game.
 
First `valid_moves/4` is used to get all the possible moves, and then `movePiecePositionBot(+GameState, +Size, +Player, +Level, +ListOfPossibleMoves, -Move)` will choose a move from `ListOfPossibleMoves` according to the level.
 
If `valid_moves/4` failed `getPlayerInMatrix(+GameState, +Size, +Player, -ListOfPositions)` will be used to get all the players postions and `removePiecePositionBot(+GameState, +Size, +Player, +Level, +ListOfPositions, -Move)` returns a move from `ListOfPositions`.
 
#### Easy
 
In the easy difficulty the move chosen will be random and `movePiecePositionBot/6` and `removePiecePositionBot/6` return a random move (using `random_member(-Elem, +List)`).
 
#### Normal
 
In the normal difficulty the move will be greedy, choosing the best move in the current turn. In this case both  `movePiecePositionBot/6` and `removePiecePositionBot/6` select a move using `findall(+Template, +Generator, -List)`. For `Generator` the `move/4` and `value/4` predicates are used to evaluate the board after a move. The `List` is `Value-SelectedPosition-MovePosition`, when there are available moves, and as `Value-SelectedPosition` otherwise. Then the list is sorted (using `sort(+List1, -List2)`), being in ascending order of Values and `last(+List, -Last)` is used so we can get the move with the highest value.

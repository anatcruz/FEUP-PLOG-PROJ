# Talpa

## T6GTalpa_1
| Name             | Number    | E-Mail               |
| ---------------- | --------- | ---------------------|
| Ana Teresa Feliciano da Cruz  | 201806460 | up201806460@fe.up.pt |
| André Filipe Meireles do Nascimento | 201806461 | up201806461@fe.up.pt |

---

## Game Description 

Talpa is a 2-players game that belongs to Connection Games family. While in most connection games players try to make a chain built of their pieces, in Talpa players remove pieces to make a path of empty spaces.

The goal is to "dig" a "tunnel" of orthogonally adjacent empty spaces connecting player's sides of the board.

## Rules

Initially the board is filled with blue and red pieces, forming a checkerboard pattern. A player moves by picking up one of his pieces and capturing an orthogonally adjacent opponent's piece. The captured piece is removed from the board and replaced by the capturing piece. The capture is mandatory if possible. When capturing becomes impossible, players remove one of their stones per turn.

No draws are possible in Talpa.

---

[Description](https://www.boardgamegeek.com/boardgame/80657/talpa) | [Rules](https://nestorgames.com/rulebooks/TALPA_EN.pdf) | [Buy](https://nestorgames.com/#talpa_detail)

---

## Game State Representation

- red - Red player's pieces;

- blue - Blue player's pieces;

- empty - Empty cell to create a path to victory!

**Initial Board:**

```
initialGameState([
    [red,blue,red,blue,red,blue,red,blue],
    [blue,red,blue,red,blue,red,blue,red],
    [red,blue,red,blue,red,blue,red,blue],
    [blue,red,blue,red,blue,red,blue,red],
    [red,blue,red,blue,red,blue,red,blue],
    [blue,red,blue,red,blue,red,blue,red],
    [red,blue,red,blue,red,blue,red,blue],
    [blue,red,blue,red,blue,red,blue,red]
]).
```

**Mid game Board:**

```
midGameState([
    [red,blue,blue,empty,red,empty,red,blue],
    [empty,blue,empty,empty,empty,red,empty,blue],
    [blue,red,red,empty,blue,empty,red,blue],
    [empty,empty,blue,red,empty,empty,blue,empty],
    [empty,red,red,red,red,blue,red,empty],
    [empty,blue,blue,empty,empty,empty,empty,red],
    [red,blue,red,blue,red,empty,blue,empty],
    [blue,red,blue,blue,empty,blue,blue,red]
]).
```

**Game end Board:**

(representing RED victory)

```
finalGameState([
    [red,blue,blue,empty,red,empty,red,blue],
    [empty,blue,empty,empty,empty,red,empty,blue],
    [blue,red,red,empty,blue,empty,blue,empty],
    [empty,empty,blue,red,empty,empty,blue,empty],
    [empty,blue,empty,red,red,red,empty,empty],
    [empty,red,empty,empty,empty,empty,empty,red],
    [empty,empty,empty,empty,blue,empty,blue,empty],
    [blue,red,red,blue,empty,empty,blue,empty]
]).
```

## Game State Visualization

To display **Blue** and **Red** player's **pieces** we used the characters **X** and **O** respectively, and for the **empty board cells** used a **white space**.

To print the game board we used some predicates:
- `printBoard(+Board)` prints the columns' header and calls `printMatrix(+Board, +RowIndex)`.
- `printMatrix(+Board, +RowIndex)` prints the rows' letters (using `letter(+RowIndex, -Letter)` to represent the RowIndex with the corresponding Letter), calls `printRow(List)` and recursively calls itself.
- `printRow(List)` prints the list's Head (using `character(+MatrixValue, -Character)` to represent the MatrixValue with the corresponding Character) which represents a cell in the board, and recursively calls itself with the list's Tail.

**Initial Board console view:**

![initalGameState](img/initialGameState.jpg)

**Mid game Board console view:**

![midGameState](img/midGameState.jpg)


**Game end Board console view:**

(representing RED victory)

![finalGameState](img/finalGameState.jpg)

---

## Final Notes

To run the program you simply need to consult src/talpa.pl in SICStus Prolog and type _play._ in the console.

For rows input type _'R.'_ (where R represents a letter) and for columns input type _C._ (where C represents a number).
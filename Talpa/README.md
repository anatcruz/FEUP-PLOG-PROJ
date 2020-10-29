# Talpa

## Turma 6 Talpa_1
| Name             | Number    | E-Mail               |
| ---------------- | --------- | ---------------------|
| Ana Teresa Cruz  | 201806460 | up201806460@fe.up.pt |
| André Nascimento | 201806461 | up201806461@fe.up.pt |

---

### Game Description 

Talpa is a 2-players game that belongs to Connection Games family. While in most connection games players try to make a chain built of their pieces, in Talpa players remove pieces to make a path of empty spaces.

The goal is to "dig" a "tunnel" of orthogonally adjacent empty spaces connecting player's sides of the board.

### Rules

Initially the board is filled with blue and red pieces, forming a checkerboard pattern. A player moves by picking up one of his pieces and capturing an orthogonally adjacent opponent's piece. The captured piece is removed from the board and replaced by the capturing piece. The capture is mandatory if possible. When capturing becomes impossible, players remove one of their stones per turn.

No draws are possible in Talpa.

---

[Description](https://www.boardgamegeek.com/boardgame/80657/talpa) | [Rules](https://nestorgames.com/rulebooks/TALPA_EN.pdf) | [Buy](https://nestorgames.com/#talpa_detail)

---

### Game State Representation

- red - Red player's pieces, represented by 'O' character in console;

- blue - Blue player's pieces, represented by 'X' character in console;

- empty - Empty space to create a path, represented by ' ' character (white space) in console.

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

Console view:

```
       | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
       +---+---+---+---+---+---+---+---+
         X   X   X   X   X   X   X   X  
---+   +---+---+---+---+---+---+---+---+
 A | O | O | X | O | X | O | X | O | X | O
---+   +---+---+---+---+---+---+---+---+
 B | O | X | O | X | O | X | O | X | O | O
---+   +---+---+---+---+---+---+---+---+
 C | O | O | X | O | X | O | X | O | X | O
---+   +---+---+---+---+---+---+---+---+
 D | O | X | O | X | O | X | O | X | O | O
---+   +---+---+---+---+---+---+---+---+
 E | O | O | X | O | X | O | X | O | X | O
---+   +---+---+---+---+---+---+---+---+
 F | O | X | O | X | O | X | O | X | O | O
---+   +---+---+---+---+---+---+---+---+
 G | O | O | X | O | X | O | X | O | X | O
---+   +---+---+---+---+---+---+---+---+
 H | O | X | O | X | O | X | O | X | O | O
---+   +---+---+---+---+---+---+---+---+
         X   X   X   X   X   X   X   X 
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

Console view:

```
       | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
       +---+---+---+---+---+---+---+---+
         X   X   X   X   X   X   X   X  
---+   +---+---+---+---+---+---+---+---+
 A | O | O | X | X |   | O |   | O | X | O
---+   +---+---+---+---+---+---+---+---+
 B | O |   | X |   |   |   | O |   | X | O
---+   +---+---+---+---+---+---+---+---+
 C | O | X | O | O |   | X |   | O | X | O
---+   +---+---+---+---+---+---+---+---+
 D | O |   |   | X | O |   |   | X |   | O
---+   +---+---+---+---+---+---+---+---+
 E | O |   | O | O | O | O | X | O |   | O
---+   +---+---+---+---+---+---+---+---+
 F | O |   | X | X |   |   |   |   | O | O
---+   +---+---+---+---+---+---+---+---+
 G | O | O | X | O | X | O |   | X |   | O
---+   +---+---+---+---+---+---+---+---+
 H | O | X | O | X | X |   | X | X | O | O
---+   +---+---+---+---+---+---+---+---+
         X   X   X   X   X   X   X   X 
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

Console view:

```
       | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
       +---+---+---+---+---+---+---+---+
         X   X   X   X   X   X   X   X  
---+   +---+---+---+---+---+---+---+---+
 A | O | O | X | X |   | O |   | O | X | O
---+   +---+---+---+---+---+---+---+---+
 B | O |   | X |   |   |   | O |   | X | O
---+   +---+---+---+---+---+---+---+---+
 C | O | X | O | O |   | X |   | X |   | O
---+   +---+---+---+---+---+---+---+---+
 D | O |   |   | X | O |   |   | X |   | O
---+   +---+---+---+---+---+---+---+---+
 E | O |   | X |   | O | O | O |   |   | O
---+   +---+---+---+---+---+---+---+---+
 F | O |   | O |   |   |   |   |   | O | O
---+   +---+---+---+---+---+---+---+---+
 G | O |   |   |   |   | X |   | X |   | O
---+   +---+---+---+---+---+---+---+---+
 H | O | X | O | O | X |   |   | X |   | O
---+   +---+---+---+---+---+---+---+---+
         X   X   X   X   X   X   X   X
```
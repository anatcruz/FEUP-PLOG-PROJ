%Select menu option and call the respective action
selectMenuOption(NumOptions, ValidOption) :-
    write('\nInsert option:\n'),
    repeat,
    readMenuOption(OptionInput),
    validateMenuOption(OptionInput, ValidOption, NumOptions), !.

%Reads menu option input code, ignoring newlines (ascii code 10)
readMenuOption(Option) :-
    write('  -> '),
    get_code(Option),
    Option\=10.

%Checks is next char is a newline (else 2 chars in input, thus failing), converts ascii code to number and checks if is valid
validateMenuOption(OptionInput, ValidOption, NumOptions) :-
    peek_char('\n'),
    ValidOption is OptionInput - 48,
    between(0, NumOptions, ValidOption),
    skip_line.
validateMenuOption(_, _, _) :-
    write('\nInvalid option! Try again:\n'), skip_line, fail.

%Displays initial menu
mainMenu :-
    repeat,
    write('\33\[2J'),
    write('\n\n ____________________________________\n'),
    write('|                                    |\n'),
    write('|     _____       _                  |\n'),
    write('|    |_   _|__ _ | | ____  __ _      |\n'),
    write('|      | | / _` || ||  _ |/ _` |     |\n'),
    write('|      |_| |__,_||_|| .__/|__,_|     |\n'),
    write('|                   |_|              |\n'),
    write('|                                    |\n'),
    write('|             Welcome!               |\n'),
    write('|                                    |\n'),
    write('|             1. Play                |\n'),
    write('|                                    |\n'),
    write('|             2. Rules               |\n'),
    write('|                                    |\n'),
    write('|          3. Collaborators          |\n'),
    write('|                                    |\n'),
    write('|             0. Exit                |\n'),
    write('|                                    |\n'),
    write('|                                    |\n'),
    write('|____________________________________|\n\n'),
    selectMenuOption(3, ValidOption),
    mainMenuAction(ValidOption).

%Play
mainMenuAction(1) :-
    playersMenu.

%Rules
mainMenuAction(2) :-
    rulesMenu.

%Exit
mainMenuAction(0) :-
    write('\nWe are sad to see you go... :(\n'),
    write('Thank you for playing!\n').

%Displays rules menu
rulesMenu :-
    write('\33\[2J'),
    write('\n\n ____________________________________________\n'),
    write('|     _____       _                          |\n'),
    write('|    |_   _|__ _ | | ____  __ _              |\n'),
    write('|      | | / _` || ||  _ |/ _` |             |\n'),
    write('|      |_| |__,_||_|| .__/|__,_|             |\n'),
    write('|                   |_|                      |\n'),
    write('|                                            |\n'),
    write('|              Rules                         |\n'),
    write('|                                            |\n'),
    write('|-Choose one of your pieces to move and      |\n'),
    write('| the moving position                        |\n'),
    write('|                                            |\n'),
    write('|-You can only move one position orthogonally|\n'),
    write('|                                            |\n'),
    write('|-When no moves available, remove your own   |\n'),
    write('| piece                                      |\n'),
    write('|                                            |\n'),
    write('|-Open a path linking both your player sides |\n'),
    write('| of the board                               |\n'),
    write('|           0. Main Menu                     |\n'),
    write('|____________________________________________|\n\n'),
    selectMenuOption(0, ValidOption),
    mainMenu.

%Collaborators
mainMenuAction(3) :-
    write('\33\[2J'),
    write('\n\n ____________________________________\n'),
    write('|                                    |\n'),
    write('|     _____       _                  |\n'),
    write('|    |_   _|__ _ | | ____  __ _      |\n'),
    write('|      | | / _` || ||  _ |/ _` |     |\n'),
    write('|      |_| |__,_||_|| .__/|__,_|     |\n'),
    write('|                   |_|              |\n'),
    write('|                                    |\n'),
    write('|       This game was made by:       |\n'),
    write('|                                    |\n'),
    write('|          Ana Teresa Cruz           |\n'),
    write('|                                    |\n'),
    write('|          Andre Nascimento          |\n'),
    write('|                                    |\n'),
    write('|                                    |\n'),
    write('|            0. Main Menu            |\n'),
    write('|                                    |\n'),
    write('|                                    |\n'),
    write('|                                    |\n'),
    write('|____________________________________|\n\n'),
    selectMenuOption(0, ValidOption),
    mainMenu.

%Displays Play menu
playersMenu :-
    write('\33\[2J'),
    write('\n\n ____________________________________\n'),
    write('|                                    |\n'),
    write('|     _____       _                  |\n'),
    write('|    |_   _|__ _ | | ____  __ _      |\n'),
    write('|      | | / _` || ||  _ |/ _` |     |\n'),
    write('|      |_| |__,_||_|| .__/|__,_|     |\n'),
    write('|                   |_|              |\n'),
    write('|                                    |\n'),
    write('|                                    |\n'),
    write('|                                    |\n'),
    write('|        1. Player VS Player         |\n'),
    write('|                                    |\n'),
    write('|        2. Player VS Computer       |\n'),
    write('|                                    |\n'),
    write('|       3. Computer VS Computer      |\n'),
    write('|                                    |\n'),
    write('|            0. Main Menu            |\n'),
    write('|                                    |\n'),
    write('|                                    |\n'),
    write('|____________________________________|\n\n'),
    selectMenuOption(3, ValidOption),
    menuAction(ValidOption).

%Player vs Player
menuAction(1) :-
    boardSizeMenu(GameState, Size),
    printBoard(GameState),
    play(GameState, Size, 1, 'Player', 'Player').
    
%Player vs Computer
menuAction(2) :-
    boardSizeMenu(GameState, Size), !,
    botDificultyMenu(Difficulty),
    chooseFirstPlayerMenu(First),
    firstAction(First, GameState, Size, Difficulty).


menuAction(3) :-
    boardSizeMenu(GameState, Size), !,
    botsDifficultyMenu(ValidOption),
    modeAction(ValidOption, GameState, Size).

%Displays board size menu
boardSizeMenu(GameState, Size):-
    write('\33\[2J'),
    write('\n\n ____________________________________\n'),
    write('|                                    |\n'),
    write('|     _____       _                  |\n'),
    write('|    |_   _|__ _ | | ____  __ _      |\n'),
    write('|      | | / _` || ||  _ |/ _` |     |\n'),
    write('|      |_| |__,_||_|| .__/|__,_|     |\n'),
    write('|                   |_|              |\n'),
    write('|                                    |\n'),
    write('|    Choose the board dimensions     |\n'),
    write('|                                    |\n'),
    write('|              1. 6 x 6              |\n'),
    write('|                                    |\n'),
    write('|              2. 8 x 8              |\n'),
    write('|                                    |\n'),
    write('|            0. Main Menu            |\n'),
    write('|                                    |\n'),
    write('|                                    |\n'),
    write('|                                    |\n'),
    write('|                                    |\n'),
    write('|____________________________________|\n\n'),
    selectMenuOption(2, ValidOption),
    sizeAction(ValidOption, GameState, Size).

sizeAction(1, GameState, Size) :-
    initial(GameState, 6),
    Size is 6.

sizeAction(2, GameState, Size) :-
    initial(GameState, 8),
    Size is 8.

sizeAction(0, _, _) :-
    fail.

%Displays the difficulty bot menu
botDificultyMenu(Difficulty) :-
    write('\33\[2J'),
    write('\n\n ____________________________________\n'),
    write('|                                    |\n'),
    write('|     _____       _                  |\n'),
    write('|    |_   _|__ _ | | ____  __ _      |\n'),
    write('|      | | / _` || ||  _ |/ _` |     |\n'),
    write('|      |_| |__,_||_|| .__/|__,_|     |\n'),
    write('|                   |_|              |\n'),
    write('|                                    |\n'),
    write('|  Choose the computer s difficulty  |\n'),
    write('|                                    |\n'),
    write('|          1. Easy (Random)          |\n'),
    write('|                                    |\n'),
    write('|         2. Normal (Greedy)         |\n'),
    write('|                                    |\n'),
    write('|           0. Main Menu             |\n'),
    write('|                                    |\n'),
    write('|                                    |\n'),
    write('|                                    |\n'),
    write('|                                    |\n'),
    write('|____________________________________|\n\n'),
    selectMenuOption(2, ValidOption),
    difficultyAction(ValidOption, Difficulty).

difficultyAction(1, Difficulty) :-
    Difficulty = 'Random'.

difficultyAction(2, Difficulty) :-
    Difficulty = 'Greedy'.

difficultyAction(0, _) :-
    fail.

chooseFirstPlayerMenu(First) :-
    write('\33\[2J'),
    write('\n\n ____________________________________\n'),
    write('|                                    |\n'),
    write('|     _____       _                  |\n'),
    write('|    |_   _|__ _ | | ____  __ _      |\n'),
    write('|      | | / _` || ||  _ |/ _` |     |\n'),
    write('|      |_| |__,_||_|| .__/|__,_|     |\n'),
    write('|                   |_|              |\n'),
    write('|                                    |\n'),
    write('|Choose the Red Player (first Player)|\n'),
    write('|                                    |\n'),
    write('|          1. Player                 |\n'),
    write('|                                    |\n'),
    write('|         2. Computer                |\n'),
    write('|                                    |\n'),
    write('|           0. Main Menu             |\n'),
    write('|                                    |\n'),
    write('|                                    |\n'),
    write('|                                    |\n'),
    write('|                                    |\n'),
    write('|____________________________________|\n\n'),
    selectMenuOption(2, First).

firstAction(1, GameState, Size, Difficulty) :-
    printBoard(GameState),
    play(GameState, Size, 1, 'Player', Difficulty).

firstAction(2, GameState, Size, Difficulty) :-
    printBoard(GameState),
    play(GameState, Size, 1, Difficulty, 'Player').

firstAction(0, _, _, _) :-
    fail.

botsDifficultyMenu(ValidOption) :-
    write('\33\[2J'),
    write('\n\n ____________________________________\n'),
    write('|                                    |\n'),
    write('|     _____       _                  |\n'),
    write('|    |_   _|__ _ | | ____  __ _      |\n'),
    write('|      | | / _` || ||  _ |/ _` |     |\n'),
    write('|      |_| |__,_||_|| .__/|__,_|     |\n'),
    write('|                   |_|              |\n'),
    write('|                                    |\n'),
    write('|Choose the difficulty for the computers|\n'),
    write('|                                    |\n'),
    write('|          1. Easy VS Easy           |\n'),
    write('|                                    |\n'),
    write('|         2. Easy VS Normal          |\n'),
    write('|                                    |\n'),
    write('|           3. Normal VS Easy        |\n'),
    write('|                                    |\n'),
    write('|            4. Normal VS Normal     |\n'),
    write('|                                    |\n'),
    write('|                 0. Main Menu       |\n'),
    write('|____________________________________|\n\n'),
    selectMenuOption(3, ValidOption).

modeAction(1, GameState, Size) :-
    printBoard(GameState),
    play(GameState, Size, 1, 'Random', 'Random').

modeAction(2, GameState, Size) :-
    printBoard(GameState),
    play(GameState, Size, 1, 'Random', 'Greedy').

modeAction(3, GameState, Size) :-
    printBoard(GameState),
    play(GameState, Size, 1, 'Greedy', 'Random').
    
modeAction(4, GameState, Size) :-
    printBoard(GameState),
    play(GameState, Size, 1, 'Greedy', 'Greedy').

modeAction(0, _, _) :-
    fail.
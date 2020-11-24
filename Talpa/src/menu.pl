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
    write('|____________________________________|\n\n'),
    selectMenuOption(3, ValidOption),
    mainMenuAction(ValidOption).

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
    write('|____________________________________|\n\n'),
    selectMenuOption(3, ValidOption),
    menuAction(ValidOption).

%Displays board size menu
boardSizeMenu(ValidOption, GameState, Size):-
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
    write('|____________________________________|\n\n'),
    selectMenuOption(2, ValidOption),
    sizeAction(ValidOption, GameState, Size).

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
    write('|____________________________________|\n\n'),
    selectMenuOption(2, Difficulty).

%Displays rules menu
rulesMenu :-
    write('\33\[2J'),
    write('\n\n ____________________________________\n'),
    write('|                                    |\n'),
    write('|     _____       _                  |\n'),
    write('|    |_   _|__ _ | | ____  __ _      |\n'),
    write('|      | | / _` || ||  _ |/ _` |     |\n'),
    write('|      |_| |__,_||_|| .__/|__,_|     |\n'),
    write('|                   |_|              |\n'),
    write('|                                    |\n'),
    write('|              Rules                 |\n'),
    write('|                                    |\n'),
    write('|-Player chooses one of their pieces |\n'),
    write('|                                    |\n'),
    write('|-Player chooses the moving position |\n'),
    write('|                                    |\n'),
    write('|-Player can only move orthogonally  |\n'),
    write('|                                    |\n'),
    write('|                                    |\n'),
    write('|           0. Main Menu             |\n'),
    write('|____________________________________|\n\n'),
    selectMenuOption(0, ValidOption),
    mainMenu.

%Play
mainMenuAction(1) :-
    playersMenu.

%Rules
mainMenuAction(2) :-
    rulesMenu.

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
    write('|____________________________________|\n\n'),
    selectMenuOption(0, ValidOption),
    mainMenu.

%Exit
mainMenuAction(0) :-
    write('\nWe are sad to see you go... :(\n'),
    write('If you enjoyed please consider staring our repository https://github.com/anatcruz/FEUP-PLOG-PROJ :D\n').

%Player vs Player
menuAction(1) :-
    boardSizeMenu(ValidOption, GameState, Size),
    printBoard(GameState),
    play(GameState, Size, 1, 'Player', 'Player').
    
%Player vs Computer
menuAction(2) :-
    boardSizeMenu(ValidOption, GameState, Size),
    botDificultyMenu(Difficulty),
    botAction(Difficulty, GameState, Size).

menuAction(3) :-
    boardSizeMenu(ValidOption, GameState, Size).

sizeAction(1, GameState, Size) :-
    initial(GameState, 6),
    Size is 6.

sizeAction(2, GameState, Size) :-
    initial(GameState, 8),
    Size is 8.

sizeAction(0, _, _) :-
    fail.

botAction(1, GameState, Size) :-
    botVSplayerPlay(GameState, Size).

botAction(2, GameState, Size) :-
    botVSplayerPlay(GameState, Size).

botAction(0, _, _) :-
    mainMenu.

botVSplayerPlay(GameState, Size) :-
    printBoard(GameState),
    play(GameState, Size, 1, 'Player', 'Random').


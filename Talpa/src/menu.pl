mainMenu :-
    repeat,
    write('\33\[2J'),
    write('\n\n ___________________________________\n'),
    write('|                                   |\n'),
    write('|                                   |\n'),
    write('|     _____       _                 |\n'),
    write('|    |_   _|__ _ | | ____  __ _     |\n'),
    write('|      | | / _` || ||  _ |/ _` |    |\n'),
    write('|      |_| |__,_||_|| .__/|__,_|    |\n'),
    write('|                   |_|             |\n'),
    write('|                                   |\n'),
    write('|        1. Player vs Player        |\n'),
    write('|                                   |\n'),
    write('|        2. Player vs Computer      |\n'),
    write('|                                   |\n'),
    write('|              0. Exit              |\n'),
    write('|                                   |\n'),
    write('|                                   |\n'),
    write('|___________________________________|\n\n'),
    selectMenuOption(2, ValidOption),
    menuAction(ValidOption).

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

%Exit
menuAction(0) :-
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

boardSizeMenu(ValidOption, GameState, Size):-
    write('\33\[2J'),
    write('\n\n ___________________________________\n'),
    write('|                                   |\n'),
    write('|                                   |\n'),
    write('|     _____       _                 |\n'),
    write('|    |_   _|__ _ | | ____  __ _     |\n'),
    write('|      | | / _` || ||  _ |/ _` |    |\n'),
    write('|      |_| |__,_||_|| .__/|__,_|    |\n'),
    write('|                   |_|             |\n'),
    write('|                                   |\n'),
    write('|          1. 6 x 6 Board           |\n'),
    write('|                                   |\n'),
    write('|          2. 8 x 8 Board           |\n'),
    write('|                                   |\n'),
    write('|          0. Main Menu             |\n'),
    write('|                                   |\n'),
    write('|                                   |\n'),
    write('|___________________________________|\n\n'),
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

botAction(1, GameState, Size) :-
    botVSplayerPlay(GameState, Size).

botAction(2, GameState, Size) :-
    botVSplayerPlay(GameState, Size).

botAction(0, _, _) :-
    mainMenu.

botVSplayerPlay(GameState, Size) :-
    printBoard(GameState),
    play(GameState, Size, 1, 'Player', 'Random').

botDificultyMenu(Difficulty) :-
    write('\33\[2J'),
    write('\n\n ___________________________________\n'),
    write('|                                   |\n'),
    write('|                                   |\n'),
    write('|     _____       _                 |\n'),
    write('|    |_   _|__ _ | | ____  __ _     |\n'),
    write('|      | | / _` || ||  _ |/ _` |    |\n'),
    write('|      |_| |__,_||_|| .__/|__,_|    |\n'),
    write('|                   |_|             |\n'),
    write('|                                   |\n'),
    write('|          1. easy (random)         |\n'),
    write('|                                   |\n'),
    write('|          2. normal                |\n'),
    write('|                                   |\n'),
    write('|          0. Main Menu             |\n'),
    write('|                                   |\n'),
    write('|                                   |\n'),
    write('|___________________________________|\n\n'),
    selectMenuOption(2, Difficulty).
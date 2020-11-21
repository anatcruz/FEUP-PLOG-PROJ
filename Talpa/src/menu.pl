printMainMenu :-
    write('\n\n ___________________________________\n'),
    write('|                                   |\n'),
    write('|                                   |\n'),
    write('|     _____       _                 |\n'),
    write('|    |_   _|__ _ | | ____  __ _     |\n'),
    write('|      | | / _` || ||  _ |/ _` |    |\n'),
    write('|      |_| |__,_||_|| .__/|__,_|    |\n'),
    write('|                   |_|             |\n'),
    write('|                                   |\n'),
    write('|         1. Player vs Player       |\n'),
    write('|                                   |\n'),
    write('|        2. Player vs Computer      |\n'),
    write('|                                   |\n'),
    write('|               0. Exit             |\n'),
    write('|                                   |\n'),
    write('|                                   |\n'),
    write('|___________________________________|\n\n').

%Select menu option and call the respective action
selectMainMenuOption(NumOptions) :-
    write('\nInsert option:\n'),
    repeat,
    readMenuOption(OptionInput),
    validateMenuOption(OptionInput, ValidOption, NumOptions),
    menuAction(ValidOption).

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

%Player vs Player 6x6
menuAction(1) :-
    boardSizeMenu,
    selectBoardSizeOption(2).

%Player vs Player 8x8
menuAction(2) :-
    initial(GameState,8),
    printBoard(GameState),
    playerVSbot(GameState, 8, 1).

boardSizeMenu:-
    write('\n\n1. 6x6 Board\n2. 8x8 Board\n0. Main Menu').

selectBoardSizeOption(NumOptions):-
    write('\nInsert option:\n'),
    repeat,
    readMenuOption(OptionInput),
    validateMenuOption(OptionInput, ValidOption, NumOptions),
    sizeAction(ValidOption).

sizeAction(0):-
    menuAction(0).

sizeAction(1):-
    initial(GameState,6),
    printBoard(GameState),
    playerVSplayer(GameState, 6, 1).

sizeAction(2) :-
    initial(GameState,8),
    printBoard(GameState),
    playerVSplayer(GameState, 8, 1).
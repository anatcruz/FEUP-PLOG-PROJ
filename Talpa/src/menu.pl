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
    write('|     1. Player vs Player (6x6)     |\n'),
    write('|                                   |\n'),
    write('|     2. Player vs Player (8x8)     |\n'),
    write('|                                   |\n'),
    write('|     0. Exit                       |\n'),
    write('|                                   |\n'),
    write('|                                   |\n'),
    write('|___________________________________|\n\n').


selectMenuOption(NumOptions) :-
    write('\nInsert option:\n'),
    repeat,
    readMenuOption(OptionInput),
    validateMenuOption(OptionInput, ValidOption, NumOptions),
    menuAction(ValidOption).

readMenuOption(Option) :-
    write('  -> '),
    get_code(Option),
    Option\=10.

validateMenuOption(OptionInput, ValidOption, NumOptions) :-
    peek_char('\n'),
    ValidOption is OptionInput - 48,
    between(0, NumOptions, ValidOption),
    skip_line.

validateMenuOption(_, _, _) :-
    write('\nInvalid option! Try again:\n'), skip_line, fail.

menuAction(0) :-
    write('\nWe are sad to see you go... :(\n'),
    write('If you enjoyed please consider staring our repository https://github.com/anatcruz/FEUP-PLOG-PROJ :D\n').

menuAction(1) :-
    initial(GameState,6),
    printBoard(GameState),
    gameLoop(GameState, 6, 1).

menuAction(2) :-
    initial(GameState,8),
    printBoard(GameState),
    gameLoop(GameState, 8, 1).
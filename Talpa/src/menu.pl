%selectMenuOption(+NumOptions,-ValidOption)
/*
Reads menu option and checks if the input is valid
*/
selectMenuOption(NumOptions, ValidOption) :-
    write('\nInsert option:\n'),
    repeat,
    readMenuOption(OptionInput),
    validateMenuOption(OptionInput, ValidOption, NumOptions), !.

%readMenuOption(-Option)
/*
Reads menu option input code, ignoring newlines (ascii code 10)
*/
readMenuOption(Option) :-
    write('  -> '),
    get_code(Option),
    Option\=10.

%validateMenuOption(+OptionInput,-ValidOption,+NumOptions)
/*
Checks if the row input is valid by calculating it's index, converting ascii code to number, being the firt option 0
the index has to be within 0 and the number of options
the next char has to be newline (else 2 chars in input, thus failing)
*/
validateMenuOption(OptionInput, ValidOption, NumOptions) :-
    peek_char('\n'),
    ValidOption is OptionInput - 48,
    between(0, NumOptions, ValidOption),
    skip_line.

%validateMenuOption(+OptionInput,-ValidOption,+NumOptions)
/*
If the verification above fails, then it outputs a error message and the user is asked for a new input
*/
validateMenuOption(_, _, _) :-
    write('\nInvalid option! Try again:\n'), skip_line, fail.

%mainMenu/0
/*
Displays initial menu reads the option input and checks if it is valid and acts accordingly to the option chosen
*/
mainMenu :-
    repeat,
    write('\33\[2J'),
    write('\n\n _____________________________________________\n'),
    write('|          _____       _                      |\n'),
    write('|         |_   _|__ _ | | ____  __ _          |\n'),
    write('|           | | / _` || ||  _ |/ _` |         |\n'),
    write('|           |_| |__,_||_|| .__/|__,_|         |\n'),
    write('|                        |_|                  |\n'),
    write('|                                             |\n'),
    write('|                !!!WELCOME!!!                |\n'),
    write('|                                             |\n'),
    write('|                  1. Play                    |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                  2. Rules                   |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|               3. Collaborators              |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                  0. Exit                    |\n'),
    write('|                                             |\n'),
    write('|_____________________________________________|\n\n'),
    selectMenuOption(3, ValidOption),
    mainMenuAction(ValidOption).

%mainMenuAction(+ValidOption)
/*
Displays the Play menu
*/
mainMenuAction(1) :-
    playersMenu.

%mainMenuAction(+ValidOption)
/*
Displays the Rules menu
*/
mainMenuAction(2) :-
    rulesMenu.

%mainMenuAction(+ValidOption)
/*
Displays the Collaborators menu
*/
mainMenuAction(3) :-
    collaboratorsMenu.

%mainMenuAction(+ValidOption)
/*
The game ends
*/
mainMenuAction(0) :-
    write('\nWe are sad to see you go... :(\n'),
    write('Thank you for playing!\n').

%rulesMenu/0
/*
Displays rules menu and allows the user to go back to the Main menu
*/
rulesMenu :-
    write('\33\[2J'),
    write('\n\n _____________________________________________\n'),
    write('|          _____       _                      |\n'),
    write('|         |_   _|__ _ | | ____  __ _          |\n'),
    write('|           | | / _` || ||  _ |/ _` |         |\n'),
    write('|           |_| |__,_||_|| .__/|__,_|         |\n'),
    write('|                        |_|                  |\n'),
    write('|                                             |\n'),
    write('|                    Rules                    |\n'),
    write('|                                             |\n'),
    write('|- Choose one of your pieces to move and      |\n'),
    write('| the moving position                         |\n'),
    write('|                                             |\n'),
    write('|- You can only move one position orthogonally|\n'),
    write('|                                             |\n'),
    write('|- When no moves available, remove your own   |\n'),
    write('| piece                                       |\n'),
    write('|                                             |\n'),
    write('|- Open a path linking both your player sides |\n'),
    write('| of the board                                |\n'),
    write('|                0. Main Menu                 |\n'),
    write('|_____________________________________________|\n\n'),
    selectMenuOption(0, _),
    mainMenu.

%collaboratorsMenu/0
/*
Displays collaborators menu and allows the user to go back to the Main menu
*/
collaboratorsMenu :-
    write('\33\[2J'),
    write('\n\n _____________________________________________\n'),
    write('|          _____       _                      |\n'),
    write('|         |_   _|__ _ | | ____  __ _          |\n'),
    write('|           | | / _` || ||  _ |/ _` |         |\n'),
    write('|           |_| |__,_||_|| .__/|__,_|         |\n'),
    write('|                        |_|                  |\n'),
    write('|                                             |\n'),
    write('|            This game was made by:           |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|               Ana Teresa Cruz               |\n'),
    write('|                                             |\n'),
    write('|               Andre Nascimento              |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                0. Main Menu                 |\n'),
    write('|_____________________________________________|\n\n'),
    selectMenuOption(0, _),
    mainMenu.

%playersMenu/0
/*
Displays players menu with the game type options, reads the option input and checks if it is valid and acts accordingly to the option chosen
*/
playersMenu :-
    write('\33\[2J'),
    write('\n\n _____________________________________________\n'),
    write('|          _____       _                      |\n'),
    write('|         |_   _|__ _ | | ____  __ _          |\n'),
    write('|           | | / _` || ||  _ |/ _` |         |\n'),
    write('|           |_| |__,_||_|| .__/|__,_|         |\n'),
    write('|                        |_|                  |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|             1. Player VS Player             |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|            2. Player VS Computer            |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|           3. Computer VS Computer           |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                0. Main Menu                 |\n'),
    write('|                                             |\n'),
    write('|_____________________________________________|\n\n'),
    selectMenuOption(3, ValidOption),
    menuAction(ValidOption).

%menuAction(+ValidOption)
/*
Displays the board size menu, checks if the input is valid, 
prints the board with the size chosen and the game starts: Player VS Player
*/
menuAction(1) :-
    boardSizeMenu(GameState, Size),
    printBoard(GameState),
    play(GameState, Size, 1, 'Player', 'Player'),
    enterContinue,
    mainMenu.
    
%menuAction(+ValidOption)
/*
Displays the board size menu, checks if the input is valid, 
displays the bot difficulty menu, checks again if the input is valid,
displays the choose first player menu, checks again if the input is valid
and acts accordingly to all the choices made by input
*/
menuAction(2) :-
    boardSizeMenu(GameState, Size), !,
    botDificultyMenu(Difficulty),
    chooseFirstPlayerMenu(First),
    firstAction(First, GameState, Size, Difficulty),
    enterContinue,
    mainMenu.

%menuAction(+ValidOption)
/*
Displays the board size menu, checks if the input is valid, 
displays the bots difficulty menu, checks again if the input is valid,
and acts accordingly to all the choices made by input
*/
menuAction(3) :-
    boardSizeMenu(GameState, Size), !,
    botsDifficultyMenu(ValidOption),
    modeAction(ValidOption, GameState, Size),
    enterContinue,
    mainMenu.

%boardSizeMenu(-GameState, -Size)
/*
Displays the board size menu with the size options for the board,
checks if the input is valid and acts accordingly
*/
boardSizeMenu(GameState, Size):-
    write('\33\[2J'),
    write('\n\n _____________________________________________\n'),
    write('|          _____       _                      |\n'),
    write('|         |_   _|__ _ | | ____  __ _          |\n'),
    write('|           | | / _` || ||  _ |/ _` |         |\n'),
    write('|           |_| |__,_||_|| .__/|__,_|         |\n'),
    write('|                        |_|                  |\n'),
    write('|                                             |\n'),
    write('|          Choose the board dimensions        |\n'),
    write('|                                             |\n'),
    write('|                  1. 6 X 6                   |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                  2. 8 X 8                   |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                 0. Main Menu                |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|_____________________________________________|\n\n'),
    selectMenuOption(2, ValidOption),
    sizeAction(ValidOption, GameState, Size).

%sizeAction(+ValidOption,-GameSate,-Size)
/*
Iniciates the board with size 6 x 6
*/
sizeAction(1, GameState, Size) :-
    initial(GameState, 5),
    Size is 5.

%sizeAction(+ValidOption,-GameSate,-Size)
/*
Iniciates the board with size 8 x 8
*/
sizeAction(2, GameState, Size) :-
    initial(GameState, 8),
    Size is 8.

%sizeAction(+ValidOption,-GameSate,-Size)
/*
Upon failure, the Main menu is displayed again
*/ 
sizeAction(0, _, _) :-
    fail.

%botDificultyMenu(-Difficulty)
/*
Displays the bot difficulty menu with the options for the bot's difficulty,
checks if the input is valid and acts accordingly
*/
botDificultyMenu(Difficulty) :-
    write('\33\[2J'),
    write('\n\n _____________________________________________\n'),
    write('|          _____       _                      |\n'),
    write('|         |_   _|__ _ | | ____  __ _          |\n'),
    write('|           | | / _` || ||  _ |/ _` |         |\n'),
    write('|           |_| |__,_||_|| .__/|__,_|         |\n'),
    write('|                        |_|                  |\n'),
    write('|                                             |\n'),
    write('|    Choose the difficulty fot the computer   |\n'),
    write('|                                             |\n'),
    write('|               1. Easy (Easy)              |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|              2. Normal (Normal)             |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                0. Main Menu                 |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|_____________________________________________|\n\n'),
    selectMenuOption(2, ValidOption),
    difficultyAction(ValidOption, Difficulty).

%difficultyAction(+ValidOption,+Difficulty)
/*
The difficulty chosen for the bot is Easy
*/
difficultyAction(1, Difficulty) :-
    Difficulty = 'Easy'.

%difficultyAction(+ValidOption,+Difficulty)
/*
The difficulty chosen for the bot is Normal
*/
difficultyAction(2, Difficulty) :-
    Difficulty = 'Normal'.

%difficultyAction(+ValidOption,+Difficulty)
/*
Upon failure, the Main menu is displayed again
*/ 
difficultyAction(0, _) :-
    fail.

%chooseFirstPlayerMenu(-First)
/*
Displays the choose first player menu with the options for who should be the first(red) player,
checks if the input is valid
*/
chooseFirstPlayerMenu(First) :-
    write('\33\[2J'),
    write('\n\n _____________________________________________\n'),
    write('|          _____       _                      |\n'),
    write('|         |_   _|__ _ | | ____  __ _          |\n'),
    write('|           | | / _` || ||  _ |/ _` |         |\n'),
    write('|           |_| |__,_||_|| .__/|__,_|         |\n'),
    write('|                        |_|                  |\n'),
    write('|                                             |\n'),
    write('|    Choose the Red Player (first Player)     |\n'),
    write('|                                             |\n'),
    write('|                1. Player                    |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                2. Computer                  |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                0. Main Menu                 |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|_____________________________________________|\n\n'),
    selectMenuOption(2, First).

%firstAction(+First,+GameState,+Size,+Difficulty)
/*
Prints the board with the size chosen,
the game starts with the bot's difficulty chosen: Player VS Computer, player first to play
*/
firstAction(1, GameState, Size, Difficulty) :-
    printBoard(GameState),
    play(GameState, Size, 1, 'Player', Difficulty).

%firstAction(+First,+GameState,+Size,+Difficulty)
/*
Prints the board with the size chosen,
the game starts with the bot's difficulty chosen: Computer VS Player, computer first to play
*/
firstAction(2, GameState, Size, Difficulty) :-
    printBoard(GameState),
    play(GameState, Size, 1, Difficulty, 'Player').

%firstAction(+First,+GameState,+Size,+Difficulty)
/*
Upon failure, the Main menu is displayed again
*/ 
firstAction(0, _, _, _) :-
    fail.

%botsDifficultyMenu(-ValidOption)
/*
Displays the bots difficulty menu with the options for the difficulty for each bot,
checks if the input is valid
*/
botsDifficultyMenu(ValidOption) :-
    write('\33\[2J'),
    write('\n\n _____________________________________________\n'),
    write('|          _____       _                      |\n'),
    write('|         |_   _|__ _ | | ____  __ _          |\n'),
    write('|           | | / _` || ||  _ |/ _` |         |\n'),
    write('|           |_| |__,_||_|| .__/|__,_|         |\n'),
    write('|                        |_|                  |\n'),
    write('|                                             |\n'),
    write('|   Choose the difficulty for the computers   |\n'),
    write('|                                             |\n'),
    write('|              1. Easy VS Easy                |\n'),
    write('|                                             |\n'),
    write('|              2. Easy VS Normal              |\n'),
    write('|                                             |\n'),
    write('|              3. Normal VS Easy              |\n'),
    write('|                                             |\n'),
    write('|             4. Normal VS Normal             |\n'),
    write('|                                             |\n'),
    write('|                                             |\n'),
    write('|                0. Main Menu                 |\n'),
    write('|                                             |\n'),
    write('|_____________________________________________|\n\n'),
    selectMenuOption(4, ValidOption).

%modeAction(+ValidOption,+GameState,+Size)
/*
Prints the board with the size chosen,
the game starts: Computer VS Computer being both Easy
*/
modeAction(1, GameState, Size) :-
    printBoard(GameState),
    play(GameState, Size, 1, 'Easy', 'Easy').

%modeAction(+ValidOption,+GameState,+Size)
/*
Prints the board with the size chosen,
the game starts: Computer VS Computer, being the first Easy and the second in Normal
*/
modeAction(2, GameState, Size) :-
    printBoard(GameState),
    play(GameState, Size, 1, 'Easy', 'Normal').

%modeAction(+ValidOption,+GameState,+Size)
/*
Prints the board with the size chosen,
the game starts: Computer VS Computer, being the first Normal and the second in Easy
*/
modeAction(3, GameState, Size) :-
    printBoard(GameState),
    play(GameState, Size, 1, 'Normal', 'Easy').

%modeAction(+ValidOption,+GameState,+Size)
/*
Prints the board with the size chosen,
the game starts: Computer VS Computer, being both Normal
*/  
modeAction(4, GameState, Size) :-
    printBoard(GameState),
    play(GameState, Size, 1, 'Normal', 'Normal').

%modeAction(+ValidOption,+GameState,+Size)
/*
Upon failure, the Main menu is displayed again
*/ 
modeAction(0, _, _) :-
    fail.
/*choose_move(GameState, Size, Player, Level, Move)*/

/*Selects random a piece and position to move if there are available moves for the player*/
choose_move(GameState, Size, Player, 1, Move):-
    valid_moves(GameState, Size, Player, ListOfValidMoves),
    selectPieceBotRandom(ListOfValidMoves, SelPosition, ListOfMoves),
    movePieceBotRandom(ListOfMoves, FinalPosition),
    append(SelPosition, FinalPosition, Move).

/*If no available moves then select a random piece to remove*/
choose_move(GameState, Size, Player, 1, Move):-
    removePieceBotRandom(GameState, Size, Player, Move).

/*Select a random Move from the ListOfValidMoves, 
returning the Selected piece Position and a ListOfMoves associated to that piece*/
selectPieceBotRandom(ListOfValidMoves, SelPosition, ListOfMoves):-
    random_member(SelMove, ListOfValidMoves),
    getPositionAndMoves(SelMove, SelPosition, ListOfMoves),
    getPosition(SelPosition, SelRow, SelColumn),
    write('\nSelected: '), printMove(SelPosition), nl.

/*Select a random Move from the ListOfMoves received*/
movePieceBotRandom(ListOfMoves, SelMove):-
    random_member(SelMove, ListOfMoves),
    getPosition(SelMove, MovRow, MovColumn),
    write('\nMove to: '), printMove(SelMove), nl.

/*Select a random Position of the current player to remove the piece*/
removePieceBotRandom(GameState, Size, Player, SelPosition):-
    getPlayerInMatrix(GameState, Size, Player, Positions),
    random_member(SelPosition, Positions),
    getPosition(SelPosition, SelRow, SelColumn),
    write('\nRemoved: '), printMove(SelPosition), nl.
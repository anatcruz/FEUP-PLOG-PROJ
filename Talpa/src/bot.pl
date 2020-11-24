/*choose_move(GameState, Size, Player, Level, Move)*/

/*Selects random a piece and position to move if there are available moves for the player*/
choose_move(GameState, Size, Player, 'Random', Move):-
    valid_moves(GameState, Size, Player, ListOfValidMoves),
    selectAndMovePieceBot(ListOfValidMoves, SelPosition, MovPosition),
    Move = [SelPosition, MovPosition].

/*If no available moves then select a random piece to remove*/
choose_move(GameState, Size, Player, 'Random', Move):-
    removePieceBot(GameState, Size, Player, Move).

selectAndMovePieceBot(ListOfValidMoves, SelPosition, MovPosition):-
    random_member(SelMove, ListOfValidMoves),
    getPositionAndMove(SelMove, SelPosition, MovPosition),
    write('\nSelected: '), printMove(SelPosition), nl,
    write('\nMoved to: '), printMove(MovPosition), nl.


/*Select a random Move from the ListOfValidMoves, 
returning the Selected piece Position and a ListOfMoves associated to that piece*/
selectPieceBotRandom(ListOfValidMoves, SelPosition, ListOfMoves):-
    random_member(SelMove, ListOfValidMoves),
    getPositionAndMove(SelMove, SelPosition, MovPosition),
    write('\nSelected: '), printMove(SelPosition), nl.

/*Select a random Move from the ListOfMoves received*/
movePieceBotRandom(ListOfMoves, MovPosition):-
    random_member(MovPosition, ListOfMoves),
    write('\nMove to: '), printMove(MovPosition), nl.

/*Select a random Position of the current player to remove the piece*/
removePieceBot(GameState, Size, Player, SelPosition):-
    getPlayerInMatrix(GameState, Size, Player, Positions),
    random_member(SelPosition, Positions),
    write('\nRemoved: '), printMove(SelPosition), nl.
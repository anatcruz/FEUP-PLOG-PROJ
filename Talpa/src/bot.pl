/*choose_move(GameState, Size, Player, Level, Move)*/

/*Selects random a piece and position to move if there are available moves for the player*/
choose_move(GameState, Size, Player, Level, Move):-
    valid_moves(GameState, Size, Player, ListOfValidMoves),
    movePiecePositionBot(GameState, Size, Player, Level, ListOfValidMoves, Move),
    getPositionAndMove(Move, SelPosition, MovPosition),
    write('\nSelected: '), printMove(SelPosition), nl,
    write('\nMoved to: '), printMove(MovPosition), nl.

/*If no available moves then select a random piece from the player to remove*/
choose_move(GameState, Size, Player, Level, Move):-
    getPlayerInMatrix(GameState, Size, Player, ListOfPositions),
    removePiecePositionBot(GameState, Size, Player, Level, ListOfPositions, Move),
    write('\nRemoved: '), printMove(Move), nl.

/*Select a random Move from the ListOfValidMoves, 
returning the Selected piece Position and the Move position*/
movePiecePositionBot(_, _, _, 'Random', ListOfValidMoves, SelMove):-
    random_member(SelMove, ListOfValidMoves).

/*Select a random position of the current player positions to remove the piece*/
removePiecePositionBot(_, _, _, 'Random', ListOfPositions, SelPosition):-
    random_member(SelPosition, ListOfPositions).

movePiecePositionBot(GameState, Size, Player, 'Greedy', ListOfValidMoves, [SelPos, MovPos]):-
    findall(
        Value1-SelPos1-MovPos1-Index,
        (
            nth0(Index, ListOfValidMoves, Move),
            move(GameState, Player, Move, NewGameState),
            value(NewGameState, Size, Player, Value1),
            getPositionAndMove(Move, SelPos1, MovPos1)
        ),
        ListResults
    ),
    sort(ListResults, Sorted),
    reverse(Sorted, [_-SelPos-MovPos-_|_]).

removePiecePositionBot(GameState, Size, Player, 'Greedy', ListOfPositions, SelPos):-
    findall(
        Value1-SelPos1-Index,
        (
            nth0(Index, ListOfPositions, SelPos1),
            move(GameState, Player, SelPos1, NewGameState),
            value(NewGameState, Size, Player, Value1)
        ),
        ListResults
    ),
    sort(ListResults, Sorted), 
    reverse(Sorted, [_-SelPos-_|_]).


value(GameState, Size, -1, Value):-
    getFFSpots(GameState, Size, ListOfFFSpots),
    getSpotsValues(GameState, Size, ListOfFFSpots, ListOfValues),
    max_member(Value, ListOfValues), !.

value(GameState, Size, 1, Value):-
    transpose(GameState, Transpose),
    value(Transpose, Size, -1, Value).


getFFSpots(GameState, Size, ListOfFFSpots):-
    getFFSpots(GameState, Size, 0, 0, ListOfFFSpots).

getFFSpots(GameState, Size, Row, Column, []):-
    check_end(Row, Col, Size).

getFFSpots(GameState, Size, Row, Column, ListOfFFSpots):-
    tryFloodFill(GameState, Size, Row, Column, UpdatedGameState),
    next_index(Row, Column, Size, NextRow, NextColumn),
    getFFSpots(UpdatedGameState, Size, NextRow, NextColumn, Result),
    append(Result, [Row-Column], ListOfFFSpots).

getFFSpots(GameState, Size, Row, Column, ListOfFFSpots):-
    next_index(Row, Column, Size, NextRow, NextColumn),
    getFFSpots(GameState, Size, NextRow, NextColumn, ListOfFFSpots).


getSpotsValues(_, _, [], []).
getSpotsValues(GameState, Size, [Row-Column|RestFFSpots], ListOfValues):-
    floodFill(GameState, Size, Row, Column, 0, 2, UpdatedGameState),
    getValuesInAllRows(UpdatedGameState, 2, Size, ListResult),
    sequence(ListResult, TempValue),
    getSpotsValues(GameState, Size, RestFFSpots, TempResultList),
    append(TempResultList, [TempValue], ListOfValues).
    

getValuesInAllRows(GameState, Value, Size, ListResult):-
    getValuesInAllRows(GameState, Value, Size, 0, ListResult).

getValuesInAllRows(_, _, Size, Size, []).
getValuesInAllRows([Row|T], Value, Size, RowIndex, ListResult):-
    count(Value, Row, Amount),
    NextRowIndex is RowIndex+1,
    getValuesInAllRows(T, Value, Size, NextRowIndex, ValueResult),
    append(ValueResult, [Amount], ListResult).
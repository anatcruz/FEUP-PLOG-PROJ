%Replaces given Value (content) in Index position of the List
replaceInList([_H|T], 0, Value, [Value|T]).
replaceInList([H|T], Index, Value, [H|TNew]) :-
        Index > 0,
        Index1 is Index - 1,
        replaceInList(T, Index1, Value, TNew).

%Replaces Value (content) in given Row and Column of the Matrix
replaceInMatrix([H|T], 0, Col, Value, [HNew|T]) :-
        replaceInList(H, Col, Value, HNew).

replaceInMatrix([H|T], Row, Col, Value, [H|TNew]) :-
        Row > 0,
        Row1 is Row - 1,
        replaceInMatrix(T, Row1, Col, Value, TNew).

%Gets Value (content) in Index position of the List
getValueFromList([H|_T], 0, Value) :-
        Value = H.

getValueFromList([_H|T], Index, Value) :-
        Index > 0,
        Index1 is Index - 1,
        getValueFromList(T, Index1, Value).

%Gets Value (content) in given Row and Column of the Matrix
getValueFromMatrix([H|_T], 0, Col, Value) :-
        getValueFromList(H, Col, Value).

getValueFromMatrix([_H|T], Row, Col, Value) :-
        Row > 0,
        Row1 is Row - 1,
        getValueFromMatrix(T, Row1, Col, Value).
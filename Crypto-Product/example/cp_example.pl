:- use_module(library(clpfd)).
:- use_module(library(lists)).

%red -> R
%green -> G
%blue -> B

writeList([]).
writeList([H|T]):-
    write(H), writeList(T).

print(L1, L2, Res):-
    write('\n'),
    writeList(L1),
    write(' x '),
    writeList(L2),
    write(' = '),
    writeList(Res).

/* #1 x #2 = ... */

cp1x2_1:-
    Vars=[R,G,B],
    domain(Vars, 0, 9),
    all_distinct(Vars),
    R*(G*10+R) #= B*10+G,
    R#>0, G#>0, B#>0, %first digits of a number can't be 0
    labeling([], Vars),
    print([R], [G,R], [B,G]).

cp1x2_2:-
    Vars=[R,G,B],
    domain(Vars, 0, 9),
    all_distinct(Vars),
    G*(G*10+B) #= B*100+R*10+G,
    R#>0, G#>0, B#>0,
    labeling([], Vars),
    print([G], [G,B], [B,R,G]).

cp1x2_3:-
    Vars=[R,G,B],
    domain(Vars, 0, 9),
    all_distinct(Vars),
    B*(R*10+G) #= R*100+R*10+G,
    R#>0, B#>0, 
    labeling([], Vars),
    print([B], [R,G], [R,R,G]).


/* #2 x #2 = ... */

cp2x2_1:-
    Vars=[R,G,B],
    domain(Vars, 0, 9),
    all_distinct(Vars),
    (G*10+B)*(G*10+R) #= R*100+B*10+B,
    R#>0, G#>0, B#>0, 
    labeling([], Vars),
    print([G,B], [G,R], [R,B,B]).

cp2x2_2:-
    Vars=[R,G,B],
    domain(Vars, 0, 9),
    all_distinct(Vars),
    (B*10+G)*(B*10+R) #= (G*100+B*10+R),
    G#>0, B#>0, 
    labeling([], Vars),
    print([B,G], [B,R], [G,B,R]).
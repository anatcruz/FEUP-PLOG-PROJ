:- use_module(library(clpfd)).
:- use_module(library(lists)).

%red -> R
%green -> G
%blue -> B

writeList([]).
writeList([H|T]):-
    write(H), writeList(T).

print(L1, L2, Res):-
    writeList(L1),
    write(' x '),
    writeList(L2),
    write(' = '),
    writeList(Res),
    write('\n').

save_cp1x2_2:-
    open('cp1x2_2.txt', write, S1),
    set_output(S1),
    print_cp1x2_2,
    flush_output(S1),
    close(S1).

print_cp1x2_2:-
    cp1x2_2, fail.
print_cp1x2_2.

save_cp1x2_3:-
    open('cp1x2_3.txt', write, S1),
    set_output(S1),
    print_cp1x2_3,
    flush_output(S1),
    close(S1).

print_cp1x2_3:-
    cp1x2_3, fail.
print_cp1x2_3.

/* d X dd = dd */
cp1x2_2:-
    Vars=[R,G,B],
    domain(Vars, 0, 9),
    all_distinct(Vars),
    nth0(_, Vars, N1),
    nth0(_, Vars, M1),
    nth0(_, Vars, M2),
    nth0(_, Vars, R1),
    nth0(_, Vars, R2),
    N1 #> 0, M1 #>0, R1 #>0,
    N1 * (M1*10+M2) #= (R1*10+R2),
    Nums=[N1,M1,M2,R1,R2],
    labeling([], Nums),
    print([N1], [M1,M2], [R1,R2]).


/* d X dd = ddd */
cp1x2_3:-
    Vars=[R,G,B],
    domain(Vars, 0, 9),
    all_distinct(Vars),
    nth0(_, Vars, N1),
    nth0(_, Vars, M1),
    nth0(_, Vars, M2),
    nth0(_, Vars, R1),
    nth0(_, Vars, R2),
    nth0(_, Vars, R3),
    N1 #> 0, M1 #>0, R1 #>0,
    N1 * (M1*10+M2) #= (R1*100+R2*10+R3),
    Nums=[N1,M1,M2,R1,R2,R3],
    labeling([], Nums),
    print([N1], [M1,M2], [R1,R2,R3]).
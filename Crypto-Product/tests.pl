% All options available for labeling heuristics
lb_op(leftmost).
lb_op(min).
lb_op(max).
lb_op(ff).
lb_op(anti_first_fail).
lb_op(occurrence).
lb_op(ffc).
lb_op(max_regret).
lb_op2(step).
lb_op2(enum).
lb_op2(bisect).
lb_op2(median).
lb_op2(middle).
lb_op3(up).
lb_op3(down).

cp_tester(L_digits_num, R_digits_num, LabelingOps):-
    cp_generator(L_digits_list, R_digits_list, Res_digits_list, L_digits_num, R_digits_num, LabelingOps),
    printPuzzle(L_digits_list, R_digits_list, Res_digits_list),
    convertAllDigitsListToVarList(L_digits_list, R_digits_list, Res_digits_list, L_vars, R_vars, Res_vars),
    cp_solver(L_vars, R_vars, Res_vars, L_number, R_number, Res_number, LabelingOps),
    printSolution(L_number, R_number, Res_number),
    fail.
cp_tester(_, _, _, _, _).

save_heuristics(L_digits_num, R_digits_num):-
    lb_op(X),
    lb_op2(Y),
    lb_op3(Z),
    save(L_digits_num,R_digits_num,X,Y,Z),
    fail.
save_heuristics(_,_).

save(L_num_digits, R_num_digits, X, Y, Z):-
    Predicate =.. [cp_tester, L_num_digits, R_num_digits, [X, Y, Z]],
    file_name(L_num_digits, R_num_digits, X, Y, Z, FileName),
    format('Saving to ~w\n', [FileName]),
    open(FileName, write, S1),
    current_output(Console),
    set_output(S1),
    statistics(runtime, [T0|_]),
    (Predicate ; true),
    statistics(runtime, [T1|_]),
    T is T1 - T0,
    format('~w took ~3d sec.~n', [Predicate, T]),
    close(S1),
    set_output(Console),
    format('~w took ~3d sec.~n', [Predicate, T]), !.

file_name(L_num_digits, R_num_digits, X, Y, Z, FileName):-
    number_chars(L_num_digits, L_digits_char_list),
    number_chars(R_num_digits, R_digits_char_list),
    atom_chars(L_digits_char, L_digits_char_list),
    atom_chars(R_digits_char, R_digits_char_list),
    atom_concat(L_digits_char, 'x', Temp1),
    atom_concat(Temp1, R_digits_char, Temp2),
    atom_concat(Temp2, '_ops_', Temp3),
    atom_concat(Temp3, X, Temp4),
    atom_concat(Temp4, '_', Temp5),
    atom_concat(Temp5, Y, Temp6),
    atom_concat(Temp6, '_', Temp7),
    atom_concat(Temp7, Z, Temp8),
    atom_concat(Temp8, '.txt', FileName).
% All options available for labeling heuristics
lb_opt(leftmost).
lb_opt(min).
lb_opt(max).
lb_opt(ff).
lb_opt(anti_first_fail).
lb_opt(occurrence).
lb_opt(ffc).
lb_opt(max_regret).
lb_opt2(step).
lb_opt2(enum).
lb_opt2(bisect).
lb_opt2(median).
lb_opt2(middle).
lb_opt3(up).
lb_opt3(down).

/* Generates all puzzles for the given configuration and gets all the solutions for each one of them
    applying the labeling options
*/
cp_tester(L_digits_num, R_digits_num, LabelingOps):-
    cp_generator(L_digits_list, R_digits_list, Res_digits_list, L_digits_num, R_digits_num, LabelingOps),
    printPuzzle(L_digits_list, R_digits_list, Res_digits_list),
    convertAllDigitsListToVarList(L_digits_list, R_digits_list, Res_digits_list, L_vars, R_vars, Res_vars),
    cp_solver(L_vars, R_vars, Res_vars, L_number, R_number, Res_number, LabelingOps),
    printSolution(L_number, R_number, Res_number),
    fail.
cp_tester(_, _, _, _, _).

% Save all heuristics combinations to files
save_heuristics(L_digits_num, R_digits_num):-
    lb_opt(Opt),
    lb_opt2(Opt2),
    lb_opt3(Opt3),
    save(L_digits_num, R_digits_num, Opt, Opt2, Opt3),
    fail.
save_heuristics(_,_).

% Calls the cp_tester predicate and saves the outputs to the corresponding filename
save(L_num_digits, R_num_digits, Opt, Opt2, Opt3):-
    Predicate =.. [cp_tester, L_num_digits, R_num_digits, [Opt, Opt2, Opt3]],
    file_name(L_num_digits, R_num_digits, Opt, Opt2, Opt3, FileName),
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

% Creates corresponding file name given the number of digits and labeling options
file_name(L_num_digits, R_num_digits, Opt, Opt2, Opt3, FileName):-
    number_chars(L_num_digits, L_digits_char_list),
    number_chars(R_num_digits, R_digits_char_list),
    atom_chars(L_digits_char, L_digits_char_list),
    atom_chars(R_digits_char, R_digits_char_list),
    atom_concat(L_digits_char, 'x', Temp1),
    atom_concat(Temp1, R_digits_char, Temp2),
    atom_concat(Temp2, '_ops_', Temp3),
    atom_concat(Temp3, Opt, Temp4),
    atom_concat(Temp4, '_', Temp5),
    atom_concat(Temp5, Opt2, Temp6),
    atom_concat(Temp6, '_', Temp7),
    atom_concat(Temp7, Opt3, Temp8),
    atom_concat(Temp8, '.txt', FileName).
printlist([]).
printlist([X|Xs]) :-
    write('Rock Position at: '),
    write(X),
    nl,
    printlist(Xs).

print_option(Options) :-
    ([H|T] = Options ; H = []),
    (
        H = [] -> true
        ;
        (
            (
                (H = 'up', write('1. '), write(H), nl);
                (H = 'down', write('2. '), write(H), nl);
                (H = 'left', write('3. '), write(H), nl);
                (H = 'right', write('4. '), write(H), nl)
            ),
            print_option(T)
        )
    ).


% function to check if a ver is instantiated
not_inst(Var) :-
  \+(\+(Var=0)),
  \+(\+(Var=1)).

remove( _, [], []).
remove( R, [R|T], T).
remove( R, [H|T], [H|T2]) :- H \= R, remove( R, T, T2).
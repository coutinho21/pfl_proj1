printlist([]).
printlist([X|Xs]) :-
    write('Rock Position at: '),
    write(X),
    nl,
    printlist(Xs).


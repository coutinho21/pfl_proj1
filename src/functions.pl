adjacent_positions((Row, Col), Adjacent) :-
    Up is Row - 1,
    Down is Row + 1,
    Left is Col - 1,
    Right is Col + 1,
    Adjacent = [(Up, Col), (Down, Col), (Row, Left), (Row, Right)].


check_rocks_around([], _, []).

check_rocks_around([H1|T1], ActualRocks, RocksAround) :-
    member(H1, ActualRocks),
    RocksAround = [H1|RestRocksAround],
    check_rocks_around(T1, ActualRocks, RestRocksAround).

check_rocks_around([_|T1], ActualRocks, RocksAround) :-
    check_rocks_around(T1, ActualRocks, RocksAround).

remove_element(_, [], []).
remove_element(Elem, [Elem|Tail], Tail).
remove_element(Elem, [Head|Tail], [Head|NewTail]) :- 
    Elem \= Head,
    remove_element(Elem, Tail, NewTail).

remove_all([], []).
remove_all([_|T], NewList) :-
    remove_all(T, NewList).
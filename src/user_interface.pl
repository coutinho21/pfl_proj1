:- use_module(library(random)).


% prints the board and the current player
display_game(PlayerTurn) :-
    player(PlayerTurn),
    print_board,
    nl, write('Current player: '), write(PlayerTurn), nl.


% prints the board
print_board :-
    print_rows(1, 14).


% prints the rows of the board
print_rows(X,X).
print_rows(Row, RowEnd) :-
    Row =< RowEnd,
    nl,
    print_row(Row, 1, 14),
    NextRow is Row + 1,
    print_rows(NextRow, RowEnd).


% prints a row of the board
print_row(_, ColEnd, ColEnd) :- write('|'), nl.
print_row(Row, Col, ColEnd) :-
    Col =< ColEnd,
    cell(Row, Col, Symbol),
    write_cell(Symbol),
    NextCol is Col + 1,
    print_row(Row, NextCol, ColEnd).


% define the way a cell is printed
write_cell(Symbol) :- write('|'), write(Symbol).


next_turn(Player, NewPlayer, Game, HaveUsedLevitate, UsedLevitate, StopLevitation) :-
    ( Player = player1 ->
        (
            write('Choose a piece to move:'), nl,
            write('1. tr1'), nl,
            write('2. dw1'), nl,
            write('3. sr1'), nl,
            read(Choice),
            (
                Choice = 1, Piece = 'tr1';
                Choice = 2, Piece = 'dw1';
                Choice = 3, Piece = 'sr1'
            )
        )
    ;
        (
            write('Choose a piece to move:'), nl,
            write('1. tr2'), nl,
            write('2. dw2'), nl,
            write('3. sr2'), nl,
            read(Choice),
            (
                Choice = 1, Piece = 'tr2';
                Choice = 2, Piece = 'dw2';
                Choice = 3, Piece = 'sr2'
            )
        )
    ),
    move(Player, Piece, NewPlayer, Game, HaveUsedLevitate, UsedLevitate, StopLevitation, 0).


next_turn_ai_level1(Player, NewPlayer, Game, HaveUsedLevitate, UsedLevitate, StopLevitation) :-
    ( Player = player1 ->
        (
            random(1, 4, Choice),
            (
                Choice = 1, Piece = 'tr1';
                Choice = 2, Piece = 'dw1';
                Choice = 3, Piece = 'sr1'
            )
        )
    ;
        (
            random(1, 4, Choice),
            (
                Choice = 1, Piece = 'tr2';
                Choice = 2, Piece = 'dw2';
                Choice = 3, Piece = 'sr2'
            )
        )
    ),
    move(Player, Piece, NewPlayer, Game, HaveUsedLevitate, UsedLevitate, StopLevitation, 1).


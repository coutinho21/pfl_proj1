/* Board Printing */

% Prints the board and the current player
print_game_state(PlayerTurn) :-
    player(PlayerTurn),
    print_board,
    nl, write('Current player: '), write(PlayerTurn), nl.

% Prints the board
print_board :-
    print_rows(1, 14).

% Prints the rows of the board
print_rows(X,X).
print_rows(Row, RowEnd) :-
    Row =< RowEnd,
    nl,
    print_row(Row, 1, 14),
    NextRow is Row + 1,
    print_rows(NextRow, RowEnd).

% Prints a row of the board
print_row(_, ColEnd, ColEnd) :- write('|'), nl.
print_row(Row, Col, ColEnd) :-
    Col =< ColEnd,
    cell(Row, Col, Symbol),
    write_cell(Symbol),
    NextCol is Col + 1,
    print_row(Row, NextCol, ColEnd).

% Define the way a cell is printed
write_cell(Symbol) :- write('|'), write(Symbol).


/* Communicating with user */

next_turn(Player) :-
    write('Choose a piece to move:'), nl,
    read(Piece),
    move_player_piece(Player, Piece).
:- dynamic player/1.
:- dynamic player_piece/3.

initialize_players :-
    assert(player(player1)),
    assert(player(player2)),
    initialize_player_pieces.

/* Piece manipulation */

initialize_player_pieces :-
    assert_player_piece(player1, 'Tr1', (8, 6)),
    assert_player_piece(player2, 'Tr2', (2, 4)),
    assert_player_piece(player1, 'Dw1', (8, 5)),
    assert_player_piece(player2, 'Dw2', (2, 5)),
    assert_player_piece(player1, 'Sr1', (8, 3)),
    assert_player_piece(player2, 'Sr2', (2, 6)).

assert_player_piece(Player, Piece, Position) :-
    (Row, Col) = Position,
    assert(player_piece(Player, Piece, Position)),
    assert_cell(Row + 2, Col + 2, atom_concat(Piece, Player)).

move_player_piece(Player, Piece, Direction) :-
    player(Player),
    player_piece(Player, Piece, Position),
    (Row, Col) = Position,
    cell(Row + 2, Col + 2, Piece),
    (Direction = 'up' -> NewPosition = (Row - 1, Col) ; true),
    (Direction = 'down' -> NewPosition = (Row + 1, Col) ; true),
    (Direction = 'left' -> NewPosition = (Row, Col - 1) ; true),
    (Direction = 'right' -> NewPosition = (Row, Col + 1) ; true),
    retract(player_piece(Player, Piece, Position)),
    assert_player_piece(Player, Piece, NewPosition).
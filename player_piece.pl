:- dynamic player/1.
:- dynamic player_piece/3.

initialize_players :-
    assert(player(player1)),
    assert(player(player2)),
    initialize_player_pieces.

/* Piece manipulation */

initialize_player_pieces :-
    assert_player_piece(player1, 'tr1', (8, 6)),
    assert_player_piece(player2, 'tr2', (2, 4)),
    assert_player_piece(player1, 'dw1', (8, 5)),
    assert_player_piece(player2, 'dw2', (2, 5)),
    assert_player_piece(player1, 'sr1', (8, 4)),
    assert_player_piece(player2, 'sr2', (2, 6)).

assert_player_piece(Player, Piece, Position) :-
    (Row, Col) = Position,
    RealRow is Row + 2,
    RealCol is Col + 2,
    assert(player_piece(Player, Piece, Position)),
    retract_cell(RealRow, RealCol),
    assert_cell(RealRow, RealCol, Piece).

retract_player_piece(Player, Piece, Position) :-
    (Row, Col) = Position,
    RealRow is Row + 2,
    RealCol is Col + 2,
    retractall(player_piece(Player, Piece, Position)),
    retract_cell(RealRow, RealCol),
    assert_cell(RealRow, RealCol, '   ').

move_player_piece(Player, Piece, Direction) :-
    player(Player),
    player_piece(Player, Piece, Position),
    (Row, Col) = Position,
    RealRow is Row + 2,
    RealCol is Col + 2,
    cell(RealRow, RealCol, Piece),
    (
        (Direction = 'up', NewRow is Row - 1, NewPosition = (NewRow, Col));
        (Direction = 'down', NewRow is Row + 1, NewPosition = (NewRow, Col));
        (Direction = 'left', NewCol is Col - 1, NewPosition = (Row, NewCol));
        (Direction = 'right', NewCol is Col + 1, NewPosition = (Row, NewCol))
    ),
    retract_player_piece(Player, Piece, Position),
    assert_player_piece(Player, Piece, NewPosition).
    

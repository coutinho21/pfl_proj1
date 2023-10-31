:- dynamic player/1.
:- dynamic rock/1.
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
    choose_move(Piece,Direction, Row, Col, NewPosition),
    retract_player_piece(Player, Piece, Position),
    assert_player_piece(Player, Piece, NewPosition).
    
choose_move(Piece, Direction, Row, Col, NewPosition) :-
    ((Piece = 'tr1'; Piece = 'tr2'), tr_move(Direction, Row, Col, NewPosition));
    ((Piece = 'dw1'; Piece = 'dw2'), dw_move(Direction, Row, Col, NewPosition));
    ((Piece = 'sr1'; Piece = 'sr2'), sr_move(Direction, Row, Col, NewPosition)).

tr_move(Direction, Row, Col, NewPosition) :-
    (Direction = 'up', NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol));
    (Direction = 'down', NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol));
    (Direction = 'left', NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol));
    (Direction = 'right', NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol)).

dw_move(Direction, Row, Col, NewPosition) :-
    (Direction = 'up', NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol));
    (Direction = 'down', NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol));
    (Direction = 'left', NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol));
    (Direction = 'right', NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol)).

sr_move(Direction, Row, Col, NewPosition) :-
    (Direction = 'up', NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol));
    (Direction = 'down', NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol));
    (Direction = 'left', NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol));
    (Direction = 'right', NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol)).






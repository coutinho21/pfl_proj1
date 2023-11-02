?-  consult('utils.pl').

:- dynamic player/1.
:- dynamic rock_piece/2.
:- dynamic player_piece/3.
:- dynamic actual_rocks/1.

get_actual_rocks(List) :-
    actual_rocks(List).



initialize_players :-
    assert(player(player1)),
    assert(player(player2)),
    initialize_pieces.

/* Piece manipulation */

initialize_pieces :-
    assert_player_piece(player1, 'tr1', (8, 6)),
    assert_player_piece(player2, 'tr2', (2, 4)),
    assert_player_piece(player1, 'dw1', (8, 5)),
    assert_player_piece(player2, 'dw2', (2, 5)),
    assert_player_piece(player1, 'sr1', (8, 4)),
    assert_player_piece(player2, 'sr2', (2, 6)),
    assert_rock_piece('_r_', (1, 5)),
    assert_rock_piece('_r_', (5, 1)),
    assert_rock_piece('_r_', (5, 9)),
    assert_rock_piece('_r_', (9, 5)),
    findall(Position, rock_piece('_r_', Position), ActualRocks), 
    assert(actual_rocks(ActualRocks)),
    printlist(ActualRocks).



assert_rock_piece(Piece, Position) :-
    (Row, Col) = Position,
    RealRow is Row + 2,
    RealCol is Col + 2,
    write('Asserting rock at '), write(RealRow), write(' '), write(RealCol), nl,
    assert(rock_piece(Piece, Position)),
    write('Retracting cell at '), write(RealRow), write(' '), write(RealCol), nl,
    retract_cell(RealRow, RealCol),
    write('Asserting cell at '), write(RealRow), write(' '), write(RealCol), nl,
    assert_cell(RealRow, RealCol, Piece),
    write('Rock added at '), write(Position), nl,
    findall(Position, rock_piece('_r_', Position), ActualRocks).

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


move_player_piece(Player, Piece) :-
    player(Player),
    player_piece(Player, Piece, Position),
    (Row, Col) = Position,
    RealRow is Row + 2,
    RealCol is Col + 2,
    cell(RealRow, RealCol, Piece),
    choose_move(Piece, Row, Col, Position, NewPosition),
    assert_player_piece(Player, Piece, NewPosition).
    




    
choose_move(Piece, Row, Col, Position, NewPosition) :-
    ((Piece = 'tr1'; Piece = 'tr2'), retract_player_piece(Player, Piece, Position), tr_move(Row, Col, NewPosition));
    ((Piece = 'dw1'; Piece = 'dw2'), retract_player_piece(Player, Piece, Position), dw_move( Row, Col, NewPosition));
    ((Piece = 'sr1'; Piece = 'sr2'), retract_player_piece(Player, Piece, Position), sr_move( Row, Col, NewPosition)).

tr_move(Row, Col, NewPosition) :-
    get_actual_rocks(ActualRocks),
    write('Choose a direction to move:'), nl,
    read(Direction),
    (
    (Direction = 'up', NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol), check_rock_for_throw(NewPosition, ActualRocks));
    (Direction = 'down', NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol), check_rock_for_throw(NewPosition, ActualRocks));
    (Direction = 'left', NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol), check_rock_for_throw(NewPosition, ActualRocks));
    (Direction = 'right', NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol), check_rock_for_throw(NewPosition, ActualRocks))
    ).


    check_rock_for_throw(NewPosition, ActualRocks) :-
        ( member(NewPosition, ActualRocks) -> 
            write('In what direction do you want to throw the rock?'), nl,
            read(Answer),
            (
                (Answer = 'up'; Answer = 'down'; Answer = 'left'; Answer = 'right') ->
                throw_rock(NewPosition, Answer), assert_rock_piece('_r_', NewPosition)
            );
            true
        ).
    

throw_rock(RockPosition, Direction) :-  
    retractall(actual_rocks(_)),
    move_rock_until_obstacle(RockPosition, Direction),

    write('Rock thrown!'), nl.

move_rock_until_obstacle(RockPosition, Direction) :-
    RockPosition = (Row, Col),
    (
    (Direction = 'up', NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol));
    (Direction = 'down', NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol));
    (Direction = 'left', NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol));
    (Direction = 'right', NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol))
    ),
    check_throw_collision(NewPosition,Result),
    write('Rock moved to '), write(NewPosition), nl,
    ( Result = false ->
        (   
        write('Rock collided with something!'), nl, 
        NewRockPosition = (Row, Col),
        write('row/col/dir'),write(Row), write(Col), write(Direction), nl,
        assert_rock_piece('_r_', NewRockPosition)
        );
         move_rock_until_obstacle(NewPosition, Direction) ). 
 
check_throw_collision(NewPosition, Result) :-
    NewPosition = (Row, Col),
    RealRow is Row + 2,
    RealCol is Col + 2,
    write('Checking collision with '), write(RealRow), write(' '), write(RealCol), nl,
    cell(RealRow, RealCol, Piece),
    write('Checking collision with '), write(Piece), nl,
    (member(Piece, ['\\\\\\', '///', '|||','tr1', 'tr2', 'sr1', 'sr2', '_r_']) ->
        write('Rock collided with '), write(Piece), nl, Result = false;
        write('true'),nl, Result = true
    ).
   






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






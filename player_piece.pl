?-  consult('utils.pl').

:- dynamic player/1.
:- dynamic rock_piece/2.
:- dynamic player_piece/3.
:- dynamic actual_rocks/1.

set_actual_rocks(List) :-
    findall(Position, rock_piece('_r_', Position), List).



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
    set_actual_rocks(ActualRocks).



assert_rock_piece(Piece, Position) :-
    (Row, Col) = Position,
    RealRow is Row + 2,
    RealCol is Col + 2,
    assert(rock_piece(Piece, Position)),
    retract_cell(RealRow, RealCol),
    assert_cell(RealRow, RealCol, Piece).

retract_rock_piece(Piece, Position) :-
    retract(rock_piece(Piece, Position)),
    (Row, Col) = Position,
    RealRow is Row + 2,
    RealCol is Col + 2,
    assert_cell(RealRow, RealCol, '   ').
    

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
    set_actual_rocks(ActualRocks),
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
            throw_rock(NewPosition, Answer)
        );
        true 
    ).
    

throw_rock(RockPosition, Direction) :- 
    write('Rock position: '), write(RockPosition), nl,
    retract_rock_piece('_r_', RockPosition),
    findall(Posit, rock_piece('_r_', Posit), Test),
    write('Test: '), write(Test), nl,
    move_rock_until_obstacle(RockPosition, Direction),
    findall(Posit2, rock_piece('_r_', Posit2), Test2),
    write('Test: '), write(Test2), nl,
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
    ( 
    Result = false ->
        NewRockPosition = (Row, Col),
        (   
        findall(P1, player_piece(_, 'dw1', P1), Dw1List),
        findall(P2, player_piece(_, 'dw2', P2), Dw2List),
        (
        (member(NewRockPosition, Dw1List) -> 
            retract_player_piece(Player, 'dw1', NewRockPosition),
            assert_rock_piece('_r_', NewRockPosition);
        member(NewRockPosition, Dw2List) ->
            retract_player_piece(Player, 'dw2', NewRockPosition),
            assert_rock_piece('_r_', NewRockPosition);
        assert_rock_piece('_r_', NewRockPosition)
        ))
        
        );
    Result = sr -> 
        (SrRow, SrCol) = NewPosition,
        RealRowS is SrRow + 2,
        RealColS is SrCol + 2,
        cell(RealRowS, RealColS, Piece),
        (Piece = 'sr1' -> retract_player_piece(_, 'sr1', NewPosition), cell(RealRowD, RealColD, 'dw1'), RowD is RealRowD - 2, ColD is RealColD - 2, retract_player_piece(_, 'dw1', (RowD,ColD)), cell(RealRowT, RealColT, 'tr1'), RowT is RealRowT - 2, ColT is RealColT - 2, retract_player_piece(_, 'tr1', (RowT,ColT)) , write('3'), assert_rock_piece('_r_', NewPosition);
        Piece = 'sr2' -> retract_player_piece(_, 'sr2', NewPosition), cell(RealRowD, RealColD, 'dw2'), RowD is RealRowD - 2, ColD is RealColD - 2, retract_player_piece(_, 'dw2', (RowD,ColD)), cell(RealRowT, RealColT, 'tr2'), RowT is RealRowT - 2, ColT is RealColT - 2, retract_player_piece(_, 'tr2', (RowT,ColT)) , write('3'), assert_rock_piece('_r_', NewPosition)
        );   
    move_rock_until_obstacle(NewPosition, Direction) 
    ). 
 
check_throw_collision(NewPosition, Result) :-
    (Row, Col) = NewPosition,
    write('Checking collision with '), write(NewPosition), nl,
    RealRow is Row + 2,
    RealCol is Col + 2,
    cell(RealRow, RealCol, Piece),
    (member(Piece, ['\\\\\\', '///', '|||','tr1', 'tr2', '_r_']) ->
    write('Rock collided with '), write(Piece), nl, Result = false;
    member(Piece,['sr1', 'sr2']) -> 
    write('Rock collided with '), write(Piece), nl, Result = sr;
    Result = true).
   






dw_move( Row, Col, NewPosition) :-
    write('Choose a direction to move:'), nl,
    read(Direction),
    (
    (Direction = 'up', NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol));
    (Direction = 'down', NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol) );
    (Direction = 'left', NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol) );
    (Direction = 'right', NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol) )
    ).

sr_move( Row, Col, NewPosition) :-
    write('Choose a direction to move:'), nl,
    read(Direction),
    (
    (Direction = 'up', NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol));
    (Direction = 'down', NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol));
    (Direction = 'left', NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol));
    (Direction = 'right', NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol))
    ).  






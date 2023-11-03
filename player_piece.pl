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
    assert_rock_piece('_r_', (9, 5)).


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
    player(Player), % Check if player exists
    player_piece(Player, Piece, Position), % Check if player has the piece
    (Row, Col) = Position,
    RealRow is Row + 2,
    RealCol is Col + 2,
    cell(RealRow, RealCol, Piece), % Check if piece is in the board
    choose_move(Piece, Position, NewPosition),
    assert_player_piece(Player, Piece, NewPosition).
    

choose_move(Piece, Position, NewPosition) :-
    ((Piece = 'tr1'; Piece = 'tr2'), retract_player_piece(Player, Piece, Position), tr_move(Position, NewPosition));
    ((Piece = 'dw1'; Piece = 'dw2'), retract_player_piece(Player, Piece, Position), dw_move(Position, NewPosition));
    ((Piece = 'sr1'; Piece = 'sr2'), retract_player_piece(Player, Piece, Position), sr_move(Position, NewPosition)).


tr_move(Position, NewPosition) :-
    (Row, Col) = Position,
    set_actual_rocks(ActualRocks),
    write('Choose a direction to move:'), nl,
    check_tr_options(Position, Options),
    print_option(Options),
    read(Choice),
    (
        (Choice = 1, member('up', Options), NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol), check_rock_for_throw(NewPosition, ActualRocks));
        (Choice = 2, member('down', Options), NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol), check_rock_for_throw(NewPosition, ActualRocks));
        (Choice = 3, member('left', Options), NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol), check_rock_for_throw(NewPosition, ActualRocks));
        (Choice = 4, member('right', Options), NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol), check_rock_for_throw(NewPosition, ActualRocks))
    ).


check_tr_options(Position, Options) :-
    (Row, Col) = Position,
    RealRow is Row + 2,
    RealCol is Col + 2,
    UpRow is RealRow - 1,
    DownRow is RealRow + 1,
    LeftCol is RealCol - 1,
    RightCol is RealCol + 1,
    cell(UpRow, RealCol, PieceUp),
    cell(DownRow, RealCol, PieceDown),
    cell(RealRow, LeftCol, PieceLeft),
    cell(RealRow, RightCol, PieceRight),
    (member(PieceUp, ['\\\\\\', '///', '|||', 'tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2']) -> Up is 0
        ;
        Up is 1
    ),
    (member(PieceDown, ['\\\\\\', '///', '|||', 'tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2']) -> Down is 0
        ;
        Down is 1
    ),
    (member(PieceLeft, ['\\\\\\', '///', '|||', 'tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2']) -> Left is 0
        ;
        Left is 1
    ),
    (member(PieceRight, ['\\\\\\', '///', '|||', 'tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2']) -> Right is 0
        ;
        Right is 1
    ),

    (Up = 1 -> append([], ['up'], NewOptions) ; NewOptions = []),
    (Down = 1 -> append([], ['down'], NewOptions2) ; NewOptions2 = []),
    (Left = 1 -> append([], ['left'], NewOptions3) ; NewOptions3 = []),
    (Right = 1 -> append([], ['right'], NewOptions4) ; NewOptions4 = []),

    append(NewOptions, NewOptions2, Options1),
    append(Options1, NewOptions3, Options2),
    append(Options2, NewOptions4, Options).


print_option(Options) :-
    ([H|T] = Options ; H = []),
    (
        H = [] -> true
        ;
        (
            (
                (H = 'up', write('1- '), write(H), nl);
                (H = 'down', write('2- '), write(H), nl);
                (H = 'left', write('3- '), write(H), nl);
                (H = 'right', write('4- '), write(H), nl)
            ),
            print_option(T)
        )
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
    (Row, Col) = RockPosition,
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
            (Row, Col) = NewRockPosition,
            write('NewRock position: '), write(NewRockPosition), nl,
            assert_rock_piece('_r_', NewRockPosition)
        )
        ;
        move_rock_until_obstacle(NewPosition, Direction) 
    ). 
 

check_throw_collision(NewPosition, Result) :-
    (Row, Col) = NewPosition,
    RealRow is Row + 2,
    RealCol is Col + 2,
    cell(RealRow, RealCol, Piece),
    (member(Piece, ['\\\\\\', '///', '|||', 'tr1', 'tr2', 'sr1', 'sr2', '_r_']) ->
        write('Rock collided with '), write(Piece), nl, Result = false
        ;
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


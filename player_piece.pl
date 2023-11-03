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


move_player_piece(Player, Piece, NewPlayer, Game) :-
    player(Player), % Check if player exists
    player_piece(Player, Piece, Position), % Check if player has the piece
    (Row, Col) = Position,
    RealRow is Row + 2,
    RealCol is Col + 2,
    cell(RealRow, RealCol, Piece), % Check if piece is in the board
    choose_move(Piece, Position, NewPosition, Player, NewPlayer, Game),
    assert_player_piece(Player, Piece, NewPosition).
    

choose_move(Piece, Position, NewPosition, Player, NewPlayer, Game) :-
    ((Piece = 'tr1'; Piece = 'tr2'), retract_player_piece(Player, Piece, Position), tr_move(Position, NewPosition, Player, NewPlayer, Game));
    ((Piece = 'dw1'; Piece = 'dw2'), retract_player_piece(Player, Piece, Position), dw_move(Position, NewPosition));
    ((Piece = 'sr1'; Piece = 'sr2'), retract_player_piece(Player, Piece, Position), sr_move(Position, NewPosition)).


tr_move(Position, NewPosition, Player, NewPlayer, Game) :-
    (Row, Col) = Position,
    set_actual_rocks(ActualRocks),
    write('Choose a direction to move:'), nl,
    check_tr_options(Position, Options),
    print_option(Options),
    read(Choice),
    (
        (Choice = 1, member('up', Options), NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol), check_rock_for_throw(NewPosition, ActualRocks, Player, NewPlayer, Game));
        (Choice = 2, member('down', Options), NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol), check_rock_for_throw(NewPosition, ActualRocks, Player, NewPlayer, Game));
        (Choice = 3, member('left', Options), NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol), check_rock_for_throw(NewPosition, ActualRocks, Player, NewPlayer, Game));
        (Choice = 4, member('right', Options), NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol), check_rock_for_throw(NewPosition, ActualRocks, Player, NewPlayer, Game))
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
    (Down = 1 -> append(NewOptions, ['down'], NewOptions2) ; NewOptions2 = NewOptions),
    (Left = 1 -> append(NewOptions2, ['left'], NewOptions3) ; NewOptions3 = NewOptions2),
    (Right = 1 -> append(NewOptions3, ['right'], Options) ; Options = NewOptions3).


check_rock_for_throw(NewPosition, ActualRocks, Player, NewPlayer, Game) :-
    ( member(NewPosition, ActualRocks) -> 
        write('In what direction do you want to throw the rock?'), nl,
        check_rock_throw_options(NewPosition, Options),
        print_option(Options),
        read(Choice),
        (
            (Choice = 1, member('up', Options), Answer = 'up');
            (Choice = 2, member('down', Options), Answer = 'down');
            (Choice = 3, member('left', Options), Answer = 'left');
            (Choice = 4, member('right', Options), Answer = 'right'); true
        ),
        (
            (Answer = 'up'; Answer = 'down'; Answer = 'left'; Answer = 'right') ->
            throw_rock(NewPosition, Answer, Game),
            (Player = player1 -> NewPlayer = player2 ; NewPlayer = player1)
        )
        ;
        NewPlayer = Player
        
    ).
    

check_rock_throw_options(Position, Options) :-
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
    (member(PieceUp, ['\\\\\\', '///', '|||', 'tr1', 'tr2']) -> Up is 0
        ;
        Up is 1
    ),
    (member(PieceDown, ['\\\\\\', '///', '|||', 'tr1', 'tr2']) -> Down is 0
        ;
        Down is 1
    ),
    (member(PieceLeft, ['\\\\\\', '///', '|||', 'tr1', 'tr2']) -> Left is 0
        ;
        Left is 1
    ),
    (member(PieceRight, ['\\\\\\', '///', '|||', 'tr1', 'tr2']) -> Right is 0
        ;
        Right is 1
    ),

    (Up = 1 -> append([], ['up'], NewOptions) ; NewOptions = []),
    (Down = 1 -> append(NewOptions, ['down'], NewOptions2) ; NewOptions2 = NewOptions),
    (Left = 1 -> append(NewOptions2, ['left'], NewOptions3) ; NewOptions3 = NewOptions2),
    (Right = 1 -> append(NewOptions3, ['right'], Options) ; Options = NewOptions3).


throw_rock(RockPosition, Direction, Game) :- 
    retract_rock_piece('_r_', RockPosition),
    move_rock_until_obstacle(RockPosition, Direction, Game),
    write('Rock thrown!'), nl.


move_rock_until_obstacle(RockPosition, Direction, Game) :-
    (Row, Col) = RockPosition,
    (
        (Direction = 'up', NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol));
        (Direction = 'down', NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol));
        (Direction = 'left', NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol));
        (Direction = 'right', NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol))
    ),
    check_throw_collision(NewPosition, Result),
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
            Game = splut,
            (SrRow, SrCol) = NewPosition,
            RealRowS is SrRow + 2,
            RealColS is SrCol + 2,
            cell(RealRowS, RealColS, Piece),
            (Piece = 'sr1' -> retract_player_piece(_, 'sr1', NewPosition), cell(RealRowD, RealColD, 'dw1'), RowD is RealRowD - 2, ColD is RealColD - 2, retract_player_piece(_, 'dw1', (RowD,ColD)), cell(RealRowT, RealColT, 'tr1'), RowT is RealRowT - 2, ColT is RealColT - 2, retract_player_piece(_, 'tr1', (RowT,ColT)) , write('3'), assert_rock_piece('_r_', NewPosition)
            ;
            Piece = 'sr2' -> retract_player_piece(_, 'sr2', NewPosition), cell(RealRowD, RealColD, 'dw2'), RowD is RealRowD - 2, ColD is RealColD - 2, retract_player_piece(_, 'dw2', (RowD,ColD)), cell(RealRowT, RealColT, 'tr2'), RowT is RealRowT - 2, ColT is RealColT - 2, retract_player_piece(_, 'tr2', (RowT,ColT)) , write('3'), assert_rock_piece('_r_', NewPosition)
            );   
        move_rock_until_obstacle(NewPosition, Direction, NewPlayer) 
    ).


check_throw_collision(NewPosition, Result) :-
    (Row, Col) = NewPosition,
    write('Checking collision with '), write(NewPosition), nl,
    RealRow is Row + 2,
    RealCol is Col + 2,
    cell(RealRow, RealCol, Piece),
    (member(Piece, ['\\\\\\', '///', '|||','tr1', 'tr2', '_r_']) ->
    write('Rock collided with '), write(Piece), nl, Result = false
    ;
    member(Piece,['sr1', 'sr2']) -> 
    write('Rock collided with '), write(Piece), nl, Result = sr
    ;
    Result = true).


dw_move(Position, NewPosition) :-
    (Row, Col) = Position,
    write('Choose a direction to move:'), nl,
    check_dw_options(Position, Options),
    print_option(Options),
    read(Choice),
    (
        (Choice = 1, member('up', Options), NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol));
        (Choice = 2, member('down', Options), NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol));
        (Choice = 3, member('left', Options), NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol));
        (Choice = 4, member('right', Options), NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol))
    ).


check_dw_options(Position, Options) :-
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

    (member(PieceUp, ['\\\\\\', '///', '|||']) -> Up is 0
        ;
        (
            member(PieceUp, ['tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']) -> 
            (
                check_dw_push('up', UpRow, RealCol) -> Up is 1 ; Up is 0
            )
            ;
            Up is 1
        )
    ),
    (member(PieceDown, ['\\\\\\', '///', '|||']) -> Down is 0
        ;
        (
            member(PieceDown, ['tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']) -> 
            (
                check_dw_push('down', DownRow, RealCol) -> Down is 1 ; Down is 0
            )
            ;
            Down is 1
        )
    ),
    (member(PieceLeft, ['\\\\\\', '///', '|||']) -> Left is 0
        ;
        (
            member(PieceLeft, ['tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']) -> 
            (
                check_dw_push('left', RealRow, LeftCol) -> Left is 1 ; Left is 0
            )
            ;
            Left is 1
        )
    ),
    (member(PieceRight, ['\\\\\\', '///', '|||']) -> Right is 0
        ;
        (
            member(PieceRight, ['tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']) -> 
            (
                check_dw_push('right', RealRow, RightCol) -> Right is 1 ; Right is 0
            )
            ;
            Right is 1
        )
    ),

    (Up = 1 -> append([], ['up'], NewOptions) ; NewOptions = []),
    (Down = 1 -> append(NewOptions, ['down'], NewOptions2) ; NewOptions2 = NewOptions),
    (Left = 1 -> append(NewOptions2, ['left'], NewOptions3) ; NewOptions3 = NewOptions2),
    (Right = 1 -> append(NewOptions3, ['right'], Options) ; Options = NewOptions3).


check_dw_push(Direction, Row, Col) :-
    (
        (Direction = 'up', NewRow is Row - 1, cell(NewRow, Col, Piece),
            (
                (member(Piece, ['tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']), check_dw_push(Direction, NewRow, Col))
                ;
                (member(Piece, ['\\\\\\', '///', '|||']), false)
                ;
                (member(Piece, ['   ']), true)
            )
        )
        ;
        (Direction = 'down', NewRow is Row + 1, cell(NewRow, Col, Piece),
            (
                (member(Piece, ['tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']), check_dw_push(Direction, NewRow, Col))
                ;
                (member(Piece, ['\\\\\\', '///', '|||']), false)
                ;
                (member(Piece, ['   ']), true)
            )
        )
        ;
        (Direction = 'left', NewCol is Col - 1, cell(Row, NewCol, Piece),
            (
                (member(Piece, ['tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']), check_dw_push(Direction, Row, NewCol))
                ;
                (member(Piece, ['\\\\\\', '///', '|||']), false)
                ;
                (member(Piece, ['   ']), true)
            )
        );
        (Direction = 'right', NewCol is Col + 1, cell(Row, NewCol, Piece),
            (
                (member(Piece, ['tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']), check_dw_push(Direction, Row, NewCol))
                ;
                (member(Piece, ['\\\\\\', '///', '|||']), false)
                ;
                (member(Piece, ['   ']), true)
            )
        )
    ).


sr_move(Position, NewPosition) :-
    (Row, Col) = Position,
    set_actual_rocks(ActualRocks),
    write('Choose a direction to move:'), nl,
    check_sr_options(Position, Options),
    print_option(Options),
    read(Choice),
    (
        (Choice = 1, member('up', Options), NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol));
        (Choice = 2, member('down', Options), NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol));
        (Choice = 3, member('left', Options), NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol));
        (Choice = 4, member('right', Options), NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol))
    ).


check_sr_options(Position, Options) :-
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

    /* FIX THIS */
    (member(PieceUp, ['\\\\\\', '///', '|||']) -> Up is 0
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
    (Down = 1 -> append(NewOptions, ['down'], NewOptions2) ; NewOptions2 = NewOptions),
    (Left = 1 -> append(NewOptions2, ['left'], NewOptions3) ; NewOptions3 = NewOptions2),
    (Right = 1 -> append(NewOptions3, ['right'], Options) ; Options = NewOptions3).

:- use_module(library(lists)).

:- dynamic player/1.
:- dynamic rock_piece/2.
:- dynamic player_piece/3.
:- dynamic actual_rocks/1.
:- dynamic accumulatedlist/2.
:- dynamic chosen_rock_position/1.


set_actual_rocks(List) :-
    findall(Position, rock_piece('_r_', Position), List).


initialize_players :-
    assert(player(player1)),
    assert(player(player2)),
    initialize_pieces.


% Piece manipulation

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
    (Row, Col) = Position,
    RealRow is Row + 2,
    RealCol is Col + 2,
    retractall(rock_piece(Piece, Position)),
    retract_cell(RealRow, RealCol),
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


move(Player, Piece, NewPlayer, Game, HaveUsedLevitate, UsedLevitate, StopLevitation, IsComputer) :-
    player(Player), % Check if player exists
    player_piece(Player, Piece, Position), % Check if player has the piece
    (Row, Col) = Position,
    RealRow is Row + 2,
    RealCol is Col + 2,
    cell(RealRow, RealCol, Piece), % Check if piece is in the board
    choose_move(Piece, Position, NewPosition, Player, NewPlayer, Game, HaveUsedLevitate, UsedLevitate, StopLevitation, IsComputer),
    assert_player_piece(Player, Piece, NewPosition).


choose_move(Piece, Position, NewPosition, Player, NewPlayer, Game, HaveUsedLevitate, UsedLevitate, StopLevitation, IsComputer) :-
    ((Piece = 'tr1'; Piece = 'tr2'), retract_player_piece(Player, Piece, Position), tr_move(Position, NewPosition, Player, NewPlayer, Game, IsComputer));
    ((Piece = 'dw1'; Piece = 'dw2'), retract_player_piece(Player, Piece, Position), dw_move(Position, NewPosition, IsComputer));
    ((Piece = 'sr1'; Piece = 'sr2'), retract_player_piece(Player, Piece, Position), sr_move(Position, NewPosition, HaveUsedLevitate, UsedLevitate, StopLevitation, IsComputer)).


tr_move(Position, NewPosition, Player, NewPlayer, Game, IsComputer) :-
    (Row, Col) = Position,
    set_actual_rocks(ActualRocks),
    check_tr_options(Position, Options),
    (IsComputer = 0 ->
        (
            write('Choose a direction to move:'), nl,
            print_option(Options),
            read(Choice),
            (
                (Choice = 1, member('up', Options), NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol),BackRow is Row + 1, BackCol is Col, BackPosition=(BackRow,BackCol), check_for_rock_pull(Position, ActualRocks, 'up', BackPosition, IsComputer), check_rock_for_throw(NewPosition, ActualRocks, Player, NewPlayer, Game, IsComputer));
                (Choice = 2, member('down', Options), NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol),BackRow is Row - 1, BackCol is Col, BackPosition=(BackRow,BackCol), check_for_rock_pull(Position, ActualRocks, 'down', BackPosition, IsComputer), check_rock_for_throw(NewPosition, ActualRocks, Player, NewPlayer, Game, IsComputer));
                (Choice = 3, member('left', Options), NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol),BackRow is Row, BackCol is Col + 1, BackPosition=(BackRow,BackCol),  check_for_rock_pull(Position, ActualRocks, 'left', BackPosition, IsComputer), check_rock_for_throw(NewPosition, ActualRocks, Player, NewPlayer, Game, IsComputer));
                (Choice = 4, member('right', Options), NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol),BackRow is Row, BackCol is Col -1, BackPosition=(BackRow,BackCol), check_for_rock_pull(Position, ActualRocks, 'right', BackPosition, IsComputer),check_rock_for_throw(NewPosition, ActualRocks, Player, NewPlayer, Game, IsComputer))
            )
        )
        ;
        (
            random_select(Options, Choice),
            (
                (Choice = up, NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol),BackRow is Row + 1, BackCol is Col, BackPosition=(BackRow,BackCol), check_for_rock_pull(Position, ActualRocks, 'up', BackPosition, IsComputer), check_rock_for_throw(NewPosition, ActualRocks, Player, NewPlayer, Game, IsComputer));
                (Choice = down, NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol),BackRow is Row - 1, BackCol is Col, BackPosition=(BackRow,BackCol), check_for_rock_pull(Position, ActualRocks, 'down', BackPosition, IsComputer), check_rock_for_throw(NewPosition, ActualRocks, Player, NewPlayer, Game, IsComputer));
                (Choice = left, NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol),BackRow is Row, BackCol is Col + 1, BackPosition=(BackRow,BackCol),  check_for_rock_pull(Position, ActualRocks, 'left', BackPosition, IsComputer), check_rock_for_throw(NewPosition, ActualRocks, Player, NewPlayer, Game, IsComputer));
                (Choice = right, NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol),BackRow is Row, BackCol is Col -1, BackPosition=(BackRow,BackCol), check_for_rock_pull(Position, ActualRocks, 'right', BackPosition, IsComputer),check_rock_for_throw(NewPosition, ActualRocks, Player, NewPlayer, Game, IsComputer))
            )
        )
    ).


% checks possible options for troll move and puts them in a list
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


% checks if there is a rock to pull and asks the player if he wants to pull it
check_for_rock_pull(Position, ActualRocks, Direction, BackPosition, IsComputer) :-
    (member(BackPosition, ActualRocks)-> 
        (IsComputer = 0 ->
            (
                write('Do you want to pull the rock? '), nl,
                write('1. Yes'), nl,
                write('2. No'), nl,
                read(Answer)
            ) ; random_select([1,2], Answer)
        ),
        (Answer = 1 -> 
            (
                retract_rock_piece('_r_', BackPosition),
                assert_rock_piece('_r_', Position)
            ) ; true   
        )
    ) ; true.


% checks if there is a rock to throw in the new position and asks the player in what direction he wants to throw it
check_rock_for_throw(NewPosition, ActualRocks, Player, NewPlayer, Game, IsComputer) :-
    ( member(NewPosition, ActualRocks) -> 
        (
            check_rock_throw_options(NewPosition, Options),
            (IsComputer = 0 ->
                (
                    write('In what direction do you want to throw the rock?'), nl,
                    print_option(Options),
                    read(Choice)
                ) ; random_select(Options, Choice)
            ),
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
        ) ; NewPlayer = Player
    ).


% checks possible options for rock throw and puts them in a list
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


% throws the rock in the chosen direction
throw_rock(RockPosition, Direction, Game) :- 
    retract_rock_piece('_r_', RockPosition),
    move_rock_until_obstacle(RockPosition, Direction, Game),
    write('Rock thrown!'), nl.


% recursive function that moves the rock until it hits an obstacle 
move_rock_until_obstacle(RockPosition, Direction, Game) :-
    (Row, Col) = RockPosition,
    (
        (Direction = 'up', NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol));
        (Direction = 'down', NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol));
        (Direction = 'left', NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol));
        (Direction = 'right', NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol))
    ),
    check_throw_collision(NewPosition, Result),
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
            (Piece = 'sr1' -> retract_player_piece(_, 'sr1', NewPosition), cell(RealRowD, RealColD, 'dw1'), RowD is RealRowD - 2, ColD is RealColD - 2, retract_player_piece(_, 'dw1', (RowD,ColD)), cell(RealRowT, RealColT, 'tr1'), RowT is RealRowT - 2, ColT is RealColT - 2, retract_player_piece(_, 'tr1', (RowT,ColT)) , assert_rock_piece('_r_', NewPosition)
            ;
            Piece = 'sr2' -> retract_player_piece(_, 'sr2', NewPosition), cell(RealRowD, RealColD, 'dw2'), RowD is RealRowD - 2, ColD is RealColD - 2, retract_player_piece(_, 'dw2', (RowD,ColD)), cell(RealRowT, RealColT, 'tr2'), RowT is RealRowT - 2, ColT is RealColT - 2, retract_player_piece(_, 'tr2', (RowT,ColT)) , assert_rock_piece('_r_', NewPosition)
            );   
        move_rock_until_obstacle(NewPosition, Direction, Game) 
    ).


% checks if the rock collides with NewPosition
check_throw_collision(NewPosition, Result) :-
    (Row, Col) = NewPosition,
    RealRow is Row + 2,
    RealCol is Col + 2,
    cell(RealRow, RealCol, Piece),
    (member(Piece, ['\\\\\\', '///', '|||','tr1', 'tr2', '_r_']) ->
    Result = false
    ;
    member(Piece,['sr1', 'sr2']) -> 
    Result = sr
    ;
    Result = true
    ).


% dwarf moves which includes pushing pieces
dw_move(Position, NewPosition, IsComputer) :-
    (Row, Col) = Position,
    assert(accumulatedlist('up', [])),
    assert(accumulatedlist('down', [])),
    assert(accumulatedlist('left', [])),
    assert(accumulatedlist('right', [])),
    check_dw_options(Position, Options),
    accumulatedlist('up', AccumulatedList1),
    accumulatedlist('down', AccumulatedList2),
    accumulatedlist('left', AccumulatedList3),
    accumulatedlist('right', AccumulatedList4),
    retractall(accumulatedlist('up', _)),
    retractall(accumulatedlist('down', _)),
    retractall(accumulatedlist('left', _)),
    retractall(accumulatedlist('right', _)),

    (IsComputer = 0 ->
        (
            write('Choose a direction to move:'), nl,
            print_option(Options),
            read(Choice),
            (
                (Choice = 1, member('up', Options), NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol), move_accumulated_list('up', NewPosition, AccumulatedList1));
                (Choice = 2, member('down', Options), NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol), move_accumulated_list('down', NewPosition, AccumulatedList2));
                (Choice = 3, member('left', Options), NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol), move_accumulated_list('left', Newosition, AccumulatedList3));
                (Choice = 4, member('right', Options), NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol), move_accumulated_list('right', NewPosition, AccumulatedList4))
            )
        )
        ;
        (
            random_select(Options, Choice),
            (
                (Choice = up, NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol), move_accumulated_list('up', NewPosition, AccumulatedList1));
                (Choice = down, NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol), move_accumulated_list('down', NewPosition, AccumulatedList2));
                (Choice = left, NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol), move_accumulated_list('left', NewPosition, AccumulatedList3));
                (Choice = right, NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol), move_accumulated_list('right', NewPosition, AccumulatedList4))
            )
        )
    ).


% recursive function that moves the pieces accumulated in the list
move_accumulated_list(_, _, []).
move_accumulated_list(Direction, InitialPosition, [Piece|Rest]) :-
    (Row, Col) = InitialPosition,
    (
        (Direction = 'up', NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol));
        (Direction = 'down', NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol));
        (Direction = 'left', NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol));
        (Direction = 'right', NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol))
    ),
    (assert_player_piece(player1, Piece, NewPosition); assert_player_piece(player2, Piece, NewPosition)),
    move_accumulated_list(Direction, NewPosition, Rest).


% checks possible options for dwarf move and puts them in a list
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
                check_dw_push('up', UpRow, RealCol,Result, Acc ), (Result = true -> Up is 1 ; Up is 0)
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
                check_dw_push('down', DownRow, RealCol,Result, Acc ),(Result = true -> Down is 1 ; Down is 0)
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
                check_dw_push('left', RealRow, LeftCol,Result, Acc ),(Result = true -> Left is 1 ; Left is 0)
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
                check_dw_push('right', RealRow, RightCol, Result, Acc),(Result = true -> Right is 1 ; Right is 0)
            )
            ;
            Right is 1
        )
    ),

    (Up = 1 -> append([], ['up'], NewOptions) ; NewOptions = []),
    (Down = 1 -> append(NewOptions, ['down'], NewOptions2) ; NewOptions2 = NewOptions),
    (Left = 1 -> append(NewOptions2, ['left'], NewOptions3) ; NewOptions3 = NewOptions2),
    (Right = 1 -> append(NewOptions3, ['right'], Options) ; Options = NewOptions3).


% recursive function that checks if there is a piece to push in the chosen direction and accumulates them in a list
check_dw_push(Direction, Row, Col, Result, Acc) :-
    (
        (Direction = 'up', NewRow is Row - 1, cell(Row, Col, Piece), nl,
            (
                member(Piece, ['tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']) ->
                    accumulatedlist('up', List),
                    append(List, [Piece], NewList),
                    asserta(accumulatedlist('up', NewList)),
                    check_dw_push(Direction, NewRow, Col, Result, NewList)
                ;
                member(Piece, ['\\\\\\', '///', '|||']) ->
                    retractall(accumulatedlist('up', _)),
                    asserta(accumulatedlist('up', [])),
                    Result = false
                ;
                member(Piece, ['   ']) -> 
                    Result = true
            )
        )
        ;
        (Direction = 'down', NewRow is Row + 1, cell(Row, Col, Piece), nl,
            (
                member(Piece, ['tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']) ->
                    accumulatedlist('down', List),
                    append(List, [Piece], NewList),
                    asserta(accumulatedlist('down', NewList)),
                    check_dw_push(Direction, NewRow, Col, Result, NewList)
                ;
                member(Piece, ['\\\\\\', '///', '|||']) ->
                    retractall(accumulatedlist('down', _)),
                    asserta(accumulatedlist('down', [])),
                    Result = false
                ;
                member(Piece, ['   ']) -> 
                    Result = true
            )
        )
        ;
        (Direction = 'left', NewCol is Col - 1, cell(Row, Col, Piece), nl,
            (
                member(Piece, ['tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']) ->
                    accumulatedlist('left', List),
                    append(List, [Piece], NewList),
                    asserta(accumulatedlist('left', NewList)),
                    check_dw_push(Direction, Row, NewCol, Result, NewList)
                ;
                member(Piece, ['\\\\\\', '///', '|||']) ->
                    retractall(accumulatedlist('left', _)),
                    asserta(accumulatedlist('left', [])),
                    Result = false
                ;
                member(Piece, ['   ']) -> 
                    Result = true
            )
        )
        ;
        (Direction = 'right', NewCol is Col + 1, cell(Row, Col, Piece), nl,
            (
                member(Piece, ['tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']) ->
                    accumulatedlist('right',List),
                    append(List, [Piece], NewList),
                    asserta(accumulatedlist('right',NewList)),

                    check_dw_push(Direction, Row, NewCol, Result, NewList)
                ;
                member(Piece, ['\\\\\\', '///', '|||']) ->
                    retractall(accumulatedlist('right',_)),
                    asserta(accumulatedlist('right',[])),
                    Result = false

                ;
                member(Piece, ['   ']) ->
                    Result = true
            )
        )
    ).


% sorcerer moves which includes levitation
sr_move(Position, NewPosition, HaveUsedLevitate, UsedLevitate, StopLevitation, IsComputer) :-
    (Row, Col) = Position,
    check_sr_options(Position, Options, HaveUsedLevitate, UsedLevitate, ChosenRock, StopLevitation, Ok, IsComputer),
    (RockRow, RockCol) = ChosenRock,
    
    (IsComputer = 0 ->
        (
            write('Choose a direction to move:'), nl,
            print_option(Options),
            read(Choice),
            (
                (Choice = 1, member('up', Options), NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol), (Ok = 1 -> NewRockRow is RockRow - 1, NewRockCol is RockCol, NewRockPosition = (NewRockRow, NewRockCol), retract_rock_piece('_r_', ChosenRock), assert_rock_piece('_r_', NewRockPosition),ChosenRockPositionAux = NewRockPosition; true));
                (Choice = 2, member('down', Options), NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol), (Ok = 1 -> NewRockRow is RockRow + 1, NewRockCol is RockCol, NewRockPosition = (NewRockRow, NewRockCol), retract_rock_piece('_r_', ChosenRock), assert_rock_piece('_r_', NewRockPosition),ChosenRockPositionAux = NewRockPosition; true ));
                (Choice = 3, member('left', Options), NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol), (Ok = 1 -> NewRockRow is RockRow, NewRockCol is RockCol - 1, NewRockPosition = (NewRockRow, NewRockCol), retract_rock_piece('_r_', ChosenRock), assert_rock_piece('_r_', NewRockPosition),ChosenRockPositionAux = NewRockPosition; true));
                (Choice = 4, member('right', Options), NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol), (Ok = 1-> NewRockRow is RockRow, NewRockCol is RockCol + 1, NewRockPosition = (NewRockRow, NewRockCol), retract_rock_piece('_r_', ChosenRock), assert_rock_piece('_r_', NewRockPosition),ChosenRockPositionAux = NewRockPosition; true))
            )
        )
        ; 
        (
            random_select(Options, Choice),
            (
                (Choice = up, NewRow is Row - 1, NewCol is Col, NewPosition = (NewRow, NewCol), (Ok = 1 -> NewRockRow is RockRow - 1, NewRockCol is RockCol, NewRockPosition = (NewRockRow, NewRockCol), retract_rock_piece('_r_', ChosenRock), assert_rock_piece('_r_', NewRockPosition),ChosenRockPositionAux = NewRockPosition; true));
                (Choice = down, NewRow is Row + 1, NewCol is Col, NewPosition = (NewRow, NewCol), (Ok = 1->NewRockRow is RockRow + 1, NewRockCol is RockCol, NewRockPosition = (NewRockRow, NewRockCol), retract_rock_piece('_r_', ChosenRock), assert_rock_piece('_r_', NewRockPosition),ChosenRockPositionAux = NewRockPosition; true ));
                (Choice = left, NewRow is Row, NewCol is Col - 1, NewPosition = (NewRow, NewCol), (Ok = 1-> NewRockRow is RockRow, NewRockCol is RockCol - 1, NewRockPosition = (NewRockRow, NewRockCol), retract_rock_piece('_r_', ChosenRock), assert_rock_piece('_r_', NewRockPosition),ChosenRockPositionAux = NewRockPosition; true));
                (Choice = right, NewRow is Row, NewCol is Col + 1, NewPosition = (NewRow, NewCol), (Ok = 1-> NewRockRow is RockRow, NewRockCol is RockCol + 1, NewRockPosition = (NewRockRow, NewRockCol), retract_rock_piece('_r_', ChosenRock), assert_rock_piece('_r_', NewRockPosition),ChosenRockPositionAux = NewRockPosition; true))
            )
        )
    ),
    retractall(chosen_rock_position(_)),
    (Ok = 1 -> asserta(chosen_rock_position(ChosenRockPositionAux)); true).


% checks possible options for sorcerer move and puts them in a list, also checks previous moves to see if levitation is possible
check_sr_options(Position, Options, HaveUsedLevitate, UsedLevitate, ChosenRock, StopLevitation, Ok, IsComputer) :-
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

    (member(PieceUp, ['\\\\\\', '///', '|||', 'tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']) -> Up is 0
        ;
        Up is 1
    ),
    (member(PieceDown, ['\\\\\\', '///', '|||', 'tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']) -> Down is 0
        ;
        Down is 1
    ),
    (member(PieceLeft, ['\\\\\\', '///', '|||', 'tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']) -> Left is 0
        ;
        Left is 1
    ),
    (member(PieceRight, ['\\\\\\', '///', '|||', 'tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']) -> Right is 0
        ;
        Right is 1
    ),

    (Up = 1 -> append([], ['up'], NewOptions) ; NewOptions = []),
    (Down = 1 -> append(NewOptions, ['down'], NewOptions2) ; NewOptions2 = NewOptions),
    (Left = 1 -> append(NewOptions2, ['left'], NewOptions3) ; NewOptions3 = NewOptions2),
    (Right = 1 -> append(NewOptions3, ['right'], SrcOptions) ; SrcOptions = NewOptions3),

    set_actual_rocks(ActualRocks),

    check_rock_levitate_options_for_each(ActualRocks, RockLevitateOptions),

    RockLevitateOptions = [(RockPosition1, OptionsForFirstRock), (RockPosition2, OptionsForSecondRock), (RockPosition3, OptionsForThirdRock), (RockPosition4, OptionsForFourthRock)],
    ListOfRocks = [RockPosition1, RockPosition2, RockPosition3, RockPosition4],


    get_same_options_levitate(SrcOptions, OptionsForFirstRock, FirstRockOptions),
    get_same_options_levitate(SrcOptions, OptionsForSecondRock, SecondRockOptions),
    get_same_options_levitate(SrcOptions, OptionsForThirdRock, ThirdRockOptions),
    get_same_options_levitate(SrcOptions, OptionsForFourthRock, FourthRockOptions),

    check_all_empty(FirstRockOptions,SecondRockOptions,ThirdRockOptions,FourthRockOptions, NewListOfOptions, Result, ListOfRocks, NewListOfRocks),

    ( ((HaveUsedLevitate = 0, Result = true, not_inst(StopLevitation)) ->
            (IsComputer = 0 ->
                (
                    write('Do you want to use Levitate?'), nl,
                    write('1. Yes'), nl,
                    write('2. No'), nl,
                    read(Levitate)
                ) ; random_select([1,2], Levitate)
            ),
            (
                Levitate = 1 -> 
                    Ok is 1,
                    UsedLevitate is 1,
                    Num is 1,

                    (IsComputer = 0 ->
                        (
                            write('Which rock do you want to levitate?'), nl,
                            print_rocks(NewListOfRocks, Num),
                            read(RockIndex)
                        )
                        ; 
                        (
                            length(NewListOfRocks, Length),
                            NewLength is Length + 1,
                            random(1, NewLength, RockIndex)
                        )
                    ),
                    get_rock_position(RockIndex, NewListOfRocks, RockPosition),
                    ListRockIndex is RockIndex - 1,
                    nth0(ListRockIndex, NewListOfOptions, FinalOptions),
                    ChosenRock = RockPosition,
                    Options = FinalOptions
                ; Options = SrcOptions,
                Ok is 0
            )
        ;
        (UsedLevitate = 1, Result = true, not_inst(StopLevitation))-> 
            chosen_rock_position(ChosenRockPosition),
            check_rock_levitate_options(ChosenRockPosition, ChosenRockOptions),
            get_same_options_levitate(SrcOptions, ChosenRockOptions, ChosenRockFinalOptions),
            
            (IsComputer = 0 ->
                (
                    write('Do you want to stop Levitating?'), nl,
                    (ChosenRockFinalOptions = [] -> write('1. Yes'), nl; write('1. Yes'), nl, write('2. No'), nl),
                    read(Levitate)
                ) ; (ChosenRockFinalOptions = [] -> Levitate = 1 ; random_select([1,2], Levitate))
            ),
            (
                Levitate = 1 -> 
                    StopLevitation is 1,
                    Options = SrcOptions,
                    Ok is 0
                ; 
                ChosenRock = ChosenRockPosition,
                Options = ChosenRockFinalOptions,
                Ok is 1

                
            )

        ; 
            Options = SrcOptions,
            Ok is 0
        )
    ).


% checks all the rocks options to see if they are empty, and add them to a new list if they are not
check_all_empty(FirstRockOptions,SecondRockOptions,ThirdRockOptions,FourthRockOptions, NewListOfOptions, Result, ListOfRocks, NewListOfRocks) :-
    ListOfRocks = [RockPosition1, RockPosition2, RockPosition3, RockPosition4],
    (FirstRockOptions = [] -> One is 1 ; One is 0),
    (SecondRockOptions = [] -> Two is 1 ; Two is 0),
    (ThirdRockOptions = [] -> Three is 1 ; Three is 0),
    (FourthRockOptions = [] -> Four is 1 ; Four is 0),
    (One = 0 -> append([], [RockPosition1], NewRocks) ; NewRocks = []),
    (Two = 0 -> append(NewRocks, [RockPosition2], NewRocks2) ; NewRocks2 = NewRocks),
    (Three = 0 -> append(NewRocks2, [RockPosition3], NewRocks3) ; NewRocks3 = NewRocks2),
    (Four = 0 -> append(NewRocks3, [RockPosition4], NewListOfRocks) ; NewListOfRocks = NewRocks3),
    (One = 0 -> append([], [FirstRockOptions], NewOptions) ; NewOptions = []),
    (Two = 0 -> append(NewOptions, [SecondRockOptions], NewOptions2) ; NewOptions2 = NewOptions),
    (Three = 0 -> append(NewOptions2, [ThirdRockOptions], NewOptions3) ; NewOptions3 = NewOptions2),
    (Four = 0 -> append(NewOptions3, [FourthRockOptions], NewListOfOptions) ; NewListOfOptions = NewOptions3),
    (NewListOfRocks = [] -> Result = false ; Result = true).
    

% recursive function that checks all the rocks moves options, and add them to a listof lists
check_rock_levitate_options_for_each([], []).
check_rock_levitate_options_for_each([RockPosition | RestOfRocks], [ (RockPosition,RockLevitateOption) | RestOfOptions] ):-
    check_rock_levitate_options(RockPosition, RockLevitateOption),
    check_rock_levitate_options_for_each(RestOfRocks, RestOfOptions).



% compares the options of the rock and the sorcerer and puts them in a list
get_same_options_levitate(SorcererOptions, RockOptions, FinalOptions) :-
    (member('up', SorcererOptions), member('up', RockOptions) -> append([], ['up'], NewOptions) ; NewOptions = []),
    (member('down', SorcererOptions), member('down', RockOptions) -> append(NewOptions, ['down'], NewOptions2) ; NewOptions2 = NewOptions),
    (member('left', SorcererOptions), member('left', RockOptions) -> append(NewOptions2, ['left'], NewOptions3) ; NewOptions3 = NewOptions2),
    (member('right', SorcererOptions), member('right', RockOptions) -> append(NewOptions3, ['right'], FinalOptions) ; FinalOptions = NewOptions3).


% checks the options for where the rock can move
check_rock_levitate_options(Position, Options) :-
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

    (member(PieceUp, ['\\\\\\', '///', '|||', 'tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']) -> Up is 0
        ;
        Up is 1
    ),
    (member(PieceDown, ['\\\\\\', '///', '|||', 'tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']) -> Down is 0
        ;
        Down is 1
    ),
    (member(PieceLeft, ['\\\\\\', '///', '|||', 'tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']) -> Left is 0
        ;
        Left is 1
    ),
    (member(PieceRight, ['\\\\\\', '///', '|||', 'tr1', 'tr2', 'sr1', 'sr2', 'dw1', 'dw2', '_r_']) -> Right is 0
        ;
        Right is 1
    ),

    (Up = 1 -> append([], ['up'], NewOptions) ; NewOptions = []),
    (Down = 1 -> append(NewOptions, ['down'], NewOptions2) ; NewOptions2 = NewOptions),
    (Left = 1 -> append(NewOptions2, ['left'], NewOptions3) ; NewOptions3 = NewOptions2),
    (Right = 1 -> append(NewOptions3, ['right'], Options) ; Options = NewOptions3).


% prints the rocks that the user can choose to levitate
print_rocks(Rocks, Num) :-
    Rocks = [H|T],
    write(Num), write('. '), write(H), nl,
    (
        T \= [] -> 
        (
            Num1 is Num + 1,
            print_rocks(T, Num1)
        ) ; true
    ).


% gets the rock from the list of rocks based on the index provided by the user
get_rock_position(RockIndex, Rocks, Position) :-
    Rocks = [H|T],
    (RockIndex \= 1 -> 
        (
            RockIndex1 is RockIndex - 1,
            get_rock_position(RockIndex1, T, Position)
        ) ; Position = H
    ).


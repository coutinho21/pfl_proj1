?- consult('board.pl'), consult('user_interface.pl'), consult('player_piece.pl'), consult('functions.pl'), consult('utils.pl').


play :-
    initialize_board,
    initialize_players,
    HaveUsedLevitate is 0,
    display_game(player1),
    next_turn(player1, NewPlayer, Game, HaveUsedLevitate, UsedLevitate),
    display_game(player2),
    HaveUsedLevitate1 is 0,
    next_turn(player2, NewPlayer1, Game1, HaveUsedLevitate1, UsedLevitate1),
    display_game(player2),
    check_used_levitate(HaveUsedLevitate1, UsedLevitate1, NewHaveUsedLevitate),
    next_turn(player2, NewPlayer2, Game2, NewHaveUsedLevitate, UsedLevitate1),    
    playing(player1).


% Players have 3 moves
playing(PlayerTurn) :-
    HaveUsedLevitate is 0,
    display_game(PlayerTurn),
    next_turn(PlayerTurn, NewPlayer, Game, HaveUsedLevitate, UsedLevitate),
    check_used_levitate(HaveUsedLevitate, UsedLevitate, NewHaveUsedLevitate),
    check_turn_change(NewPlayer, PlayerTurn, Game),
    display_game(PlayerTurn),
    next_turn(PlayerTurn, NewPlayer1, Game1, NewHaveUsedLevitate, UsedLevitate),
    check_used_levitate(NewHaveUsedLevitate, UsedLevitate, NewHaveUsedLevitate1),
    check_turn_change(NewPlayer1, PlayerTurn, Game1),
    display_game(PlayerTurn),
    next_turn(PlayerTurn, NewPlayer2, Game2, NewHaveUsedLevitate1, UsedLevitate),
    check_used_levitate(NewHaveUsedLevitate1, UsedLevitate, NewHaveUsedLevitate2),
    check_turn_change(NewPlayer2, PlayerTurn, Game2),
    ( PlayerTurn = player1 -> NextPlayer = player2 ; NextPlayer = player1 ),
    playing(NextPlayer).


% Check if the turn needs to be changed
check_turn_change(NewPlayer, PlayerTurn, Game) :-
    (
        not_inst(Game) -> (NewPlayer = PlayerTurn -> true ; playing(NewPlayer))
        ;
        (Game = splut, game_over(PlayerTurn))
    ).

game_over(Winner) :-
    display_game(Winner),
    nl,write('        SPLUT!         '), nl, nl,
    write(Winner), write(' won!!!'), nl, nl.

check_used_levitate(HaveUsedLevitate, UsedLevitate, NewHaveUsedLevitate) :-
    (HaveUsedLevitate = 0 ->
        (not_inst(UsedLevitate) -> true ; UsedLevitate = 1 -> NewHaveUsedLevitate is 1 ; NewHaveUsedLevitate is 0)
        ;
        true
    ).

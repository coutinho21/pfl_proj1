?- consult('board.pl'), consult('user_interface.pl'), consult('player_piece.pl'), consult('functions.pl'), consult('utils.pl').


play :-
    initialize_board,
    initialize_players,
    write('Choose a game mode:'), nl,
    write('1. Player vs Player'), nl,
    write('2. Player vs Computer'), nl,
    write('3. Computer vs Computer'), nl,
    read(GameMode),
    (
        GameMode = 1 -> player_vs_player
        ;
        GameMode = 2 -> player_vs_computer
        ;
        GameMode = 3 -> computer_vs_computer
        ;
        write('Invalid game mode!'), nl, play
    ).


player_vs_player :-
    HaveUsedLevitate is 0,
    display_game(player1),
    next_turn(player1, NewPlayer, Game, HaveUsedLevitate, UsedLevitate, StopLevitation),
    display_game(player2),
    HaveUsedLevitate1 is 0,
    next_turn(player2, NewPlayer1, Game1, HaveUsedLevitate1, UsedLevitate1, StopLevitation),
    display_game(player2),
    check_used_levitate(HaveUsedLevitate1, UsedLevitate1, NewHaveUsedLevitate),
    next_turn(player2, NewPlayer2, Game2, NewHaveUsedLevitate, UsedLevitate1, StopLevitation),  
    playing(player1).


% players have 3 moves
playing(PlayerTurn) :-
    HaveUsedLevitate is 0,
    display_game(PlayerTurn),
    check_used_levitate(HaveUsedLevitate, UsedLevitate, NewHaveUsedLevitate),
    next_turn(PlayerTurn, NewPlayer, Game, NewHaveUsedLevitate, UsedLevitate, StopLevitation),
    check_turn_change(NewPlayer, PlayerTurn, Game),
    display_game(PlayerTurn),
    check_used_levitate(NewHaveUsedLevitate, UsedLevitate, NewHaveUsedLevitate1),
    next_turn(PlayerTurn, NewPlayer1, Game1, NewHaveUsedLevitate1, UsedLevitate, StopLevitation),
    check_turn_change(NewPlayer1, PlayerTurn, Game1),
    display_game(PlayerTurn),
    check_used_levitate(NewHaveUsedLevitate1, UsedLevitate, NewHaveUsedLevitate2),
    next_turn(PlayerTurn, NewPlayer2, Game2, NewHaveUsedLevitate2, UsedLevitate, StopLevitation),
    check_turn_change(NewPlayer2, PlayerTurn, Game2),
    ( PlayerTurn = player1 -> NextPlayer = player2 ; NextPlayer = player1 ),
    playing(NextPlayer).


% check if the turn needs to be changed
check_turn_change(NewPlayer, PlayerTurn, Game) :-
    (
        not_inst(Game) -> (NewPlayer = PlayerTurn -> true ; playing(NewPlayer))
        ;
        (Game = splut, game_over(PlayerTurn))
    ).


game_over(Winner) :-
    display_game(Winner),
    nl, write('        SPLUT!         '), nl, nl,
    write('       '), write(Winner), write(' won!!!'), nl,
    halt.


check_used_levitate(HaveUsedLevitate, UsedLevitate, NewHaveUsedLevitate) :-
    (HaveUsedLevitate = 0 ->
        (not_inst(UsedLevitate) -> true ; UsedLevitate = 1 -> NewHaveUsedLevitate is 1 ; NewHaveUsedLevitate is 0)
        ;
        NewHaveUsedLevitate is 1
    ).


player_vs_computer :-
    HaveUsedLevitate is 0,
    display_game(player1),
    next_turn(player1, NewPlayer, Game, HaveUsedLevitate, UsedLevitate, StopLevitation),
    display_game(player2),
    HaveUsedLevitate1 is 0,
    next_turn_ai_level1(player2, NewPlayer1, Game1, HaveUsedLevitate1, UsedLevitate1, StopLevitation),
    display_game(player2),
    sleep_seconds(1000),
    check_used_levitate(HaveUsedLevitate1, UsedLevitate1, NewHaveUsedLevitate),
    next_turn_ai_level1(player2, NewPlayer2, Game2, NewHaveUsedLevitate, UsedLevitate1, StopLevitation),  
    playing_vs_computer(player1, 0).


% players have 3 moves
playing_vs_computer(PlayerTurn, IsComputer) :-
    HaveUsedLevitate is 0,
    display_game(PlayerTurn),
    (IsComputer = 1 -> sleep_seconds(1000) ; true),
    check_used_levitate(HaveUsedLevitate, UsedLevitate, NewHaveUsedLevitate),
    (IsComputer = 1 -> next_turn_ai_level1(PlayerTurn, NewPlayer, Game, NewHaveUsedLevitate, UsedLevitate, StopLevitation) ; next_turn(PlayerTurn, NewPlayer, Game, NewHaveUsedLevitate, UsedLevitate, StopLevitation)),
    check_turn_change_with_computer(NewPlayer, PlayerTurn, Game),
    display_game(PlayerTurn),
    (IsComputer = 1 -> sleep_seconds(1000) ; true),
    check_used_levitate(NewHaveUsedLevitate, UsedLevitate, NewHaveUsedLevitate1),
    (IsComputer = 1 -> next_turn_ai_level1(PlayerTurn, NewPlayer1, Game1, NewHaveUsedLevitate1, UsedLevitate, StopLevitation) ; next_turn(PlayerTurn, NewPlayer1, Game1, NewHaveUsedLevitate1, UsedLevitate, StopLevitation)),
    check_turn_change_with_computer(NewPlayer1, PlayerTurn, Game1),
    display_game(PlayerTurn),
    (IsComputer = 1 -> sleep_seconds(1000) ; true),
    check_used_levitate(NewHaveUsedLevitate1, UsedLevitate, NewHaveUsedLevitate2),
    (IsComputer = 1 -> next_turn_ai_level1(PlayerTurn, NewPlayer2, Game2, NewHaveUsedLevitate2, UsedLevitate, StopLevitation) ; next_turn(PlayerTurn, NewPlayer2, Game2, NewHaveUsedLevitate2, UsedLevitate, StopLevitation)),
    check_turn_change_with_computer(NewPlayer2, PlayerTurn, Game2),
    ( PlayerTurn = player1 -> (NextPlayer = player2, NewIsComputer = 1) ; (NextPlayer = player1, NewIsComputer = 0)),
    playing_vs_computer(NextPlayer, NewIsComputer).

% check if the turn needs to be changed with computer
check_turn_change_with_computer(NewPlayer, PlayerTurn, Game) :-
    (
        not_inst(Game) -> (NewPlayer = PlayerTurn -> true ; ((NewPlayer = player2 -> NewIsCumputer is 1 ; NewIsComputer is 0), playing_vs_computer(NewPlayer, NewIsCumputer)))
        ;
        (Game = splut, game_over(PlayerTurn))
    ).


computer_vs_computer :-
    HaveUsedLevitate is 0,
    display_game(player1),
    next_turn_ai_level1(player1, NewPlayer, Game, HaveUsedLevitate, UsedLevitate, StopLevitation),
    display_game(player2),
    HaveUsedLevitate1 is 0,
    sleep_seconds(500),
    next_turn_ai_level1(player2, NewPlayer1, Game1, HaveUsedLevitate1, UsedLevitate1, StopLevitation),
    display_game(player2),
    sleep_seconds(500),
    check_used_levitate(HaveUsedLevitate1, UsedLevitate1, NewHaveUsedLevitate),
    next_turn_ai_level1(player2, NewPlayer2, Game2, NewHaveUsedLevitate, UsedLevitate1, StopLevitation),  
    computer_vs_computer_playing(player1).


computer_vs_computer_playing(PlayerTurn) :-
    HaveUsedLevitate is 0,
    display_game(PlayerTurn),
    sleep_seconds(500),
    check_used_levitate(HaveUsedLevitate, UsedLevitate, NewHaveUsedLevitate),
    next_turn_ai_level1(PlayerTurn, NewPlayer, Game, NewHaveUsedLevitate, UsedLevitate, StopLevitation),
    check_turn_change_with_cp_cp(NewPlayer, PlayerTurn, Game),
    display_game(PlayerTurn),
    sleep_seconds(500),
    check_used_levitate(NewHaveUsedLevitate, UsedLevitate, NewHaveUsedLevitate1),
    next_turn_ai_level1(PlayerTurn, NewPlayer1, Game1, NewHaveUsedLevitate1, UsedLevitate, StopLevitation),
    check_turn_change_with_cp_cp(NewPlayer1, PlayerTurn, Game1),
    display_game(PlayerTurn),
    sleep_seconds(500),
    check_used_levitate(NewHaveUsedLevitate1, UsedLevitate, NewHaveUsedLevitate2),
    next_turn_ai_level1(PlayerTurn, NewPlayer2, Game2, NewHaveUsedLevitate2, UsedLevitate, StopLevitation),
    check_turn_change_with_cp_cp(NewPlayer2, PlayerTurn, Game2),
    ( PlayerTurn = player1 -> NextPlayer = player2 ; NextPlayer = player1 ),
    computer_vs_computer_playing(NextPlayer).


check_turn_change_with_cp_cp(NewPlayer, PlayerTurn, Game) :-
    (
        not_inst(Game) -> (NewPlayer = PlayerTurn -> true ; computer_vs_computer_playing(NewPlayer))
        ;
        (Game = splut, game_over(PlayerTurn))
    ).

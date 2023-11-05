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
        GameMode = 3 -> playing(player1)
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


% Players have 3 moves
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
    write(HaveUsedLevitate), nl,
    write(UsedLevitate), nl,
    (HaveUsedLevitate = 0 ->
        (not_inst(UsedLevitate) -> true ; UsedLevitate = 1 -> NewHaveUsedLevitate is 1 ; NewHaveUsedLevitate is 0)
        ;
        NewHaveUsedLevitate is 1
    ),
    write(NewHaveUsedLevitate),write('HaveUsedLevitate for the next one'), nl.


player_vs_computer :-
    HaveUsedLevitate is 0,
    display_game(player1),
    next_turn(player1, NewPlayer, Game, HaveUsedLevitate, UsedLevitate, StopLevitation),
    display_game(player2),
    HaveUsedLevitate1 is 0,
    next_turn_ai_level1(player2, NewPlayer1, Game1, HaveUsedLevitate1, UsedLevitate1, StopLevitation),
    display_game(player2),
    check_used_levitate(HaveUsedLevitate1, UsedLevitate1, NewHaveUsedLevitate),
    next_turn_ai_level1(player2, NewPlayer2, Game2, NewHaveUsedLevitate, UsedLevitate1, StopLevitation),  
    playing_vs_computer(player1, 0).


% Players have 3 moves
playing_vs_computer(PlayerTurn, IsComputer) :-
    HaveUsedLevitate is 0,
    display_game(PlayerTurn),
    check_used_levitate(HaveUsedLevitate, UsedLevitate, NewHaveUsedLevitate),
    (IsComputer = 1 -> next_turn_ai_level1(PlayerTurn, NewPlayer, Game, NewHaveUsedLevitate, UsedLevitate, StopLevitation) ; next_turn(PlayerTurn, NewPlayer, Game, NewHaveUsedLevitate, UsedLevitate, StopLevitation)),
    check_turn_change(NewPlayer, PlayerTurn, Game),
    display_game(PlayerTurn),
    check_used_levitate(NewHaveUsedLevitate, UsedLevitate, NewHaveUsedLevitate1),
    (IsComputer = 1 -> next_turn_ai_level1(PlayerTurn, NewPlayer1, Game1, NewHaveUsedLevitate1, UsedLevitate, StopLevitation) ; next_turn(PlayerTurn, NewPlayer1, Game1, NewHaveUsedLevitate1, UsedLevitate, StopLevitation)),
    check_turn_change(NewPlayer1, PlayerTurn, Game1),
    display_game(PlayerTurn),
    check_used_levitate(NewHaveUsedLevitate1, UsedLevitate, NewHaveUsedLevitate2),
    (IsComputer = 1 -> next_turn_ai_level1(PlayerTurn, NewPlayer2, Game2, NewHaveUsedLevitate2, UsedLevitate, StopLevitation) ; next_turn(PlayerTurn, NewPlayer2, Game2, NewHaveUsedLevitate2, UsedLevitate, StopLevitation)),
    check_turn_change(NewPlayer2, PlayerTurn, Game2),
    ( PlayerTurn = player1 -> (NextPlayer = player2, NewIsComputer = 1) ; (NextPlayer = player1, NewIsComputer = 0)),
    playing_vs_computer(NextPlayer, NewIsComputer).


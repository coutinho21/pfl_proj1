?- consult('board.pl'), consult('user_interface.pl'), consult('player_piece.pl'), consult('functions.pl'), consult('utils.pl').


play :-
    initialize_board,
    initialize_players,
    print_game_state(player1),
    next_turn(player1, NewPlayer, Game),
    print_game_state(player2),
    next_turn(player2, NewPlayer1, Game1),
    print_game_state(player2),
    next_turn(player2, NewPlayer2, Game2),    
    playing(player1).


% Players have 3 moves
playing(PlayerTurn) :-
    print_game_state(PlayerTurn),
    next_turn(PlayerTurn, NewPlayer, Game),
    check_turn_change(NewPlayer, PlayerTurn, Game),
    print_game_state(PlayerTurn),
    next_turn(PlayerTurn, NewPlayer1, Game1),
    check_turn_change(NewPlayer1, PlayerTurn, Game1),
    print_game_state(PlayerTurn),
    next_turn(PlayerTurn, NewPlayer2, Game2),
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

game_over(Player) :-
    print_game_state(Player),
    nl,write('        SPLUT!         '), nl, nl,
    write(Player), write(' won!!!'), nl, nl.
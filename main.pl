?- consult('board.pl'), consult('user_interface.pl'), consult('player_piece.pl'), consult('functions.pl'), consult('utils.pl').

start_game :-
    initialize_board,
    initialize_players,
    print_game_state(player1),
    next_turn(player1),
    print_game_state(player2),
    next_turn(player2),
    print_game_state(player2),
    next_turn(player2),    
    playing(player1).

% Players have 3 moves
playing(PlayerTurn) :-
    print_game_state(PlayerTurn),
    next_turn(PlayerTurn, NewPlayer),
    check_turn_change(NewPlayer, PlayerTurn),
    print_game_state(PlayerTurn),
    next_turn(PlayerTurn, NewPlayer1),
    check_turn_change(NewPlayer1, PlayerTurn),
    print_game_state(PlayerTurn),
    next_turn(PlayerTurn),
    ( PlayerTurn = player1 -> NextPlayer = player2 ; NextPlayer = player1 ),
    playing(NextPlayer).


check_turn_change(NewPlayer, PlayerTurn) :-
    (NewPlayer = PlayerTurn -> true ; playing(NewPlayer)).




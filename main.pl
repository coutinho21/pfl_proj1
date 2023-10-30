?- consult('board.pl'), consult('user_interface.pl'), consult('player_piece.pl').

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
    next_turn(player),
    print_game_state(PlayerTurn),
    next_turn(player),
    print_game_state(PlayerTurn),
    next_turn(player),
    ( PlayerTurn = player1 -> PlayerTurn = player2 ; PlayerTurn = player1 ),
    playing(1, PlayerTurn).


?- consult('board.pl'), consult('user_interface.pl').

play_game :-
    initialize_board,
    print_board.

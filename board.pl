/* Initialize the board */

initialize_board :-
    retractall(cell(_, _, _)), % Cleans the board
    assert_board_cells.

% Adds all cells to the board
assert_board_cells :-
    assert_cell(1, 1, ' '), assert_cell(1, 2, ' '), assert_cell(1, 3, ' '), assert_cell(1, 4, ' '), assert_cell(1, 5, 'X'), assert_cell(1, 6, ' '), assert_cell(1, 7, ' '), assert_cell(1, 8, ' '), assert_cell(1, 9, ' '),
    assert_cell(2, 1, ' '), assert_cell(2, 2, ' '), assert_cell(2, 3, ' '), assert_cell(2, 4, 'X'), assert_cell(2, 5, 'X'), assert_cell(2, 6, 'X'), assert_cell(2, 7, ' '), assert_cell(2, 8, ' '), assert_cell(2, 9, ' '),
    assert_cell(3, 1, ' '), assert_cell(3, 2, ' '), assert_cell(3, 3, 'X'), assert_cell(3, 4, 'X'), assert_cell(3, 5, 'X'), assert_cell(3, 6, 'X'), assert_cell(3, 7, 'X'), assert_cell(3, 8, ' '), assert_cell(3, 9, ' '),
    assert_cell(4, 1, ' '), assert_cell(4, 2, 'X'), assert_cell(4, 3, 'X'), assert_cell(4, 4, 'X'), assert_cell(4, 5, 'X'), assert_cell(4, 6, 'X'), assert_cell(4, 7, 'X'), assert_cell(4, 8, 'X'), assert_cell(4, 9, ' '),
    assert_cell(5, 1, 'X'), assert_cell(5, 2, 'X'), assert_cell(5, 3, 'X'), assert_cell(5, 4, 'X'), assert_cell(5, 5, 'X'), assert_cell(5, 6, 'X'), assert_cell(5, 7, 'X'), assert_cell(5, 8, 'X'), assert_cell(5, 9, 'X'),
    assert_cell(6, 1, ' '), assert_cell(6, 2, 'X'), assert_cell(6, 3, 'X'), assert_cell(6, 4, 'X'), assert_cell(6, 5, 'X'), assert_cell(6, 6, 'X'), assert_cell(6, 7, 'X'), assert_cell(6, 8, 'X'), assert_cell(6, 9, ' '),
    assert_cell(7, 1, ' '), assert_cell(7, 2, ' '), assert_cell(7, 3, 'X'), assert_cell(7, 4, 'X'), assert_cell(7, 5, 'X'), assert_cell(7, 6, 'X'), assert_cell(7, 7, 'X'), assert_cell(7, 8, ' '), assert_cell(7, 9, ' '),
    assert_cell(8, 1, ' '), assert_cell(8, 2, ' '), assert_cell(8, 3, ' '), assert_cell(8, 4, 'X'), assert_cell(8, 5, 'X'), assert_cell(8, 6, 'X'), assert_cell(8, 7, ' '), assert_cell(8, 8, ' '), assert_cell(8, 9, ' '),
    assert_cell(9, 1, ' '), assert_cell(9, 2, ' '), assert_cell(9, 3, ' '), assert_cell(9, 4, ' '), assert_cell(9, 5, 'X'), assert_cell(9, 6, ' '), assert_cell(9, 7, ' '), assert_cell(9, 8, ' '), assert_cell(9, 9, ' ').

% Creates a new cell
assert_cell(Row, Col, Symbol) :-
    assert(cell(Row, Col, Symbol)).


/* Board manipulation */

% Get the symbol at a specific cell
symbol_at(Row, Col, Symbol) :-
    cell(Row, Col, Symbol).

% Set the symbol at a specific cell
set_symbol_at(Row, Col, Symbol) :-
    retract(cell(Row, Col, _)),
    assert(cell(Row, Col, Symbol)).

:- dynamic cell/3.
/* Initialize the board */

initialize_board :-
    retractall(cell(_, _, _)), % Cleans the board
    assert_board_cells.

% Adds all cells to the board
assert_board_cells :-
    assert_cell(1, 1, '   '), assert_cell(1, 2, '   '), assert_cell(1, 3, ' 1 '), assert_cell(1, 4, ' 2 '), assert_cell(1, 5, ' 3 '), assert_cell(1, 6, ' 4 '), assert_cell(1, 7, ' 5 '), assert_cell(1, 8, ' 6 '), assert_cell(1, 9, ' 7 '), assert_cell(1, 10, ' 8 '), assert_cell(1, 11, ' 9 '), assert_cell(1, 12, '   '), assert_cell(1, 13, '   '),
    assert_cell(2, 1, '   '), assert_cell(2, 2, '   '), assert_cell(2, 3, '   '), assert_cell(2, 4, '   '), assert_cell(2, 5, '   '), assert_cell(2, 6, '   '), assert_cell(2, 7, '|||'), assert_cell(2, 8, '   '), assert_cell(2, 9, '   '), assert_cell(2, 10, '   '), assert_cell(2, 11, '   '), assert_cell(2, 12, '   '), assert_cell(2, 13, '   '),
    assert_cell(3, 1, ' 1 '), assert_cell(3, 2, '   '), assert_cell(3, 3, '   '), assert_cell(3, 4, '   '), assert_cell(3, 5, '   '), assert_cell(3, 6, '///'), assert_cell(3, 7, ' R '), assert_cell(3, 8, '\\\\\\'), assert_cell(3, 9, '   '), assert_cell(3, 10, '   '), assert_cell(3, 11, '   '), assert_cell(3, 12, '   '), assert_cell(3, 13, ' 1 '),
    assert_cell(4, 1, ' 2 '), assert_cell(4, 2, '   '), assert_cell(4, 3, '   '), assert_cell(4, 4, '   '), assert_cell(4, 5, '///'), assert_cell(4, 6, 'Tr2'), assert_cell(4, 7, 'Dw2'), assert_cell(4, 8, 'Sr2'), assert_cell(4, 9, '\\\\\\'), assert_cell(4, 10, '   '), assert_cell(4, 11, '   '), assert_cell(4, 12, '   '), assert_cell(4, 13, ' 2 '),
    assert_cell(5, 1, ' 3 '), assert_cell(5, 2, '   '), assert_cell(5, 3, '   '), assert_cell(5, 4, '///'), assert_cell(5, 5, '   '), assert_cell(5, 6, '   '), assert_cell(5, 7, '   '), assert_cell(5, 8, '   '), assert_cell(5, 9, '   '), assert_cell(5, 10, '\\\\\\'), assert_cell(5, 11, '   '), assert_cell(5, 12, '   '), assert_cell(5, 13, ' 3 '),
    assert_cell(6, 1, ' 4 '), assert_cell(6, 2, '   '), assert_cell(6, 3, '///'), assert_cell(6, 4, '   '), assert_cell(6, 5, '   '), assert_cell(6, 6, '   '), assert_cell(6, 7, '   '), assert_cell(6, 8, '   '), assert_cell(6, 9, '   '), assert_cell(6, 10, '   '), assert_cell(6, 11, '\\\\\\'), assert_cell(6, 12, '   '), assert_cell(6, 13, ' 4 '),
    assert_cell(7, 1, ' 5 '), assert_cell(7, 2, '|||'), assert_cell(7, 3, ' R '), assert_cell(7, 4, '   '), assert_cell(7, 5, '   '), assert_cell(7, 6, '   '), assert_cell(7, 7, '   '), assert_cell(7, 8, '   '), assert_cell(7, 9, '   '), assert_cell(7, 10, '   '), assert_cell(7, 11, ' R '), assert_cell(7, 12, '|||'), assert_cell(7, 13, ' 5 '),
    assert_cell(8, 1, ' 6 '), assert_cell(8, 2, '   '), assert_cell(8, 3, '\\\\\\'), assert_cell(8, 4, '   '), assert_cell(8, 5, '   '), assert_cell(8, 6, '   '), assert_cell(8, 7, '   '), assert_cell(8, 8, '   '), assert_cell(8, 9, '   '), assert_cell(8, 10, '   '), assert_cell(8, 11, '///'), assert_cell(8, 12, '   '), assert_cell(8, 13, ' 6 '),
    assert_cell(9, 1, ' 7 '), assert_cell(9, 2, '   '), assert_cell(9, 3, '   '), assert_cell(9, 4, '\\\\\\'), assert_cell(9, 5, '   '), assert_cell(9, 6, '   '), assert_cell(9, 7, '   '), assert_cell(9, 8, '   '), assert_cell(9, 9, '   '), assert_cell(9, 10, '///'), assert_cell(9, 11, '   '), assert_cell(9, 12, '   '), assert_cell(9, 13, ' 7 '),
    assert_cell(10, 1, ' 8 '), assert_cell(10, 2, '   '), assert_cell(10, 3, '   '), assert_cell(10, 4, '   '), assert_cell(10, 5, '\\\\\\'), assert_cell(10, 6, 'Sr1'), assert_cell(10, 7, 'Dw1'), assert_cell(10, 8, 'Tr1'), assert_cell(10, 9, '///'), assert_cell(10, 10, '   '), assert_cell(10, 11, '   '), assert_cell(10, 12, '   '), assert_cell(10, 13, ' 8 '),
    assert_cell(11, 1, ' 9 '), assert_cell(11, 2, '   '), assert_cell(11, 3, '   '), assert_cell(11, 4, '   '), assert_cell(11, 5, '   '), assert_cell(11, 6, '\\\\\\'), assert_cell(11, 7, ' R '), assert_cell(11, 8, '///'), assert_cell(11, 9, '   '), assert_cell(11, 10, '   '), assert_cell(11, 11, '   '), assert_cell(11, 12, '   '), assert_cell(11, 13, ' 9 '),
    assert_cell(12, 1, '   '), assert_cell(12, 2, '   '), assert_cell(12, 3, '   '), assert_cell(12, 4, '   '), assert_cell(12, 5, '   '), assert_cell(12, 6, '   '), assert_cell(12, 7, '|||'), assert_cell(12, 8, '   '), assert_cell(12, 9, '   '), assert_cell(12, 10, '   '), assert_cell(12, 11, '   '), assert_cell(12, 12, '   '), assert_cell(12, 13, '   '),
    assert_cell(13, 1, '   '), assert_cell(13, 2, '   '), assert_cell(13, 3, ' 1 '), assert_cell(13, 4, ' 2 '), assert_cell(13, 5, ' 3 '), assert_cell(13, 6, ' 4 '), assert_cell(13, 7, ' 5 '), assert_cell(13, 8, ' 6 '), assert_cell(13, 9, ' 7 '), assert_cell(13, 10, ' 8 '), assert_cell(13, 11, ' 9 '), assert_cell(13, 12, '   '), assert_cell(13, 13, '   ').



% Creates a new cell
assert_cell(Row, Col, Symbol) :-
    assert(cell(Row, Col, Symbol)).


/* Board manipulation */

% Set the symbol at a specific cell
set_symbol_at(Row, Col, Symbol) :-
    retract(cell(Row, Col, _)),
    assert(cell(Row, Col, Symbol)).

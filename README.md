# Practical Assignment 1 - 2023/2024 PFL

## Table of Contents
- [Identification](#identification)
- [Installation and Execution](#installation-and-execution)
- [Description of the Game](#description-of-the-game)
- [Game Logic](#game-logic)
  - [Internal Game State Representation](#internal-game-state-representation)
  - [Game State Visualization](#game-state-visualization)
  - [Move Validation and Execution](#move-validation-and-execution)
  - [List of Valid Moves](#list-of-valid-moves)
  - [End of Game](#end-of-game)
  - [Game State Evaluation](#game-state-evaluation)
  - [Computer Plays](#computer-plays)
- [Conclusions](#conclusions)
- [Bibliography](##bibliography)

## Identification
- **Topic**: Game
- **Group**: Group Designation
- **Members**:
  - Student 1 (Student Number 1, Full Name 1) - Contribution: X%
  - Student 2 (Student Number 2, Full Name 2) - Contribution: Y%
  - Student 3 (Student Number 3, Full Name 3) - Contribution: Z%
  - (Include all group members with their student numbers and contributions)
  
## Installation and Execution
To correctly execute the game in both Linux and Windows environments, follow these steps:
- Step 1: Install SICStus Prolog 4.8.
- Step 2: (Add installation steps specific to your game, e.g., downloading game files, dependencies, etc.)

## Description of the Game
(Insert a brief description of the game and its rules, up to 350 words. Include relevant links to official game websites, rule books, etc.)

## Game Logic
### Internal Game State Representation
(Describe how the game state is represented, including the board, current player, captured pieces, and other relevant information. Provide examples of the Prolog representation of initial, intermediate, and final game states.)

### Game State Visualization
(Explain the implementation of the game state display predicate, including menu systems and user interaction. The display predicate should be called `display_game(+GameState)`. Provide information on flexible game state representations.)

### Move Validation and Execution
(Describe how a play is validated and executed to obtain a new game state. The predicate responsible for this should be called `move(+GameState, +Move, -NewGameState)`.)

### List of Valid Moves
(Explain how to obtain a list of possible moves. The predicate should be named `valid_moves(+GameState, +Player, -ListOfMoves)`.)

### End of Game
(Describe how the end of the game is verified and identify the winner. The predicate should be called `game_over(+GameState, -Winner)`.)

### Game State Evaluation
(Explain how to evaluate the game state using the predicate `value(+GameState, +Player, -Value)`.)

### Computer Plays
(Describe how the computer chooses a move based on the level of difficulty. The predicate should be called `choose_move(+GameState, +Player, +Level, -Move)`. Define different levels of difficulty.)

## Conclusions
(Provide conclusions about the work, including limitations and possible improvements, up to 250 words.)

## Bibliography
(List books, papers, web pages, and other resources used during the development of the assignment.)
``

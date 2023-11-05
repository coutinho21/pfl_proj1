# Practical Assignment 1 - 2023/2024 PFL
# Splut

> **Group**: Splut_7
> 
> **Members**:
> - Guilherme nome todo Coutinho, up202108872 - XX%
> - Xavier Ribeiro Outeiro, up202108895 - XX%


## Table of Contents
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
- [Bibliography](#bibliography)


  
## Installation and Execution
To correctly execute the game in both Linux and Windows environments, follow these steps:
- Step 1: Install SICStus Prolog 4.8.
- Step 2: Fazer o download dos ficheiros presentes em PFL_TP1_T05_Splut7.zip e descompactá-los.
- Step 3: Dentro do diretório src consulte o ficheiro main.pl através da linha de comandos ou pela própria UI do Sicstus Prolog 4.7.1.
- Step 4: Para iniciar o jogo executa-se o predicado play/0
```pl
?- play.
```

## Description of the Game
Splut! is a 2 player abstract board game. It is played on a diamond-shaped board. Each player starts with three pieces: a Stonetroll, a Dwarf, and a Sorcerer. 
The objective is to eliminate the opposing Sorcerer by throwing a Rock at his head, resulting in the removal of the entire team.

Players take turns, with each typically making three steps per turn, except for the first and second players who have limited steps initially. TThe pieces have different kind of moves:

   - Stonetrolls: If a rock is right behind them they can pull it in the direction of their move and and throw Rocks by moving in to it space, they chose the direction for the thrown and them the rock moves in straight lines until it its an obstacle.

   - Dwarves: Dwarves can push consecutive rows of pieces in a straight line during their moves.

   - Sorcerers: Sorcerers can levitate Rocks that make the same move as them.

Splut! requires careful planning and is a challenging board game that rewards clever and tactical gameplay.
The game rules are [here](https://www.iggamecenter.com/en/rules/splut#board).


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
This work has proven to be a great way to learn both a new language and a different way of thinking, which was new to us. We believe that we have reinforced our prior knowledge and also expanded it.

On the other hand, due to the fact that we also have numerous projects for other curricular units, we had insufficient time to fulfill all the requirements and to develop the game more in the way we intended to.

We wanted to have implemented the Level2 of computer play, we thought on trying to always move troll to the closest position of the sorcerer line, or to try to move the rock to the closest position of the sorcerer line.

Given our limited knowledge of this language, which has proven to be one of the challenging factors, it also contributed to the lack of time being the major difficulty in this project.

## Bibliography
The game rules were consulted [here](https://www.iggamecenter.com/en/rules/splut#board).


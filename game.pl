%parse the gameConfig and build the GameState trough that
initial_state(H/H-11, [['.','P','.','P','.','P','.','P','.','P','.'],
                      ['B','.','B','.','B','.','B','.','B','.','B'],
                      ['.','P','.','P','.','P','.','P','.','P','.'],
                      ['B','.','B','.','B','.','B','.','B','.','B'],
                      ['.','P','.','P','.','P','.','P','.','P','.'],
                      ['B','.','B','.','B','.','B','.','B','.','B'],
                      ['.','P','.','P','.','P','.','P','.','P','.'],
                      ['B','.','B','.','B','.','B','.','B','.','B'],
                      ['.','P','.','P','.','P','.','P','.','P','.'],
                      ['B','.','B','.','B','.','B','.','B','.','B'],
                      ['.','P','.','P','.','P','.','P','.','P','.']]).


play:-
    write('Type the config:'), nl,
    read(Config),
    initial_state(Config, Board), print_board(Board).



print_row([]) :- nl.
print_row([H|T]) :-
    write(H), write(' '),
    print_row(T).


print_board([]).
print_board([Row|Rest]) :-
    print_row(Row),
    print_board(Rest), fail.
    
/*initial_state(+GameConfig, -GameState).
This predicate receives a desired game configuration and
returns the corresponding initial game state. Game configuration includes the type of each player
and other parameters such as board size, use of optional rules, player names, or other information
to provide more flexibility to the game. The game state describes a snapshot of the current game
state, including board configuration (typically using list of lists with different atoms for the different
pieces), identifies the current player (the one playing next), and possibly captured pieces and/or
pieces yet to be played, or any other information that may be required, depending on the game.

display_game(+GameState).

move(+GameState, +Move, -NewGameState).

valid_moves(+GameState, -ListOfMoves).

game_over(+GameState, -Winner).

value(+GameState, +Player, -Value).

choose_move(+GameState, +Level, -Move).
*/

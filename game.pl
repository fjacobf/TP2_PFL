%[ current_player , [board] , [p1 , p2]] where p1,p2 0,1,2 based on difficulty and game type and board [P | [X | Y]] where P is colour and XY the coordinates

play:-
    clear_screen,
    write('Hello! Welcome to Ayu! Press any of the numbers to choose your option'), nl,
    write('1 - Start a game'), nl,
    write('2 - Rules'), nl,
    write('3 - Quit'), nl,
    read(Choice),
    handle_choice(Choice).


handle_choice(1) :-
    get_game_config(Config),
    initial_state(Config, IntialState), !,
    print_board(IntialState).

handle_choice(2) :-
    write('Ayu Rules:'), nl,
    write('1. Players take turns placing stones on the board.'), nl,
    write('2. The objective is to capture more stones than your opponent.'), nl,
    write('3. Captures are made by surrounding opponent stones.'), nl,
    write('4. The game ends when the board is full.'), nl,
    write('Type anything to go back to menu...'),
    read(_),
    play.

handle_choice(3) :-
    write('Goodbye!'), nl.

handle_choice(_) :-
    write('Invalid choice. Please choose 1, 2, or 3.'), nl,
    play.

get_game_config(Config) :-
    clear_screen,
    write('Choose the board size (11, 9 or 7):'), nl,
    read(Size),
    write('Player whites \n 0 - Human \n 1 - Random Machine \n 2 - Greedy Machine'), nl,
    read(P1),
    write('Player blacks \n 0 - Human \n 1 - Random Machine \n 2 - Greedy Machine'), nl,
    read(P2),
    Config = [Size,P1,P2].

initial_state([1,0,0],[['.','P','.','P','.','P','.','P','.','P','.'],
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


print_row([]) :- nl.
print_row([H|T]) :-
    write(H), write(' '),
    print_row(T).


print_board([]).
print_board([Row|Rest]) :-
    print_row(Row),
    print_board(Rest),
    read(_),
    fail.

clear_screen :-
    write('\e[2J'),    % ANSI escape code to clear the screen
    write('\e[H'),     % Move cursor to the top-left corner
    flush_output.   

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

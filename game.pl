:-use_module(library(between)).
:-use_module(library(lists)).

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
    display_game(IntialState).

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

initial_state([Size,P1,P2], GameState):-
    build_board(Size, Board),
    GameState = ['white', Board, [P1,P2]].

build_board(Size, Board) :-
    findall([Piece, [Row, Col]],
            (between(1, Size, Row),         % Iterate through rows
             between(1, Size, Col),         % Iterate through columns
             piece_at(Row, Col, Piece)),    % Determine the piece at (Row, Col)
            Board).

% Determine the piece at a given position
piece_at(Row, Col, b) :-
    1 is Row mod 2,        % Odd row
    0 is Col mod 2.        % Even column
piece_at(Row, Col, w) :-
    0 is Row mod 2,        % Even row
    1 is Col mod 2.        % Odd column


clear_screen :-
    write('\e[2J'),    % ANSI escape code to clear the screen
    write('\e[H'),     % Move cursor to the top-left corner
    flush_output.   


display_game(GameState):-
    write(GameState), nl,
    read(_).

/*initial_state(+GameConfig, -GameState).
This predicate receives a desired game configuration and
returns the corresponding initial game state. Game configuration includes the type of each player
and other parameters such as board size, use of optional rules, player names, or other information
to provide more flexibility to the game. The game state describes a snapshot of the current game
state, including board configuration (typically using list of lists with different atoms for the different
pieces), identifies the current player (the one playing next), and possibly captured pieces and/or
pieces yet to be played, or any other information that may be required, depending on the game.

move(+GameState, +Move, -NewGameState).

valid_moves(+GameState, -ListOfMoves).

game_over(+GameState, -Winner).

value(+GameState, +Player, -Value).

choose_move(+GameState, +Level, -Move).
*/

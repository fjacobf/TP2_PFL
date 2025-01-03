:-use_module(library(between)).
:-use_module(library(lists)).
:- use_module(library(random)).
:- [display_game].
:- [move].
:- [loop].

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
    initial_state(Config, IntialState),
    write('Black starts!'), nl,
    game_loop(IntialState).

handle_choice(2) :-
    write('Ayu Rules:'), nl,
    write('Black plays first, then turns alternate. On each turn, players must complete one of the following actions:'), nl,
    write('     -Move a friendly singleton to an adjacent empty point.'), nl,
    write('     -Take a piece from a friendly group and place it on a different empty point adjacent to the same group. All stones that were joined in a single group before the move must still be joined after the move.'), nl, nl,

    write('Every move must reduce the distance between the moved unit and the closest friendly unit. The distance between two units is the shortest path of adjacent empty points between them, i.e. the number of consecutive moves one would need to join them.'), nl, nl,

    write('OBJECTIVE: If a player cannot make a move on his turn, he wins. This usually occurs when said player has joined all his pieces in a single group.'), nl, nl,

    write('DRAWS: If a board position is repeated with the same player to move, the game will be declared a draw. This is a theoretical possibility if both players cooperate to it. You can find an example of a possible core of such a cooperative cycle in About Ayu. In actual play cooperative cycles do not occur.'), nl, nl,

    write('Type anything to go back to the menu...'), nl,
    read(_),
    play.

handle_choice(3) :-
    write('Goodbye!'), nl.

handle_choice(_) :-
    write('Invalid choice. Please choose 1, 2, or 3.'), nl,
    play.

%---------------------GAME CONFIG--------------------------
% Gets the board size and the players

get_game_config(Config) :- 
    clear_screen,
    write('Choose the board size (11, 9 or 7):'), nl,
    read(Size),
    write('Player blacks \n 0 - Human \n 1 - Random Machine \n 2 - Greedy Machine'), nl,
    read(P1),
    write('Player whites \n 0 - Human \n 1 - Random Machine \n 2 - Greedy Machine'), nl,
    read(P2),
    Config = [Size,P1,P2].

%---------------------INITIAL STATE-------------------------
initial_state([Size,P1,P2], GameState):-
    build_board(Size, Board),
    GameState = [b, [P1,P2], Board, Size].

build_board(Size, Board) :-
    findall([Piece, [Row, Col]],
            (between(1, Size, Row),
             between(1, Size, Col),
             piece_at(Row, Col, Piece)),
            Board).

piece_at(Row, Col, b) :-
    1 is Row mod 2,        % Odd row
    0 is Col mod 2.        % Even column
piece_at(Row, Col, w) :-
    0 is Row mod 2,        % Even row
    1 is Col mod 2.        % Odd column
%-----------------------------------------------------------

clear_screen :-
    write('\e[2J'),    % ANSI escape code to clear the screen
    write('\e[H'),     % Move cursor to the top-left corner
    flush_output.   


/*Returns the current player's name if he no longer can make
any moves, else returns 0*/
game_over(GameState, Winner):-
    valid_moves(GameState, Moves_l),
    game_over(GameState, Moves_l, Winner).

game_over([Player|X], [], Player):-!.

game_over(GameState, Len, 0).


/*
move(+GameState, +Move, -NewGameState).

valid_moves(+GameState, -ListOfMoves).

game_over(+GameState, -Winner).

value(+GameState, +Player, -Value).

choose_move(+GameState, +Level, -Move).
*/

/*
[p,
[
[p,[1,2]],
[p,[2,3]],
[b,[2,2]]
],
[1,2]]
-----------
[cur, board, players, size]
board - [[colour, [x,y]]]
players - [p1,p2]

parse
[cur_player | [board | [players | size]]]
cur_player - p or b
board - 
    [colour, pos]
    colour - p or b ask about changing to piece - [colour, number]
    pos - 
        [x, y]
players - 
    [p1, p2]
    0, 1 or 2




value = (pa + pb)/d -
    pa - pieces in cluster a 
    pb - pieces in cluster b 
    d - distance
*/
:-use_module(library(between)).
:-use_module(library(lists)).
:- use_module(library(random)).

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
    game_loop(IntialState).

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

game_loop(IntialState) :-
    display_game(IntialState).

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
    GameState = ['white', Board, [P1,P2], Size].

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


clear_screen :-
    write('\e[2J'),    % ANSI escape code to clear the screen
    write('\e[H'),     % Move cursor to the top-left corner
    flush_output.   

/*chooses the computers move based on the selected level, for 1 it selects a random valid move, for 2 it chooses the move that creates highest value*/
choose_move(+GameState, +Level, -Move).
choose_move(GameState, 1, Move):-
    valid_moves(GameState, Moves_l),
    random_member(Move, Moves_l).
choose_move(GameState, 2, Move):-
    valid_moves(GameState, Moves_l),
    length(Moves_l, Lenght),
    test_moves(GameState, Moves_l, Moves_v),
    max_list(Moves_v, V),
    nth(Chosen, Moves_v, V),
    nth0(Chosen, Moves_l, Move).

/*creates list of move values*/
test_moves(GameState, [], []).
test_moves([Cur_player | X], [Hi|Ti], [Ho|To]):-
    move([Cur_player | X], Hi, NewGameState),
    value([Cur_player | X], Cur_player, Ho),
    test_moves([Cur_player | X], Ti, To).

/*prints the board and borders*/
display_game([Cur|[Board|[Players|Sizel]]]):-
    nth0(0, Sizel, Size),
    \+print_border_tb(Size),write('***'),nl,
    \+display_board(Board, Size),
    \+print_border_tb(Size),write('***'),nl,write('  '),
    \+print_let_coord(Size).

/*prints given board*/
display_board(Board, Size):-
    between(1, Size, X),
    N is Size + 1,
    C is N - X,
    write('* '),
    \+display_line(Board, C, Size),
    write('* '),write(C),
    nl,
    fail.

/*prints selected line*/
display_line(Board, Column, Size):-
    between(1, Size, R),
    display_char(Board, Column, R),
    fail.

/*prints corresponding coordinate's value, p, b, or . if empty*/
display_char(Board, Column, Row):-
    member([X, [Column, Row]], Board),
    write(X), write(' ').
display_char(Board, Column, Row):-
    \+member([X, [Column, Row]], Board),
    write('.'), write(' ').

/*prints out upper and lower borders*/
print_border_tb(Size):-
    between(1,Size,X),
    write('**'),
    fail.

print_let_coord(Size):-
    between(1, Size, X),
    N is X + 64,
    put_code(N), write(' '),
    fail.

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
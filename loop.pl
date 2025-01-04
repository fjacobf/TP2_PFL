:- [move_game].

game_loop(GameState) :-
    display_game(GameState),
    who_moves(GameState, Move),
    move(GameState, Move, NewGameState),
    game_loop(NewGameState).


who_moves([b | [[P1|P2] | BS]], Move) :-
    nl, write('Black moves!'), nl,
    (P1 > 0 -> choose_move([b | [[P1|P2] | BS]], P1, Move); choose_pos(b, BS, Move)).

who_moves([w | [[P1|P2] | BS]], Move) :-
    nl, write('White moves!'), nl,
    (P2 > 0 -> choose_move([w | [[P1|P2] | BS]], P2, Move); choose_pos(w, BS, Move)).


/*Returns the current player's name if he no longer can make
any moves, else returns 0*/
game_over(GameState, Winner):-
    valid_moves(GameState, Moves_l),
    game_over(GameState, Moves_l, Winner).

game_over([Player|X], [], Player):-!.

game_over(GameState, Len, 0).
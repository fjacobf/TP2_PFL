
game_loop([Cur_Player| [Players | [Board|Size]]]) :-
    display_game([Board|Size]).


/*Returns the current player's name if he no longer can make
any moves, else returns 0*/
game_over(GameState, Winner):-
    valid_moves(GameState, Moves_l),
    game_over(GameState, Moves_l, Winner).

game_over([Player|X], [], Player):-!.

game_over(GameState, Len, 0).
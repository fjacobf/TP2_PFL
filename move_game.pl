
%GS = [Cur_Player, Players, Board, Size]
/*chooses the computers move based on the selected level, for 1 it selects a random valid move, for 2 it chooses the move that creates highest value*/
%choose_move(+GameState, +Level, -Move).

move(_GameState, _Move, NewGameState):-
  write('moveu a peça!').

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
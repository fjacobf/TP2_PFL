
%GS = [Cur_Player, Players, Board, Size]
/*chooses the computers move based on the selected level, for 1 it selects a random valid move, for 2 it chooses the move that creates highest value*/
%choose_move(+GameState, +Level, -Move).

move([Cur_Player| [Players | [Board|[Size]]]], [RO,CO,RD,CD], NewGameState):-
  delete(Board, [Cur_player,[RO,CO]], TempBoard),
  NewBoard = [[Cur_Player, [RD,CD]] | TempBoard],
  (Cur_player = 'b' -> NewGameState = [w| [Players | [NewBoard|[Size]]]]; NewGameState = [b| [Players | [NewBoard|[Size]]]]).

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

%Our Board is [Row,Column] but the user types Column/Row-Column/Row
validate_move(Color, [Board| _Size], Move, RowO, ColumnO, RowD, ColumnD) :-
    member([Color, [RowO, ColumnO]], Board),
    \+member([_, [RowD, ColumnD]], Board).

validate_move(Color, [Board| _Size], Move, RowO, ColumnO, RowD, ColumnD) :-
    write('invalid move, try again! Try again!'), nl,
    choose_pos(Color, [Board| _Size], Move).

/*creates list of move values*/
test_moves(GameState, [], []).

test_moves([Cur_player | X], [Hi|Ti], [Ho|To]):-
    move([Cur_player | X], Hi, NewGameState),
    value([Cur_player | X], Cur_player, Ho),
    test_moves([Cur_player | X], Ti, To).


%----------------------Extras-----------------------

choose_pos(Color, [Board| _Size],Move) :-
    write('What is your move? Write origin->destination (Ex: "a/2-a/3.")'),nl,
    read(ColumnO_unf/RowO-ColumnD_unf/RowD),
    format_column(ColumnO_unf, ColumnO),
    format_column(ColumnD_unf, ColumnD),
    validate_move(Color, [Board| _Size], Move, RowO, ColumnO, RowD, ColumnD),
    Move = [RowO, ColumnO, RowD, ColumnD].

format_column(Col_unf, Col):-
    char_code(Col_unf, Col_val),
    Col is Col_val - 96.

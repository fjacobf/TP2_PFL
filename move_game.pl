
move([Cur_Player| [Players | [Board|[Size]]]], [RO,CO,RD,CD], NewGameState):-
  delete(Board, [Cur_player,[RO,CO]], TempBoard),
  NewBoard = [[Cur_Player, [RD,CD]] | TempBoard],
  (Cur_player = 'b' -> NewGameState = [w| [Players | [NewBoard|[Size]]]]; NewGameState = [b| [Players | [NewBoard|[Size]]]]).

%------------------- choose move --------------------------

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

%---------------------validate move -----------------------------
%Our Board is [Row,Column] but the user types Column/Row-Column/Row
validate_move(Color, [Board| Size], [RowO, ColumnO, RowD, ColumnD]) :-
    member([Color, [RowO, ColumnO]], Board),
    \+ member([_, [RowD, ColumnD]], Board),  % Position is not occupied
    RowD > 0, ColumnD > 0, RowD < Size+1, ColumnD < Size+1,
    find_group([Board| Size], [RowO, ColumnO], Color, Group_aux),
    delete(Group_aux, [Color, [RowO,ColumnO]], Group), !,
    test_singleton(Group, [RowO, ColumnO], [RowD, ColumnD]),
    move_piece(Board, Color, [RowO,ColumnO], [RowD,ColumnD], NewBoard),
    find_group([NewBoard| Size], [RowD, ColumnD], Color, NewGroup),
     !,
    is_subset(Group, NewGroup).


test_singleton([], From, To) :-
    find_adjacent(From, Adj),
    member(To, Adj), !.

test_singleton([X],From,To):- true.

move_piece(Board, Color, [RowO, ColumnO], [RowD,ColumnD], NewBoard) :-
  delete(Board, [Color,[RowO, ColumnO]], TempBoard),
  NewBoard = [[Color, [RowD,ColumnD]] | TempBoard].

find_group([Board| Size], [Row, Col], Color, Group) :-
    flood_fill([Board| Size], [[Row, Col]], Color, [], Group).

flood_fill(_, [], _, Group, Group). % Base case: no more positions to explore

flood_fill([Board| Size], [[R, C]|ToVisit], Color, Visited, Group) :-
    \+ member([Color, [R, C]], Visited),          % If not already visited
    member([Color, [R, C]], Board),              % Ensure it's the correct color
    find_adjacent([R, C], Adj),                  % Get adjacent positions
    filter_valid_adj(Color, Adj, [Board| Size], Valid), % Filter valid adjacent positions
    append(Valid, ToVisit, NewToVisit),          % Add to the visit queue
    flood_fill([Board|Size], NewToVisit, Color, [[Color, [R, C]]|Visited], Group).

flood_fill(Board, [_|ToVisit], Color, Visited, Group) :-
    flood_fill(Board, ToVisit, Color, Visited, Group). % Skip invalid positions

find_adjacent([Row, Col], Adj) :-
    RowUp is Row - 1,
    RowDown is Row + 1,
    ColLeft is Col - 1,
    ColRight is Col + 1,
    Adj = [[RowUp, Col], [RowDown, Col], [Row, ColLeft], [Row, ColRight]].

filter_valid_adj(_,[], _, []). %maybe change for a maplists

filter_valid_adj(Color, [[Row, Col] | Rest], [Board| Size], [[Row, Col] | Valid]) :-
    valid_adj(Color, [Board| Size], [Row, Col]),
    filter_valid_adj(Color, Rest, [Board| Size], Valid).

filter_valid_adj(Color, [[_, _] | Rest], Board, Valid) :-
    filter_valid_adj(Color, Rest, Board, Valid).


valid_adj(Color, [Board| Size], [Row, Col]) :-
  member([Color, [Row, Col]], Board),
  Row > 0, Col > 0, Row < Size+1, Col < Size+1.

is_subset([], _). % An empty list is always a subset
is_subset([H | T], Group) :-
    member(H, Group), % Check if the head of the list is a member of the group
    is_subset(T, Group). % Recursively check the rest

/*creates list of move values*/
test_moves(GameState, [], []).

test_moves([Cur_player | X], [Hi|Ti], [Ho|To]):-
    move([Cur_player | X], Hi, NewGameState),
    value([Cur_player | X], Cur_player, Ho),
    test_moves([Cur_player | X], Ti, To).


%----------------------Extras-----------------------

choose_pos(Color, [Board| _Size], Move) :-
    write('What is your move? Write origin->destination (Ex: "a/2-a/3.")'),nl,
    read(ColumnO_unf/RowO-ColumnD_unf/RowD),
    format_column(ColumnO_unf, ColumnO),
    format_column(ColumnD_unf, ColumnD),
    (validate_move(Color, [Board| _Size], [RowO, ColumnO, RowD, ColumnD]) ->
    Move = [RowO, ColumnO, RowD, ColumnD],
    true;
    write('invalid move, try again!'), nl,
    choose_pos(Color, [Board| _Size], Move),
    true
    ).

format_column(Col_unf, Col):-
    char_code(Col_unf, Col_val),
    Col is Col_val - 96.

valid_moves([Cur_Player| [Players | [Board|_Size]]], ListOfMoves) :-
    findall(
        [RowO, ColumnO, RowD, ColumnD], (
            member([Cur_Player, [RowO, ColumnO]], Board), 
            validate_move(Cur_Player, [Board|_Size], [RowO, ColumnO, RowD, ColumnD])
        ),
        ListOfMoves
    ).

value(GameState, Player, Value):-
    valid_moves(GameState, ListOfMoves),
    get_value(GameState, ListOfMoves, Sum),
    Value is 100000 - Sum. % dont know if max_list will work with negatives, so most will avoid going there

get_value(GameState, [H|T], Sum):- get_value(GameState, [H|T], Sum, 0).
get_value(GameState, [], Sum, Sum).
get_value(GameState, [H|T], Sum, Acc):-
    move(GameState, H, NewGameState),
    valid_moves(NewGameState, ListOfMoves),
    length(ListOfMoves, Value),
    Acc1 is Acc + Value,
    get_value(GameState, T, Sum, Acc1).

/*
get_value(GameState, [], 0).
get_value(GameState, [H|T], Sum):-
    move(GameState, H, NewGameState),
    valid_moves(NewGameState, ListOfMoves),
    length(ListOfMoves, Value),
    get_value(GameState, T, Val_sum),
    Sum is Val_sum + Value.
*/
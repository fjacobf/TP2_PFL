:- [display_game].
:- use_module(library(between)).
:- use_module(library(lists)).

test :-
  Board = [[b, [1, 2]], [b, [1, 4]], [b, [1, 3]], [b,[1,6]], [b,[1,1]], [w, [3, 1]], [w, [3, 3]], [w, [4, 2]], [b, [5, 5]], [w, [7, 7]]],
  GameState = [b, [0,0], Board, 7],
  display_game(GameState),
  validate_move(b,[Board, 7], [1,2,1,5]).


validate_move(Color, [Board| Size], [RowO, ColumnO, RowD, ColumnD]) :-
    member([Color, [RowO, ColumnO]], Board),
    \+ member([_, [RowD, ColumnD]], Board),  % Position is not occupied
    RowD > 0, ColumnD > 0, RowD < Size, ColumnD < Size,
    find_group([Board| Size], [RowO, ColumnO], Color, Group_aux),
    delete(Group_aux, [Color, [RowO,ColumnO]], Group),
    move_piece(Board, Color, [RowO,ColumnO], [RowD,ColumnD], NewBoard),
    find_group([NewBoard| Size], [RowD, ColumnD], Color, NewGroup),
     !,
    is_subset(Group, NewGroup).

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
    filter_valid_positions(Color, Adj, [Board| Size], Valid), % Filter valid adjacent positions
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

filter_valid_positions(_,[], _, []). %maybe change for a maplists

filter_valid_positions(Color, [[Row, Col] | Rest], [Board| Size], [[Row, Col] | Valid]) :-
    valid_position(Color, [Board| Size], [Row, Col]),
    filter_valid_positions(Color, Rest, [Board| Size], Valid).

filter_valid_positions(Color, [[_, _] | Rest], Board, Valid) :-
    filter_valid_positions(Color, Rest, Board, Valid).


valid_position(Color, [Board| Size], [Row, Col]) :-
  member([Color, [Row, Col]], Board),  % Position is not occupied
  Row > 0, Col > 0, Row < Size, Col < Size.                  % Ensure within board bounds

is_subset([], _). % An empty list is always a subset
is_subset([H | T], Group) :-
    member(H, Group), % Check if the head of the list is a member of the group
    is_subset(T, Group). % Recursively check the rest

clear_screen :-
    write('\e[2J'),    % ANSI escape code to clear the screen
    write('\e[H'),     % Move cursor to the top-left corner
    flush_output.   
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
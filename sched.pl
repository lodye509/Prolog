% Part 1
z_names(N):- /*names of all pizza*/
pizza(N,_,_).

z_red(N):-   /*names of all pizza with red sauce*/
pizza(N,red,_).

z_notred(N):-  /*names of all pizza with non-red sauce*/
pizza(N,A,_),
A\=red.

z_veggie_toppings(T):- /*list of topping of viggie pizza*/
pizza(veggie,_,T).

z_veggie_toppings_sorted(S):-  /*sorted list of topping of viggie pizza*/
pizza(veggie,_,Z),
sort(Z,S).

z_popeye_toppings(T):- /*list of topping of popeye pizza*/
pizza(popeye,_,T).

z_popeye_toppings_sorted(S):-  /*list of topping of popeye pizza*/
pizza(popeye,_,Z),
sort(Z,S).

z_toppings_sorted(N,S):- /*sorted list of topping of pizza N*/
pizza(N,_,Z),
sort(Z,S).

z_are_toppings_sorted(N):- /*are list of topping of pizza N sorted?*/
pizza(N,_,A),
sort(A,S),
A == S.

z_are_toppings_not_sorted(N):- /*are list of topping of pizza N not sorted?*/
pizza(N,_,A),
sort(A,S),
A \= S.

z_single_topping(N):- /*names of all pizza with only one topping*/
pizza(N,_,[_|[]]).

z_multi_toppings(N):- /*names of all pizza with more than one topping*/
pizza(N,_,[_|R]),
length(R,L),
L >= 1.

z_3ormore_toppings(N):- /*names of all pizza with 3 or more topping*/
pizza(N,_,[_|R]),
length(R,L),
L >= 2.

z_12_toppings_1or(N):- /*names of all pizza with only one or two topping*/
pizza(N,_,[_|[]]);
pizza(N,_,[_|[_]]).

z_12_toppings_2wo(N):-
pizza(N,_,R),
length(R,L),
L = 1. /*use without prolog or operator ";" */

z_12_toppings_2wo(N):-
pizza(N,_,R),
length(R,L),
L = 2.

z_red_single_topping(N):- /*names of all pizza with red sauce and only one topping*/
pizza(N,red,[_|[]]).

z_white_single_topping(N):- /*names of all pizza with white sauce and only one topping*/
pizza(N,white,[_|[]]).

% Part 2
toe(_,[],[]).
toe(E,L,Z):-
L = [X|Y],
append(X,[[E]],H),
toe(E,Y,N),
Z=[H|N].

extract([],[]).
extract(L,Z):-
L = [X|Y],
X = [H|_], %member(H,X),!,
extract(Y,N),
Z = [H|N].

%Part3
z_mushrooms(N):-
pizza(N,_,R),
member(mushrooms,R).

z_holdthemushrooms(N):-
pizza(N,_,R),
\+member(mushrooms,R).

z_toppings(N,T):-
pizza(N,_,X),
member(T,X).

z_nonolives(NonOlivesToppings):-
pizza(veggie,_,T),
select(olives,T,NonOlivesToppings).

z_multi_toppings_list(NameList):-
findall(N,z_multi_toppings(N),NameList).

z_multi_toppings_list_have_red_sauce:-
z_multi_toppings_list(N),
maplist(z_red,N).

z_multi_toppings_list_have_toppings_not_sorted:-
z_multi_toppings_list(N),
maplist(z_are_toppings_not_sorted,N).

extractfindall(L,Z):-
findall(H,member([H|_],L),Z).

/*part 4*/
iscontiguouspremade([]).
iscontiguouspremade(L):-
length(L,N),
max_list(L,M),
min_list(L,S),
N =:= M - S + 1.

iscontiguousdiy([]).
iscontiguousdiy([_]).
iscontiguousdiy([X,Y|Z]):-
X =:= Y - 1,
iscontiguousdiy([Y|Z]).

/*part 5*/
mapcar(_P,[],[]).
mapcar(P,I,O):-
I = [H|T],
X=..[P,H,Z],
call(X),
mapcar(P,T,Q),
O = [Z|Q].

%part6a
selectNv0(0,[],L,L).
selectNv0(N,Z,L,R):-
select(H,L,Y),
Q is N-1,
selectNv0(Q,M,Y,B),
Z = [H|M],
R = B.

%part6b
selectN(0,[],L,L).
selectN(N,Z,L,R):-
append(X,Y,L),
Y = [H|C],
Q is N-1,
selectN(Q,Z1,C,R1),
Z = [H|Z1],
append(X,R1,R).


%part7a
/*
sws0(_,[],[],[]).
sws0(E,W,K,M):-
    E = [[HE1,HE2]|_],
    W = [[HW1|HW2]|TW],
    A = [HE1,HE2|[[HW1]]],
    append([HW1|HW2],[[HE1]],B),
    sws0(TE,TW,C,D),
    K = [A|C],
    M = [B|D].
*/
sws0(_,[],[],[]).
sws0(N, [H|T], K, M):-
  select(X, N, M1),
  X = [A|_],
  append(H, [[A]], M2),
  H = [C|_],
  append(X, [[C]], K1), 
  sws0(M1, T, K2, M3),
  M = [M2 | M3],
  K = [K1 | K2].

%part7b
sws2(_, [], [], []).
sws2(N, [H|T], K, M):-
  H = [A|P], 
  selectN(P, X, N, M1),
  toe(A,X,K1),
  extract(X, L),
  append(H, [L], M2),
  sws2(M1, T, K2, M3),
  append(K1,K2, K),
  M = [M2 | M3].

%part7c
sws4(_,[],[],[]).
sws4(N,[H|T],K,M):-
  H = [A|P], %[1,1]
  selectN(P, X, N, M1),
  sws4H(A,X,X1),
  toe(A,X1,K1),
  extract(X1, L),
  append(H, [L], M2),
  sws4(M1, T, K2, M3),
  append(K1,K2, K),
  M = [M2 | M3].

sws4H(_,[],[]).
sws4H(P,[H|Y],K):-
  H = [A|B],
  C is (B - P),
  C \= 0,
  M = [A|[C]],
  sws4H(P,Y,D),
  append([[M]],[D],K).









%%clingo 0 instances/ex02.lp -

% Tips:
% - You may include the facts below to represent the differences
%   between the coordinates of neighboring cells
%
% diff(0,1). diff(0,-1). diff(1,0). diff(-1,0).
diff(0,1). diff(0,-1). diff(1,0). diff(-1,0).
% Your encoding please...

N*N-1{allpath(X,Y,X1,Y1):cell(X,Y),cell(X1,Y1),diff(X-X1,Y-Y1)}N*N-1:-N= #count{X: cell(X,Y)}.
time(1..N*N-1):-N= #count{X: cell(X,Y)}.
max_time(T*T-1):-T= #count{X: cell(X,Y)}.

cover(X,Y):-allpath(_,_,X,Y),allpath(X,Y,_,_).
cover(X,Y):-first(X,Y),allpath(X,Y,_,_).
cover(X,Y):-final(X,Y),allpath(_,_,X,Y).
    
:-cell(X,Y),not cover(X,Y).

:-allpath(X,Y,_,_),final(X,Y).
:-allpath(_,_,X,Y),first(X,Y).

:-allpath(A,B,C,D),allpath(C,D,A,B).
    
%turn(X-X2,Y-Y2):-allpath(X,Y,_,_),first(X,Y),hint(X2,Y2,_).
%Y=0:-turn(X,Y).

%:-hint(X,Y,N),hint(X1,Y1,N1),
cover_hint(2..T):-T=#count{1,A,B,C: hint(A,B,C)}.
%:-allpath(X,Y,X1,Y1),hint(X2,Y2,N),first(X,Y),X1!=X2,Y1!=Y2.

%hint_path(X,Y,X2,Y2,1):-
%hint_path(X,Y,X2,Y2,T):-hint_path(X,Y,X2,Y2,T-1),
%hint_path(X,Y,X2,Y2,T):-

go_path(X,Y,X1,Y1,1):-allpath(X,Y,X1,Y1),first(X,Y).%,hint(X2,Y2,N),((X-X2)+(Y-Y2))<=1,((X-X2)+(Y-Y2))>=-1.
go_path(X1,Y1,X2,Y2,T):-go_path(_,_,X1,Y1,T-1),allpath(X1,Y1,X2,Y2),time(T).
:-go_path(_,_,X2,Y2,T),final(X2,Y2),not max_time(T).
:-time(T), not go_path(_,_,_,_,T).
    
go(X2,Y2,N,1):-first(X,Y),hint(X2,Y2,N),go_path(_,_,X2,Y2,K),L=(X-X2)/K,M=(Y-Y2)/K,diff(L,M).
:-not go(_,_,_,1).
    
%go_hint(X2,Y2,N,K):-go(X2,Y2,N,1),go_path(_,_,X2,Y2,K).
go_hint(X2,Y2,N,K):-hint(X2,Y2,N),go_path(_,_,X2,Y2,K).
    
1{go(X2,Y2,N,T):hint(X2,Y2,N)}1:-cover_hint(T).
:-hint(X2,Y2,N),not go(X2,Y2,N,_).

:-go(X,Y,N,K),go_hint(X,Y,N,T),go(X2,Y2,N1,K1),go_hint(X2,Y2,N1,T1),K<K1,T>T1.

    
path(A,B,C,D):-go_path(A,B,C,D,_).

%#show allpath/4. 
%#show hint_path/5. 
%#show go_path/5.
%#show path/4.
#show go/4.
#show go_hint/4.

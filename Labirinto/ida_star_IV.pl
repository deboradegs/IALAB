manhattan(RigaAttuale,ColonnaAttuale, Distanza):-
    finale(pos(RigaFinale,ColonnaFinale)),
    SommaRiga is abs(RigaAttuale-RigaFinale),
    SommaColonna is abs(ColonnaAttuale-ColonnaFinale),
    Distanza is SommaRiga+SommaColonna.

start(Azioni) :-
    iniziale(pos(RigaIniziale,ColonnaIniziale)),
    manhattan(RigaIniziale,ColonnaIniziale, Soglia),
    retractall(azioni(_)),
    assert(azioni([])),
    ida_s(0,[pos(RigaIniziale,ColonnaIniziale)],Soglia),
    azioni(Azioni).

%ida_s(_,Path,_,[]):-
%    pop(Path, NodoAttuale),
%    finale(NodoAttuale),!.

ida_s(_,Path,_):-
    pop(Path, NodoAttuale),
    finale(NodoAttuale),
    !.

ida_s(G,Path,Soglia):-
    pop(Path, pos(RigaAttuale,ColonnaAttuale)),
    esplora_successori(G+1,[],RigaAttuale,ColonnaAttuale,DictSuccessori),
    %write(DictSuccessori),
    findall(TerzoElemento, (member(Tupla, DictSuccessori), terzo_elemento(Tupla, TerzoElemento)), Euristiche),
    %terzi_elementi(DictSuccessori, Euristiche),
    %maplist(terzo(_,_,Y), DictSuccessori, Euristiche),
    %write(Euristiche),
    check_soglia(G,Euristiche,Path,DictSuccessori,Soglia, Min).

check_soglia(G,Euristiche, Path, DictSuccessori,Soglia, Min):-
    iniziale(pos(RigaIniziale,ColonnaIniziale)),
    min_list(Euristiche, Min),
    Min > Soglia,
    %pop(Path, Nodo),
    %select(Nodo, Path, VecchioPath),
    %VecchioG is G-1,
    %ida_s(VecchioG,VecchioPath,Soglia,Azioni);
    retractall(azioni(_)),
    assert(azioni([])),
    ida_s(0,[pos(RigaIniziale,ColonnaIniziale)],Min);
    min_list(Euristiche, Min),
    Min =< Soglia,
    member((_,Nodo, Min), DictSuccessori),
    \+member(Nodo, Path),
    NuovoG is G+1,
    member((Azione,Nodo, Min), DictSuccessori),
    azioni(A),
    retractall(azioni(_)),
    assert(azioni([Azione|A])),
    azioni(AA),
    write(AA),
    ida_s(NuovoG,[Nodo|Path],Soglia);
    min_list(Euristiche, Min),
    Min =< Soglia,
    member((_,Nodo, Min), DictSuccessori),
    member(Nodo, Path),
    select((_,Nodo,Min), DictSuccessori,NuovoDictSuccessori),
    select(Min,Euristiche,NuovoEuristiche),
    check_soglia(G,NuovoEuristiche, Path, NuovoDictSuccessori, Soglia,Min).





esplora_successori(G, Successori, RigaAttuale, ColonnaAttuale, DictSuccessori):- 
    length(Successori, L),
    L =:= 4,
    DictSuccessori = Successori;
    length(Successori, L),
    L =:= 0,
    nonvar(DictSuccessori),
    DictSuccessori \= [],
    DictSuccessori = Successori;
    %esplora_successori(G,[(Azione, pos(RigaSucc,ColonnaSucc), G+H)|Successori], RigaAttuale,ColonnaAttuale,DictSuccessori).
    applicabile(Azione, pos(RigaAttuale,ColonnaAttuale)),
    trasforma(Azione, pos(RigaAttuale,ColonnaAttuale), pos(RigaSucc,ColonnaSucc)),
    \+member((_,pos(RigaSucc,ColonnaSucc), _), Successori),
    manhattan(RigaSucc,ColonnaSucc, H),
    F is G+H,
    esplora_successori(G, [(Azione, pos(RigaSucc,ColonnaSucc), F)|Successori], RigaAttuale, ColonnaAttuale, NuovoDictSuccessori),
    DictSuccessori = [(Azione, pos(RigaSucc,ColonnaSucc), F)|NuovoDictSuccessori];
    DictSuccessori = Successori.


%esplora_successori(G,[(Azione, pos(RigaSucc,ColonnaSucc), G+H)|Successori], RigaAttuale,ColonnaAttuale,DictSuccessori):-
%    applicabile(Azione, pos(RigaAttuale,ColonnaAttuale)),
%    trasforma(Azione, pos(RigaAttuale,ColonnaAttuale), pos(RigaSucc,ColonnaSucc)),
 %   \+member((_,pos(RigaSucc,ColonnaSucc), _), DictSuccessori),
 %   manhattan(RigaSucc,ColonnaSucc, H),
 %   esplora_successori(G, Successori, RigaAttuale, ColonnaAttuale, NuovoDictSuccessori),
 %   DictSuccessori = [(Azione, pos(RigaSucc,ColonnaSucc), G+H)|NuovoDictSuccessori].


    %non si ferma il bastardo


%terzi_elementi([], []).
%terzi_elementi([(X,Y,Z)|Resto], T) :-
  %terzo(X,Y,Z, TerzoElemento),
%  terzi_elementi(Resto, [Z|T]).

%terzo(_,_, Y, Y).

terzo_elemento((_,_,TerzoElemento), TerzoElemento).



pop([X|_], X).
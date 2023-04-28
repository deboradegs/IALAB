manhattan(RigaAttuale,ColonnaAttuale, Distanza):-
    finale(pos(RigaFinale,ColonnaFinale)),
    SommaRiga is abs(RigaAttuale-RigaFinale),
    SommaColonna is abs(ColonnaAttuale-ColonnaFinale),
    Distanza is SommaRiga+SommaColonna.

pop([X|_], X).

push(Lista, X, [X|Lista]).

start(azioni(A)) :-
    %lastmin(LM),
    %LM=:=0,
    iniziale(pos(RigaIniziale,ColonnaIniziale)),
    %finale(NodoFinale),
    num_righe(NR),
    num_colonne(NC),
    manhattan(RigaIniziale,ColonnaIniziale, Distanza),
    retractall(lastmin(_)),
    assert(lastmin(NR*NC)),
    retractall(tentati(_)),
    assert(tentati([pos(RigaIniziale,ColonnaIniziale)])),
    retractall(azioni(_)),
    assert(azioni([])),
    %retractall(listaEFFE(_)),
    %assert(listaEFFE([Distanza])),
    ida(0,[pos(RigaIniziale,ColonnaIniziale)], Distanza);
    change_soglia(azioni(A)).

change_soglia(azioni(A)):-
    iniziale(pos(RigaIniziale,ColonnaIniziale)),
    retractall(tentati(_)),
    assert(tentati([pos(RigaIniziale,ColonnaIniziale)])),
    retractall(azioni(_)),
    assert(azioni([])),
    lastmin(LM),
    ida(0,[pos(RigaIniziale,ColonnaIniziale)], LM);
    change_soglia(azioni(A)).

%change_soglia(RigaIniziale,ColonnaIniziale):-
    %listaEFFE(X),
    %min_list(X,NuovaSoglia),
%    retractall(tentati(_)),
%    assert(tentati([pos(RigaIniziale,ColonnaIniziale)])),
%    retractall(azioni(_)),
%    assert(azioni([])),
%    lastmin(LM),
%    ida(0,[pos(RigaIniziale,ColonnaIniziale)], LM);
%    change_soglia(RigaIniziale,ColonnaIniziale).  

ida(_,ListaVisitati, _):-
    pop(ListaVisitati, NodoAttuale),
    finale(NodoAttuale),
    !.

%ida(G,ListaVisitati,Tentativi,[Azione|ListaAzioni], Soglia):-
    %print(ListaF),
    %pop(ListaVisitati, NodoAttuale),
    %applicabile(Azione,NodoAttuale),
    %trasforma(Azione,NodoAttuale,pos(RigaProssima,ColonnaProssima)),
    %\+member(pos(RigaProssima,ColonnaProssima),Tentativi),
    %manhattan(RigaProssima,ColonnaProssima,Distanza),
    %NuovoG is G+1,
    %F is NuovoG+Distanza,
    %listaEFFE(X),
    %push(X, F, NuovaListaF),
    %assert(listaEFFE(NuovaListaF)),
    %F>Soglia,
    %lastmin(LM),
    %F<LM,
    %assert(lastmin(F)),
    %ida(G,ListaVisitati,[pos(RigaProssima,ColonnaProssima)|Tentativi],ListaAzioni,Soglia).



ida(G,ListaVisitati, Soglia):-
    %print(ListaF),
    pop(ListaVisitati, NodoAttuale),
    applicabile(Azione,NodoAttuale),
    trasforma(Azione,NodoAttuale,pos(RigaProssima,ColonnaProssima)),
    tentati(T),
    \+member(pos(RigaProssima,ColonnaProssima),T),
    manhattan(RigaProssima,ColonnaProssima,Distanza),
    NuovoG is G+1,
    F is NuovoG+Distanza,
    %listaEFFE(X),
    %push(X, F, NuovaListaF),
    %assert(listaEFFE(NuovaListaF)),
    %F=< Soglia,
    %ida(NuovoG,[pos(RigaProssima,ColonnaProssima)|ListaVisitati],[pos(RigaIniziale,ColonnaIniziale)|Tentativi],ListaAzioni,Soglia).
    check_F(G,F,Soglia,RigaProssima,ColonnaProssima,ListaVisitati,NuovaListaVisitati,Gi,Azione),
    push(T,pos(RigaProssima,ColonnaProssima),NuovoT),
    retractall(tentati(_)),
    assert(tentati(NuovoT)),
    ida(Gi,NuovaListaVisitati,Soglia).

check_F(G,F,Soglia,RigaProssima,ColonnaProssima,ListaVisitati,NuovaListaVisitati,G+1,Azione):-
    push(ListaVisitati,pos(RigaProssima,ColonnaProssima),NuovaListaVisitati),
    F=<Soglia,
    azioni(A),
    push(A, Azione, ANuova),
    retractall(azioni(_)),
    assert(azioni(ANuova)).

check_F(G,F,Soglia,RigaProssima,ColonnaProssima,ListaVisitati,ListaVisitati,G,Azione):-
    F>Soglia,
    lastmin(LM),
    F<LM,
    retractall(lastmin(_)),
    assert(lastmin(F)).

check_F(G,F,Soglia,RigaProssima,ColonnaProssima,ListaVisitati,ListaVisitati,G,Azione):-
    F>Soglia,
    lastmin(LM),
    F>=LM.

%ida(_,_,_,_, ListaF) :-
    %print(ListaF),
%    iniziale(Start),
%    min_list(ListaF, Minimo),
%    ida(0,[Start],[],Minimo,[Minimo]).




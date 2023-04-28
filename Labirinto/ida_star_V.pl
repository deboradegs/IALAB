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
    retractall(esplorati(_)),
    assert(esplorati([])),
    retractall(visitati(_)),
    assert(visitati([([],pos(RigaIniziale,ColonnaIniziale),Soglia,[])])),
    ida_s(0,Soglia),
    azioni(Azioni),
    write(Azioni).


ida_s(_,_):-
    visitati(V),
    pop(V, TuplaAttuale),
    secondo_elemento(TuplaAttuale,NodoAttuale),
    finale(NodoAttuale),
    primo_elemento(TuplaAttuale,AzioniFinali),
    %retractall(azioni(_)),
    %assert(azioni(AzioniFinali)),
    !.

ida_s(G,Soglia):-
    visitati(V),
    pop(V, TuplaAttuale), 
    secondo_elemento(TuplaAttuale,pos(RigaAttuale,ColonnaAttuale)),
    esplora_successori(G+1,[],RigaAttuale,ColonnaAttuale,DictSuccessori),
    findall(TerzoElemento, (member(Tupla, DictSuccessori), terzo_elemento(Tupla, TerzoElemento)), Euristiche),
    check_soglia(G,Euristiche,DictSuccessori,Soglia, Min).

check_soglia(G,Euristiche, DictSuccessori,Soglia, Min):-
    min_list(Euristiche, Min),
    Min > Soglia,
    esplorati(E),
    findall(TerzoElemento, (member(Tupla, E), terzo_elemento(Tupla, TerzoElemento)), EuristicheDiScorta),
    min_list(EuristicheDiScorta,MinScorta),
    MinScorta=< Soglia,
    member((_,Nodo, MinScorta,_), E),
    member((Azioni,Nodo, MinScorta,_), E),
    retractall(azioni(_)),
    assert(azioni(Azioni)),
    member((Azioni,Nodo, MinScorta,SuoPath), E),
    select((Azioni,Nodo,MinScorta,SuoPath),E, NuovoE),
    retractall(esplorati(_)),
    assert(esplorati(NuovoE)),
    length(Azioni, L),
    %retractall(visitati(_)),
    %assert(visitati(SuoPath)),
    ida_s(L,Soglia);
    iniziale(pos(RigaIniziale,ColonnaIniziale)),
    min_list(Euristiche, Min),
    Min > Soglia,
    esplorati(E),
    findall(TerzoElemento, (member(Tupla, E), terzo_elemento(Tupla, TerzoElemento)), EuristicheDiScorta),
    min_list(EuristicheDiScorta,MinScorta),
    MinScorta>Soglia,
    retractall(esplorati(_)),
    assert(esplorati([])),
    retractall(azioni(_)),
    assert(azioni([])),
    retractall(visitati(_)),
    assert(visitati([([],pos(RigaIniziale,ColonnaIniziale),Soglia,[])])),
    ida_s(0,MinScorta);
    visitati(V),
    min_list(Euristiche, Min),
    Min =< Soglia,
    member((_,Nodo, Min,_), DictSuccessori),
    \+member((_,Nodo, _,_), V), %%%%%%%%%%%%%%%%%%%
    NuovoG is G+1,
    member((AzioniFinoA,Nodo, Min,_), DictSuccessori),
    azioni(A),
    is_list(AzioniFinoA),
    pop(AzioniFinoA,Azione),
    append([Azione], A, NuoveAzioni),
    retractall(azioni(_)),
    assert(azioni(NuoveAzioni)),
    esplorati(E),
    %azioni(AA),
    %write(AA),
    select((AzioniFinoA,Nodo,Min,_),E, NuovoE),
    retractall(esplorati(_)),
    assert(esplorati(NuovoE)),
    visitati(V),
    retractall(visitati(_)),
    assert(visitati([(AzioniFinoA,Nodo,Min,_)|V])),
    ida_s(NuovoG,Soglia);
    visitati(V),
    min_list(Euristiche, Min),
    Min =< Soglia,
    member((_,Nodo, Min,_), DictSuccessori),
    member((_,Nodo, Eur,_), V),
    Min < Eur,
    NuovoG is G+1,
    member((AzioniFinoA,Nodo, Min,_), DictSuccessori),
    azioni(A),
    is_list(AzioniFinoA),
    pop(AzioniFinoA,Azione),
    append([Azione], A, NuoveAzioni),
    retractall(azioni(_)),
    assert(azioni(NuoveAzioni)),
    esplorati(E),
    %azioni(AA),
    %write(AA),
    select((AzioniFinoA,Nodo,Min,_),E, NuovoE),
    retractall(esplorati(_)),
    assert(esplorati(NuovoE)),
    visitati(V),
    retractall(visitati(_)),
    assert(visitati([(AzioniFinoA,Nodo,Min,_)|V])),
    ida_s(NuovoG,Soglia);
    visitati(V),
    min_list(Euristiche, Min),
    Min =< Soglia,
    member((_,Nodo, Min,_), DictSuccessori),
    member((Azioni,Nodo, Eur,SuoPath), V),
    Min >= Eur,
    retractall(azioni(_)),
    assert(azioni(Azioni)),
    length(Azioni, L),
    retractall(visitati(_)),
    assert(visitati(SuoPath)),
    ida_s(L,Soglia);
    visitati(V),
    min_list(Euristiche, Min),
    Min =< Soglia,
    member((_,Nodo, Min,_), DictSuccessori),
    \+member((_,Nodo, _,_), V),
    NuovoG is G+1,
    member((Azione,Nodo, Min,_), DictSuccessori),
    azioni(A),
    \+is_list(Azione),
    append([Azione], A, NuoveAzioni),
    retractall(azioni(_)),
    assert(azioni(NuoveAzioni)),
    esplorati(E),
    %azioni(AA),
    %write(AA),
    select(([Azione],Nodo,Min,SuoPath),E, NuovoE),
    retractall(esplorati(_)),
    assert(esplorati(NuovoE)),
    visitati(V),
    retractall(visitati(_)),
    assert(visitati([([Azione],Nodo,Min,SuoPath)|V])),
    ida_s(NuovoG,Soglia);
    min_list(Euristiche, Min),
    Min =< Soglia,
    member((_,Nodo, Min,_), DictSuccessori),
    visitati(V),
    member((_,Nodo, Min,_), V),
    select((_,Nodo,Min,_), DictSuccessori,NuovoDictSuccessori),
    select(Min,Euristiche,NuovoEuristiche),
    check_soglia(G,NuovoEuristiche, NuovoDictSuccessori, Soglia,Min).





esplora_successori(G, Successori, RigaAttuale, ColonnaAttuale, DictSuccessori):- 
    length(Successori, L),
    L =:= 4,
    DictSuccessori = Successori;
    length(Successori, L),
    L =:= 0,
    nonvar(DictSuccessori),
    DictSuccessori \= [],
    DictSuccessori = Successori;
    applicabile(Azione, pos(RigaAttuale,ColonnaAttuale)),
    trasforma(Azione, pos(RigaAttuale,ColonnaAttuale), pos(RigaSucc,ColonnaSucc)),
    \+member((_,pos(RigaSucc,ColonnaSucc), _,_), Successori),
    manhattan(RigaSucc,ColonnaSucc, H),
    F is G+H,
    azioni(A),
    append([Azione], A, NuoveAzioni),
    %retractall(azioni(_)),
    %assert(azioni(NuoveAzioni)),
    esplorati(E),
    visitati(V),
    retractall(esplorati(_)),
    \+member((_,pos(RigaSucc,ColonnaSucc), Eur,_),E) ->
    assert(esplorati([(NuoveAzioni, pos(RigaSucc,ColonnaSucc), F, [pos(RigaSucc,ColonnaSucc)|V])|E])),
    esplora_successori(G, [(NuoveAzioni, pos(RigaSucc,ColonnaSucc), F, [pos(RigaSucc,ColonnaSucc)|V])|Successori], RigaAttuale, ColonnaAttuale, NuovoDictSuccessori),
    DictSuccessori = [(NuoveAzioni, pos(RigaSucc,ColonnaSucc), F,[pos(RigaSucc,ColonnaSucc)|V])|NuovoDictSuccessori];
    applicabile(Azione, pos(RigaAttuale,ColonnaAttuale)),
    trasforma(Azione, pos(RigaAttuale,ColonnaAttuale), pos(RigaSucc,ColonnaSucc)),
    \+member((_,pos(RigaSucc,ColonnaSucc), _,_), Successori),
    manhattan(RigaSucc,ColonnaSucc, H),
    F is G+H,
    azioni(A),
    append([Azione], A, NuoveAzioni),
    %retractall(azioni(_)),
    %assert(azioni(NuoveAzioni)),
    esplorati(E),
    visitati(V),
    retractall(esplorati(_)),
    member((_,pos(RigaSucc,ColonnaSucc), Eur,_),E),
    F<Eur,
    assert(esplorati([(NuoveAzioni, pos(RigaSucc,ColonnaSucc), F, [pos(RigaSucc,ColonnaSucc)|V])|E])),
    esplora_successori(G, [(NuoveAzioni, pos(RigaSucc,ColonnaSucc), F, [pos(RigaSucc,ColonnaSucc)|V])|Successori], RigaAttuale, ColonnaAttuale, NuovoDictSuccessori),
    DictSuccessori = [(NuoveAzioni, pos(RigaSucc,ColonnaSucc), F,[pos(RigaSucc,ColonnaSucc)|V])|NuovoDictSuccessori];
    DictSuccessori = Successori.




terzo_elemento((_,_,TerzoElemento,_), TerzoElemento).
secondo_elemento((_,SecondoElemento,_,_), SecondoElemento).
primo_elemento((PrimoElemento,_,_,_),PrimoElemento).

push(Lista, X, [X|Lista]).

pop([X|_], X).
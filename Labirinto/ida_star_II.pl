manhattan(RigaAttuale,ColonnaAttuale, Distanza):-
    finale(pos(RigaFinale,ColonnaFinale)),
    SommaRiga is RigaAttuale-RigaFinale,
    SommaRiga=<0,
    SommaRigaModulo is 0-SommaRiga,
    SommaColonna is ColonnaAttuale-ColonnaFinale,
    SommaColonna=<0,
    SommaColonnaModulo is 0-SommaColonna,
    Distanza is SommaRigaModulo+SommaColonnaModulo.


manhattan(RigaAttuale,ColonnaAttuale,Distanza):-
    finale(pos(RigaFinale,ColonnaFinale)),
    SommaRiga is RigaAttuale-RigaFinale,
    SommaRiga<0,
    SommaRigaModulo is 0-SommaRiga,
    SommaColonna is ColonnaAttuale-ColonnaFinale,
    SommaColonna>0,
    Distanza is SommaRigaModulo+SommaColonna.


manhattan(RigaAttuale,ColonnaAttuale, Distanza):-
    finale(pos(RigaFinale,ColonnaFinale)),
    SommaRiga is RigaAttuale-RigaFinale,
    SommaRiga>0,
    SommaColonna is ColonnaAttuale-ColonnaFinale,
    SommaColonna<0,
    SommaColonnaModulo is 0-SommaColonna,
    Distanza is SommaRiga+SommaColonnaModulo.


manhattan(RigaAttuale,ColonnaAttuale, Distanza):-
    finale(pos(RigaFinale,ColonnaFinale)),
    SommaRiga is RigaAttuale-RigaFinale,
    SommaRiga>0,
    SommaColonna is ColonnaAttuale-ColonnaFinale,
    SommaColonna>0,
    Distanza is SommaRiga+SommaColonna.

initialize_IDA(NuovaListaAzioni,Soglia):-
    Soglia=:=0,
    iniziale(pos(RigaIniziale,ColonnaIniziale)),
    iniziale(Start),
    manhattan(RigaIniziale,ColonnaIniziale,Distanza),
    NuovaSoglia is Distanza,
    \+ida_star(0,[Start],NuovaSoglia,[Start],[],NuovaListaAzioni,NuovaListaVisitati,0,NuovoFound,NuovoPath, NuovoG, [Soglia], NuovaListaF),
    sort(NuovaListaF, SortedF),
    change_soglia(SortedF, NuovaSoglia, Minimo),
    ida_star(NuovoG,[Start], Minimo, [Start],[],NuovaListaAzioni,NuovaListaVisitati,FoundGoal,NuovoPath, NuovoG, [Soglia,Minimo], NuovaListaF).


initialize_IDA(NuovaListaAzioni,Soglia):-
    Soglia=:=0,
    iniziale(pos(RigaIniziale,ColonnaIniziale)),
    iniziale(Start),
    manhattan(RigaIniziale,ColonnaIniziale,Distanza),
    NuovaSoglia is Distanza,
    ida_star(0,[Start],NuovaSoglia,[Start],[],NuovaListaAzioni,NuovaListaVisitati,0,NuovoFound,NuovoPath, NuovoG, [Soglia], NuovaListaF),
    NuovoFound=:=1,
    !.


initialize_IDA(NuovaListaAzioni,Soglia):-
    Soglia=:=0,
    iniziale(pos(RigaIniziale,ColonnaIniziale)),
    iniziale(Start),
    manhattan(RigaIniziale,ColonnaIniziale,Distanza),
    NuovaSoglia is Distanza,
    ida_star(0,[Start],NuovaSoglia,[Start],[],NuovaListaAzioni,NuovaListaVisitati,0,NuovoFound,NuovoPath, NuovoG, [Soglia], NuovaListaF).
    %NuovoFound=:=0,
    %sort(NuovaListaF, SortedF),
    %change_soglia(SortedF, Soglia, Minimo),
    %ida_star(NuovoG,[Start], Minimo, [Start],[],NuovaListaAzioni,NuovaListaVisitati,FoundGoal,NuovoPath, NuovoG, [Soglia,Minimo], NuovaListaF).

initialize_IDA(NuovaListaAzioni,Soglia):-
    ida_star(0,[Start],Soglia,[Start],[],NuovaListaAzioni,NuovaListaVisitati,0,NuovoFound,NuovoPath, NuovoG, [Soglia], NuovaListaF).

%initialize_IDA(NuovaListaAzioni):-
%    iniziale(pos(RigaIniziale,ColonnaIniziale)),
%    iniziale(Start),
%    manhattan(RigaIniziale,ColonnaIniziale,Distanza),
%    Soglia is Distanza,
%    ida_star(0,[Start],Soglia,[],[],NuovaListaAzioni,NuovaListaVisitati,FoundGoal,NuovoPath, NuovoG).
    


pop([X|_], X).

push(Lista, X, [X|Lista]).




delete(Lista, Soglia, ListaNuova):- 
    pop(Lista,X),
    X<Soglia,
    select(X, Lista, ListaNuova),
    delete(ListaNuova, Soglia, ListaNuovissima).



ida_star(G,Path,Soglia,ListaVisitati,ListaAzioni,ListaAzioni,ListaVisitati,FoundGoal,NuovoFound,Path, NuovoG, ListaF, NuovaListaF):-
    pop(Path, NodoAttuale),
    finale(NodoAttuale),
    NuovoFound is 1,
    !.

ida_star(G,Path,Soglia,ListaVisitati,ListaAzioni,NuovissimaListaAzioni,[pos(RigaProssima,ColonnaProssima)|ListaVisitati],FoundGoal,NuovoFound,Path,NuovissimoG, ListaF, [F|NuovaListaF]):-
    pop(Path, NodoAttuale),
    applicabile(Azione,NodoAttuale),
    trasforma(Azione,NodoAttuale,pos(RigaProssima,ColonnaProssima)),
    \+member(pos(RigaProssima,ColonnaProssima),ListaVisitati),
    manhattan(RigaProssima,ColonnaProssima,Distanza),
    NuovoG is G+1,
    F is NuovoG+Distanza,
    push(ListaF, F, NuovaListaF),
    push(ListaVisitati, pos(RigaProssima, ColonnaProssima), NuovaListaVisitati),
    %push(ListaAzioni, Azione, NuovaListaAzioni),
    check_F(F,Soglia,RigaProssima,ColonnaProssima,Path, NuovaListaVisitati, ListaAzioni, NuovissimaListaAzioni, G, NuovoG, FoundGoal,Azione).
    %F=<Soglia,
    %ida_star(NuovoG,[pos(RigaProssima,ColonnaProssima)|Path],Soglia,[pos(RigaProssima,ColonnaProssima)|NuovaListaVisitati],[Azione|ListaAzioni],NuovaListaAzioni,NuovaNuovaListaVisitati,FoundGoal,NuovoPath, NuovissimoG, NuovaListaF, NuovaNuovaListaF).

%ida_star(G,Path,Soglia,ListaVisitati,ListaAzioni,ListaAzioni,ListaVisitati,FoundGoal,NuovoFound,Path, NuovoG, ListaF, NuovaListaF) :-
%    pop(Path, NodoExtra),
%    select(NodoExtra,Path,PathBello),
%    pop(PathBello, NodoAttuale),
%    iniziale(NodoAttuale),
%    length(ListaVisitati, Lunghezza),
%    Lunghezza > 1,
%    FoundGoal=:=0,
%    sort(ListaF, SortedF),
%    change_soglia(SortedF, Soglia, Minimo),
%    initialize_IDA(ListaAzioni,Minimo).
%    ida_star(NuovoG,[Start], Minimo, [Start],[],NuovaListaAzioni,NuovaListaVisitati,FoundGoal,NuovoFound,NuovoPath, NuovoG, [Soglia,Minimo], NuovaListaF).


check_F(F,Soglia,RigaProssima,ColonnaProssima,Path, NuovaListaVisitati, ListaAzioni, NuovaListaAzioni, G, NuovoG, FoundGoal,Azione):-
    F=<Soglia,
    ida_star(NuovoG,[pos(RigaProssima,ColonnaProssima)|Path],Soglia,NuovaListaVisitati,[Azione|ListaAzioni],NuovaListaAzioni,NuovaNuovaListaVisitati,FoundGoal,NuovoFound,NuovoPath, NuovissimoG, NuovaListaF, NuovaNuovaListaF).

check_F(F,Soglia,RigaProssima,ColonnaProssima, Path, NuovaListaVisitati, ListaAzioni, NuovaListaAzioni, G, NuovoG, FoundGoal,Azione) :-
    ida_star(G, Path,Soglia,[pos(RigaProssima,ColonnaProssima)|NuovaListaVisitati],ListaAzioni,NuovaListaAzioni,NuovaNuovaListaVisitati,FoundGoal,NuovoFound,NuovoPath, NuovissimoG, NuovaListaF, NuovaNuovaListaF).

change_soglia(ListaF,Soglia, NuovaSoglia) :-
    pop(X, ListaF),
    X=<Soglia,
    select(X, ListaF, NewSorted),
    change_soglia(NewSorted, NuovaSoglia).

change_soglia(ListaF, Soglia, NuovaSoglia) :-
    pop(X,ListaF),
    NuovaSoglia is X.

%Lista visitati si resetta come path
    



    
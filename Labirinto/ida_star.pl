manhattan(pos(RigaAttuale,ColonnaAttuale), pos(RigaFinale,ColonnaFinale), Distanza):-
    SommaRiga is RigaAttuale-RigaFinale,
    SommaRiga>0,
    SommaColonna is ColonnaAttuale-ColonnaFinale,
    SommaColonna>0,
    Distanza is SommaRiga+SommaColonna.

manhattan(pos(RigaAttuale,ColonnaAttuale), pos(RigaFinale,ColonnaFinale), Distanza):-
    SommaRiga is RigaAttuale-RigaFinale,
    SommaRiga<0,
    SommaRigaModulo is 0-SommaRiga,
    SommaColonna is ColonnaAttuale-ColonnaFinale,
    SommaColonna>0,
    Distanza is SommaRigaModulo+SommaColonna.

manhattan(pos(RigaAttuale,ColonnaAttuale), pos(RigaFinale,ColonnaFinale), Distanza):-
    SommaRiga is RigaAttuale-RigaFinale,
    SommaRiga>0,
    SommaColonna is ColonnaAttuale-ColonnaFinale,
    SommaColonna<0,
    SommaColonnaModulo is 0-SommaColonna,
    Distanza is SommaRiga+SommaColonnaModulo.

manhattan(pos(RigaAttuale,ColonnaAttuale), pos(RigaFinale,ColonnaFinale), Distanza):-
    SommaRiga is RigaAttuale-RigaFinale,
    SommaRiga<0,
    SommaRigaModulo is 0-SommaRiga,
    SommaColonna is ColonnaAttuale-ColonnaFinale,
    SommaColonna<0,
    SommaColonnaModulo is 0-SommaColonna,
    Distanza is SommaRigaModulo+SommaColonnaModulo.

pop([X|_], X).

push(Lista, X, [X|Lista]).

search(NodiVisitati, CostoAttuale, CostoPerGoal, CostoMinimo,_,_):-
    pop(NodiVisitati, NodoAttuale),
    finale(Goal),
    manhattan(NodoAttuale, Goal, Distanza),
    f is CostoAttuale+Distanza,
    f> CostoPerGoal,
    CostoMinimo is f.

search(NodiVisitati, CostoAttuale, _, CostoMinimo,_,_):-
    pop(NodiVisitati, pos(RigaAttuale,ColonnaAttuale)),
    finale(pos(RigaGoal,ColonnaGoal)),
    RigaAttuale =:= RigaGoal,
    ColonnaAttuale =:= ColonnaGoal,
    CostoMinimo is CostoAttuale.
    
search(NodiVisitati, CostoAttuale, CostoPerGoal, CostoMinimo,_,_):-
    pop(NodiVisitati, NodoAttuale),
    finale(Goal),
    manhattan(NodoAttuale, Goal, Distanza),
    f is CostoAttuale+Distanza,
    applicabile(Azione,NodoAttuale),
    trasforma(Azione,NodoAttuale,ProssimoNodo),
    \+member(ProssimoNodo,NodiVisitati),
    push(NodiVisitati, ProssimoNodo, NuoviVisitati),
    NuovoCostoAttuale is CostoAttuale+1,
    search(NuoviVisitati, NuovoCostoAttuale, CostoPerGoal, CostoMinimo, _,_),
    CostoMinimo =:= NuovoCostoAttuale,
    CostoMinimo is NuovoCostoAttuale.

search(NodiVisitati, CostoAttuale, CostoPerGoal, CostoMinimo, Minimo, SuccessoriVisitati):-
    pop(NodiVisitati, NodoAttuale),
    finale(Goal),
    manhattan(NodoAttuale, Goal, Distanza),
    f is CostoAttuale+Distanza,
    num_righe(NR),
    num_colonne(NC),
    Minimo is NR*NC,
    applicabile(Azione,NodoAttuale),
    trasforma(Azione,NodoAttuale,ProssimoNodo),
    \+member(ProssimoNodo,SuccessoriVisitati),
    push(SuccessoriVisitati, ProssimoNodo, NuoviSuccessori),
    \+member(ProssimoNodo,NodiVisitati),
    push(NodiVisitati, ProssimoNodo, NuoviVisitati),
    NuovoCostoAttuale is CostoAttuale+1,
    search(NuoviVisitati, NuovoCostoAttuale, CostoPerGoal, NuovoCostoMinimo, Minimo, NuoviSuccessori),
    NuovoCostoMinimo < Minimo,
    NuovoMinimo is NuovoCostoMinimo,
    select(ProssimoNodo, NuoviVisitati, ListaDiPartenza),
    search(ListaDiPartenza, CostoAttuale, CostoPerGoal, NuovissimoCostoMinimo, NuovoMinimo, NuoviSuccessori),    
    CostoMinimo is NuovissimoCostoMinimo.


start(PercorsoFinale):-
    iniziale(pos(RigaIniziale, ColonnaIniziale)),
    finale(pos(RigaFinale,ColonnaFinale)),
    manhattan(Node, Goal, H),
    push(Percorso, Node, NuovoPercorso),
    Percorso is NuovoPercorso,
    ida_star(Node, Percorso, Bound, Fallimento),
    PercorsoFinale is Percorso.

ida_star(Node, Percorso, Bound, Fallimento):-
    %iniziale(Node),
    %finale(Goal),
    %manhattan(Node, Goal, H),
    %push(Percorso, Node, NuovoPercorso),
    %Percorso is NuovoPercorso,
    search(Percorso, 0, H, CostoMinimo, _, _),
    CostoMinimo =:= 0,
    Fallimento is 0.
    
ida_star(Node, Percorso, Bound, Fallimento):-
    %iniziale(Node),
    %finale(Goal),
    %manhattan(Node, Goal, H),
    %push(Percorso, Node, NuovoPercorso),
    %Percorso is NuovoPercorso,
    search(Percorso, 0, H, CostoMinimo, _, _),
    num_righe(NR),
    num_colonne(NC),
    CostoMinimo =:= NR*NC,
    Fallimento is 1.
    
ida_star(Node, Percorso, Bound, Fallimento):-
    %iniziale(Node),
    %finale(Goal),
    %manhattan(Node, Goal, H),
    %push(Percorso, Node, NuovoPercorso),
    %Percorso is NuovoPercorso,
    search(Percorso, 0, H, CostoMinimo, _, _),
    NuovoBound is CostoMinimo,
    ida_star(Node, Percorso, NuovoBound, Fallimento).


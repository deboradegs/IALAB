prova(Cammino,Limite):-
    iniziale(S0),risolvi(S0,Cammino,[],Limite).

risolvi(S,[],_,_):-finale(S),!.

risolvi(S,[Az|ListaAzioni],Visitati, ProfMax):-
    ProfMax > 0,
    applicabile(Az,S),
    trasforma(Az,S,SNuovo),
    \+member(SNuovo,Visitati),
    NuovaProfMax is ProfMax-1,
    risolvi(SNuovo,ListaAzioni,[S|Visitati],NuovaProfMax).
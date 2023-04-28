risolvi(S,[],_):-finale(S),!.

risolvi(S,[Az|ListaAzioni],Visitati):-
    applicabile(Az,S),
    trasforma(Az,S,SNuovo),
    \+member(SNuovo,Visitati),
    risolvi(SNuovo,ListaAzioni,[S|Visitati]).
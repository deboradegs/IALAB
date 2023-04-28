%applicabile(Azione,Stato)

applicabile(su,pos(Riga,Colonna)):-
    Riga > 1,
    RigaSopra is Riga-1,
    \+occupata(pos(RigaSopra,Colonna)).

applicabile(giu,pos(Riga,Colonna)):-
    num_righe(NR),
    Riga < NR,
    RigaSotto is Riga+1,
    \+occupata(pos(RigaSotto,Colonna)).

applicabile(dx,pos(Riga,Colonna)):-
    num_colonne(NC),
    Colonna < NC,
    ColonnaADx is Colonna+1,
    \+occupata(pos(Riga,ColonnaADx)).

applicabile(sx,pos(Riga,Colonna)):-
    Colonna > 1,
    ColonnaASx is Colonna-1,
    \+occupata(pos(Riga,ColonnaASx)).


%trasforma(AZ, S0, S1) - AZ, S0 è applicabile. 
trasforma(su,pos(Riga,Colonna),pos(RigaSopra,Colonna)):- 
    RigaSopra is Riga-1.

trasforma(giu,pos(Riga,Colonna),pos(RigaSotto,Colonna)):-
    RigaSotto is Riga+1.

trasforma(dx,pos(Riga,Colonna),pos(Riga,ColonnaADx)):-
    ColonnaADx is Colonna+1.

trasforma(sx,pos(Riga,Colonna),pos(Riga,ColonnaASx)):-
    ColonnaASx is Colonna-1.
    

    
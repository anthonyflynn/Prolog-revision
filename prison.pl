%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prison exercise in Prolog                                        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compile the Prison Database:

:- ensure_loaded(prisonDB_lexis).


% cell(N) - N is the cell number of a cell in the prison

cell(N):-
    cells(Cells),
    in_range(1,Cells,N).


% forall(C1, C2) - if C1 is true, then C2 is also true

forall(C1, C2):- \+ (C1, \+ C2).


% (a) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% in_range(+Min, +Max, ?N) means N is within the range Min to Max.

in_range(Min,Max,Min):-
    Min =< Max.

in_range(Min, Max, N):-
    Min < Max,
    NM is Min + 1,
    in_range(NM, Max, N).


% (b) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% empty_cell(?Cell) means that Cell is an empty cell in the prison

empty_cell(Cell):-
    cell(Cell),
    \+ prisoner(_, _, Cell, _, _, _).


% (c) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% all_female(?Cell) means Cell is a non-empty cell containing only
% female prisoners

all_female_cell(Cell):-
    cell(Cell),
    \+ empty_cell(Cell),
    forall(prisoner(_,First,Cell,_,_,_), female_name(First)).


% (d) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% female_prisoners(?N) means N is the number of female prisoners

female_prisoners(N):-
    findall((First-Last), female_prisoner(Last, First), List),
    length(List, N).


% female_prisoner(?Last, ?First) means that the prisoner with surname
% Last and first name First is a female prisoner in the prison

female_prisoner(Last, First):-
    prisoner(Last, First, _, _, _, _),
    female_name(First).


% (e) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cell_occupancy(?Cell, ?N) means N is the number of prisoners in Cell

cell_occupancy(Cell, N):-
    cell(Cell),
    findall((First-Last), prisoner(Last,First,Cell,_,_,_), List),
    length(List, N).


% (f) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% fullest_cell(?Cell) means that Cell contains the largest number
% of prisoners

fullest_cell(Cell):-
    cell_occupancy(Cell,N),
    \+ (cell_occupancy(_,M),
	M > N).


% (g) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% worst_psychopath(?S,?F,?Crime,?T) means the prisoner with surname 
% S, first name F, who committed crime Crime and received a sentence
% T has the longest sentence of the psychopaths in the prison

worst_psychopath(S,F,Crime,T):-
    psychopath_detailed(S,F,Crime,T),
    \+ (psychopath_detailed(_,_,_,U),
	U > T).

% psychopath_detailed(?S,?F,?Crime,?T) means the prisoner with surname 
% S, first name F, who committed crime Crime and received a sentence
% T is a psychopath

psychopath_detailed(S,F,Crime,T):-
    psychopath(S,F),
    prisoner(S,F,_,Crime,T,_).

   
% (h) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% criminals(?Crime, ?N) means N prisoners in the prison have been
% convicted of crime Crime

criminals(Crime, N):-
    setof(Last-First, prisoner_crime(Last,First,Crime), List),
    length(List, N).


% prisoner_crime(?Last, ?First, ?Crime) means the prisoner with surname
% Last, first name First has commited crime Crime

prisoner_crime(Last, First, Crime):-
    prisoner(Last,First,_,Crime,_,_).



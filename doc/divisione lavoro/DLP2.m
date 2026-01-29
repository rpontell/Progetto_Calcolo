In ambito di interpolazione di dati e funzioni, concetto fondamentale è la matrice di Vandermonde V, tale per cui V * c = y. 
Il condizionamento del polinomio interpolante lambda_n dipende esclusivamente dai nodi, mentre per V(i,j) = phi_j(x_i) base di P^n, 
il condizionamento di V dipende sia dai nodi che dalla base phi_j. Per n molto maggiore di 1 (già a partire da 10/12) la matrice di Vandermonde
diventa malcondizionata.
Sperimentalmente, una buona base per mantenere contenuto il condizionamento di V è la base dei polinomi di Chebyshev per cui :
T ( n ) = cos ( n * arccos ( x ) ) , n da 0 a + inf e analizzando T(n), si nota come questi oscillino tra [ -1 ; 1 ]

ANALISI DEL CODICE

function dlp = DLP2(x, d)
% DLP2  Discrete Leja Points (Algoritmo 2: LU pivoting su Vandermonde di Chebyshev)
%   dlp = DLP2(x, d)
%   INPUT:
%     x : vettore (colonna o riga) con i punti della mesh in [-1,1]
%     d : grado del polinomio -> produce d+1 nodi
%   OUTPUT:
%     dlp : vettore riga con i d+1 punti di Leja approssimati
%
%   Costruisce la matrice di tipo Vandermonde con base di Chebyshev:
%     V_{i,j} = cos((j-1)*arccos(x_i))
%   Poi esegue LU con pivoting parziale.
%   In piu', forziamo che il PRIMO nodo sia x(1), come richiesto.

x = x(:);     % rende x un vettore colonna 	
M = numel(x); % ritorna il numero di righe di x vettore colonna
if d >= M     % controllo per il funzionamento della funzione. Per selezionare d+1 nodi, serve M > d 
    error('DLP2: d deve essere < length(x).');
end

xt = min(max(x, -1), 1);  % forza i valori di x tra -1 e 1, altrimenti T(n) è fuori range
theta = acos(xt);         % arccos(xt) funziona sempre in quanto xt in [-1 ; 1]
j = 0:d;                  % j è il vettore dei gradi da 0 a d 
V = cos(theta * j);       % theta * j produce una matrice M x ( d+1 ). Successivamente V(i, j+1) = cos ( j * theta_i ) = T_j ( x_i ), 
                          quindi V è la matrice del tipo [ T_0(x_i) T_1(x_i) … T_d(x_i) ] , i = 1,…,M

[~, ~, p] = lu(V, ‘vector'); % Viene eseguita la fattorizzazione LU con Pivoting parziale PV = LU e restituisce p come vettore di permutazione. 
                              p(k) è l’indice della riga di V selezionata come k-esimo pivot

% Forza x(1) come primo nodo
if p(1) ~= 1
    p = [1; p(p~=1)];
end

idx = p(1:d+1);      % Si prendono i primi d+1 indici selezionati
dlp = x(idx).’;      % Estrae i punti della mesh x corrispondenti agli indici selezionati e li traspone 
                      rendendoli dei vettori riga. Esegue la funzione dlp sui punti estratti
end

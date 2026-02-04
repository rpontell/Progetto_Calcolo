function L = leb_con(z, x)

% LEB_CON  Approssimazione della costante di Lebesgue sui punti x
%   L = leb_con(z, x)
%   INPUT:
%     z : vettore riga dei nodi dell'interpolante (length n = d+1)
%     x : vettore colonna dei punti in [-1,1] dove valutare la funzione di Lebesgue
%   OUTPUT:
%     L : scalare reale, max_{x} lambda_n(x)

z = z(:).';           %z(:) – converte z in vettore colonna .' – lo traspone in vettore riga (per facilitare i calcoli)
x = x(:);             %Trasformazione di x in vettore colonna
n = numel(z);         %Calcolo del numero di nodi, numel() conta quanti elementi ha il vettore  z

%  Calcolo dei pesi baricentrici: Calcola i pesi baricentrici, fondamentali per l'interpolazione. Sono fattori che pesano l'importanza di ogni nodo.
W = ones(1, n);             % inizializza W a 1
for i = 1:n
    diff = z(i) - z;       % differenza tra z(i) e tutti gli altri nodi
    diff(i) = 1;           % evita divisione per zero
    W(i) = 1 / prod(diff); % W(i) = 1 / prodotto delle differenze
end

X = x * ones(1, n); %Crea una matrice dove ogni riga è il vettore  x. Utile per fare operazioni vettoriali.
Z = ones(numel(x), 1) * z; %Crea una matrice dove ogni riga è il vettore  z
%Esempio: Se x ha 3 elementi e  z ha 2 elementi:
%     |‾ x1 x1 ‾|      |‾ z1 z2 ‾| 
% X = |  x2 x2  |; Z = |  z1 z2  |;
%     |_ x3 x3 _|      |_ z1 z2 _| 
%
A = W ./ (X - Z); %Calcolo della matrice A: Formula baricentrica: divide i pesi  W per le differenze  (x - z). Ogni elemento = wj/(xi−zj).

toll = 1e-14; %Tolleranza per confronti. Valore molto piccolo (0.00000000000001) usato per identificare quando un punto coincide con un nodo. 
isNodo = abs(X - Z) < toll; %Identifica i nodi: Crea una matrice logica:  true se la distanza tra  x(i) e  z(j) è quasi zero (stesso punto).

S = sum(A, 2); % Somma ogni riga di  A. S(i) = somma degli elementi della riga i.
lambda = sum(abs(A), 2) ./ abs(S); % Calcolo della funzione di Lebesgue. Misura l'instabilità dell'interpolazione in ogni punto  x. La funzione di Lebesgue: λn(x)=(∑j|wj/(x−zj)|)/(|∑jwj/(x−zj))
% Correzione per i nodi
anyNodo = any(isNodo, 2); % true se la riga contiene almeno un true
lambda(anyNodo) = 1; % Nei punti di interpolazione, la costante di Lebesgue è sempre 1 per definizione.

L = max(lambda); %Restituisce il massimo della funzione di Lebesgue su tutti i punti  x. È la "costante di Lebesgue" finale
end

%{
Questo codice implementa l'interpolazione baricentrica per calcolare la costante di Lebesgue,
un indicatore di qualità della scelta dei nodi di interpolazione.
Valori bassi = interpolazione stabile, Valori alti = instabile
%}
% I punti di Leja sono una sequenza di nodi ottimali per l'interpolazione polinomiale 
% perché minimizzano l'errore di interpolazione cercando di mantenere bassa la costante di Lebesgue.

function dlp = DLP(x, d)
% DLP  Discrete Leja Points (Algoritmo 1: massimizzazione della produttoria)
%   dlp = DLP(x, d)
%   INPUT:
%     x : vettore (colonna o riga) con i punti della mesh in [-1,1]
%     d : grado del polinomio -> produce d+1 nodi
%   OUTPUT:
%     dlp : vettore riga con i d+1 punti di Leja approssimati
%
%   NOTE:
%   - Il primo nodo e' x(1).
%   - Ogni nodo successivo massimizza la produttoria dei moduli delle distanze
%     dai nodi gia' scelti, valutata sui soli punti della mesh x.
%
x = x(:);                % Forza x ad essere un vettore colonna
M = numel(x);            % Conta il numero totale di punti nella mesh
if d >= M
    error('DLP: d deve essere < length(x).'); % Controllo di sicurezza: il grado del polinomio d deve essere minore del numero totale di punti M
end

% Qui il codice assume che l'utente fornisca un x dove il primo elemento è il punto di partenza desiderato.
available = true(M,1);   % Maschera logica: true se il punto NON è ancora stato scelto /spiega meglio
available(1) = false;    % Il primo punto è già preso
prodvals = ones(M,1);    % Vettore accumulatore per la produttoria: memorizza il prodotto delle distanze 
                         % dai nodi già scelti per ogni punto della mesh. Viene inizializzato a 1

dlp = zeros(1, d+1);     % Prealloca con 0 il vettore dei risultati (d+1 nodi) 
dlp(1) = x(1);           % Il primo punto è fissato arbitrariamente al primo della mesh x(1)

for s = 2:d+1 %qua si parte da 2 perchè in matlab i cicli for partono da 1 e non da 0
% L'obiettivo è trovare il prossimo punto xk che massimizza: ∏da j=1 a s-1 di|xk-ξj| dove ξj sono i punti di Leja già trovati
    dist = abs(x - dlp(s-1));  % Calcola distanze in modulo dall'ULTIMO punto scelto a tutti gli x
    dist(~available) = 1;      % Imposta a 1 la distanza per i nodi già usati, evita di moltiplicare per 0
    prodvals = prodvals .* dist; % Aggiorna il prodotto cumulativo
    
    prodvals(~available) = -inf; % Esclude i nodi usati dalla ricerca del massimo
    [~, idx] = max(prodvals);  % Trova l'indice del valore massimo
    dlp(s) = x(idx);           % Salva il nuovo punto di Leja
    available(idx) = false;    % Marca l'indice come usato
endend

%{ 
Esempio Pratico (Traccia del Loop)
#Immaginiamo:
Mesh x=[-1,0,1]
Grado d=2 (quindi cerchiamo 3 punti).

#Stato Iniziale:
dlp = [-1,0,0] (Il primo è x(1) cioè -1).
available = [false, true, true].
prodvals = [1, 1, 1].

#Iterazione s=2 (Cerchiamo il secondo punto):
1) Distanza: Calcoliamo la distanza da dlp(1) cioè (-1) a tutti gli x:
|-1-(-1)|=0
|0-(-1)|=1
|1-(-1)|=2
dist = [0,1,2]. (Ancora grezzo)
2) Mascheramento: L'indice 1 non è disponibile. dist(1) diventa 1.
dist = [1,1,2]. (Corretto)
3) Aggiornamento Prodotto: prodvals = [1,1,1]*[1,1,2]=[1,1,2].
4) Selezione: Oscuriamo i nodi non disponibili con -∞.
temp_prod = [-∞,1,2].
Il massimo è 2 (indice 3, valore x=1).
5) Risultato: dlp(2) = 1; available(3) diventa false.

#Iterazione s=3 (Cerchiamo il terzo punto):
1) Distanza: Calcoliamo la distanza da dlp(2) cioè (1) a tutti gli x:
|-1-(1)|=2
|0-(1)|=1
|1-(1)|=0
dist = [2,1,0]. (Ancora grezzo) 
2) Mascheramento: Indici 1 e 3 non disponibili. Impostiamo a 1.
dist = [1,1,1]. (Corretto) 
Aggiornamento Prodotto: prodvals precedente [1,1,2].
prodvals = [1,1,2]*[1,1,1]=[1,1,2].
Nota: Qui si noti che per il punto centrale (0), la produttoria accumulata è 1×1=1. (Distanza da (-1) è 1 e da (1) è 1).
3) Selezione: Oscuriamo non disponibili.
temp_prod = [-∞,1,-∞].
Il massimo è 1 (indice 2, valore x=0).
4) Risultato: dlp(3) = 0.

#Risultato Finale: [-1,1,0].
%}

% -------------------------------------------------------

%{
Modo Alternativo (Migliore Stabilità)
Il codice attuale usa una produttoria (prodvals). 
Se d è alto (es. 100), il prodotto di molte distanze piccole o grandi può causare underflow o overflow. 
Invece di massimizzare il prodotto, massimizziamo la somma dei logaritmi delle distanze: max∏|x-xj|⟺max∑log(|x-x|j)

% #Esempio di codice (FUNZIONANTE)
% (parte precedente identica) prodvals diventa sum_log_vals
sum_log_vals = zeros(M,1); 

for s = 2:d+1
    dist = abs(x - dlp(s-1));
    dist(dist==0) = eps; % dist==0 -> trova quali elementi sono esattamente 0 e li sostituisce con eps (in Matlab è Epsilon macchina circa 2.22x10-16)
                         % così facendo il logaritmo diventa un numero negativo grande ma evitiamo log(0)                 
    
    log_dist = log(dist);
    
    % Se un punto non è disponibile, aggiungiamo 0 alla somma (log(1)=0)
    % così non alteriamo le somme accumulate degli indici già "usati"
    log_dist(~available) = 0; 

    sum_log_vals = sum_log_vals + log_dist;

    % Per la selezione
    temp_vals = sum_log_vals;
    temp_vals(~available) = -inf; 
    
    [~, idx] = max(temp_vals);
    dlp(s) = x(idx);
    available(idx) = false;
end

%}

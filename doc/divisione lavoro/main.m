% MAIN  Script di sperimentazione per il progetto: nodi di Leja approssimati
% Questo script serve a confrontare le prestazioni di due algoritmi per calcolare i punti di Leja 
% (DLP e DLP2) e a verificare l'accuratezza dell'interpolazione polinomiale ottenuta tramite questi punti rispetto ai punti equispaziati.

clear; clc; close all; %Pulisce la memoria (variabili), la console e chiude tutte le finestre grafiche aperte.

% Mesh per i nodi (scegli 1e4 o 1e5)
Mmesh = 1e5; % Numero di punti nella griglia di ricerca ("discreta") da cui si estrarranno i nodi di Leja. Qui è 100.000                     
xmesh = linspace(-1, 1, Mmesh).'; % Tramite l'operatore di transposizione .' si crea il vettore colonna di Mmesh punti equidistanti tra -1 a 1
deg_max = 50; % Grado massimo del polinomio da testare                     
xeval = linspace(-1, 1, 5000).';  % Una griglia di punti "fitta" usata solo per calcolare l'errore vero della funzione (ground truth) e la costante di Lebesgue.
f = @(x) 1./(x - 1.3);            

if deg_max + 1 > numel(xmesh)
    error('La mesh ha %d punti ma serve almeno deg_max+1 = %d.', numel(xmesh), deg_max+1);
end

% Preallocare spazio per salvare i tempi di calcolo per ogni grado d
times1 = zeros(deg_max,1); % Crea una matrice di zeri di dimensione deg_max righe e 1 colonna
times2 = zeros(deg_max,1);    
Leb1   = zeros(deg_max,1);    
Leb2   = zeros(deg_max,1);    
err_leja = zeros(deg_max,1);
err_equi = zeros(deg_max,1);

for d = 1:deg_max %itera per ogni grado d da 1 a 50
    %Esegue i due algoritmi e misura quanto tempo ci mettono usando le funzioni indicate tic e toc
    tic; z1 = DLP(xmesh, d); times1(d) = toc; 
    tic; z2 = DLP2(xmesh, d); times2(d) = toc;

    % Calcolo Costante di Lebesgue
    Leb1(d) = leb_con(z1, xeval);
    Leb2(d) = leb_con(z2, xeval);

    % Costruzione dei vettori per Interpolazione
    z_leja = z2(:);                       
    z_equi = linspace(-1, 1, d+1).';

    f_leja = f(z_leja);
    f_equi = f(z_equi);

    % Costruzione della Matrice di Vandermonde (Base di Chebyshev): 
    % usa i polinomi di Chebyshev (T0,T1,T2...) definiti come Tj(x)=cos(j*arccos(x)).
    j = 0:d; %vettore da 0 a d /chiedi se giusto
    V_leja = cos(acos(z_leja) * j); %matrice dove la riga i e colonna j contiene Tj(zi)
    V_equi = cos(acos(z_equi) * j);

    % Risoluzione del Sistema Lineare: 
    % Trova i coefficienti c tali che il polinomio passi per i punti della funzione. 
    % L'operatore \ risolve il sistema lineare Vc=y.
    c_leja = V_leja \ f_leja;   
    c_equi = V_equi \ f_equi;

    % Valutazione e Errore
    V_eval = cos(acos(xeval) * j); %Costruisce la matrice di Vandermonde sulla griglia fitta xeval
    p_leja = V_eval * c_leja; %Calcola i valori dei polinomi
    p_equi = V_eval * c_equi;

    % Trova l'errore massimo rispetto alla funzione vera 1/(x-1.3)
    err_leja(d) = max(abs(p_leja - f(xeval)));
    err_equi(d) = max(abs(p_equi - f(xeval)));

    fprintf('d=%2d | t1=%.4fs, t2=%.4fs | Leb1=%.3e Leb2=%.3e | errLeja=%.3e errEqui=%.3e\n', ...
    d, times1(d), times2(d), Leb1(d), Leb2(d), err_leja(d), err_equi(d));

end
%{
Esempio Pratico del Ciclo (Iterazione d=2)
Supponiamo di essere all'iterazione d=2. Vogliamo un polinomio di grado 2 (parabola), quindi ci servono 3 nodi.

1) DLP: Calcola 3 punti di Leja, es. z1 = [-1, 1, 0].
2) Equispaziati: Calcola 3 punti equispaziati, z_equi = [-1, 0, 1].
3) Vandermonde (Chebyshev): j=[0,1,2].
Per ogni nodo z, calcoliamo [cos(0),cos(arccos(z)),cos(2arccos(z))].
Che equivale a [1,z,2z^2−1].
4) Sistema Lineare: Risolviamo per trovare c0,c1,c2.
5) Errore: Valutiamo il polinomio risultante su 5000 punti e vediamo quanto si distacca da 1/(x−1.3).

Risultato atteso: Con l'aumentare di d, l'errore con i nodi equispaziati (err_equi) esploderà (Fenomeno di Runge), 
mentre quello con i nodi di Leja (err_leja) dovrebbe diminuire stabilmente fino alla precisione macchina.
%}

% ---- Grafici ----
%scriptDir = fileparts(mfilename('fullpath'));
%imgDir = fullfile(scriptDir, '..', 'doc', 'img');
%if ~exist(imgDir,'dir'), mkdir(imgDir); end

figure;
plot(1:deg_max, times2, 's-', 'Color', 'g', 'DisplayName', 'DLP2 (LU Chebyshev)'); hold on; 
plot(1:deg_max, times1, 'o-', 'Color', 'm', 'DisplayName', 'DLP (Produttoria)');% grafico dei tempi
xlabel('Grado d'); ylabel('Tempo [s]'); 
grid on; 
title(sprintf('Tempi computazionali (Mmesh=%d)', Mmesh));
legend('Location','northwest');
%exportgraphics(gcf, fullfile(imgDir,'tempi.png'), 'Resolution', 300);

figure;
semilogy(1:deg_max, Leb2, 's-', 'Color', 'g', 'DisplayName', 'Leja (DLP2)'); hold on; % costante di Lebesgue in scala semilogaritmica
semilogy(1:deg_max, Leb1, 'o-', 'Color', 'm', 'DisplayName', 'Leja (DLP)');
grid on;
xlabel('Grado d'); ylabel('Costante di Lebesgue (semilog)');
title('Costante di Lebesgue per i punti di Leja approssimati');
legend('Location','northwest');
%exportgraphics(gcf, fullfile(imgDir,'lebesgue.png'), 'Resolution', 300);

figure;
semilogy(1:deg_max, err_equi, 'd-', 'Color', 'r', 'DisplayName', 'Equispaziati'); hold on; 
semilogy(1:deg_max, err_leja, 's-', 'Color', 'g', 'DisplayName', 'Leja (DLP2)'); % Errori massimi in un grafico semilogaritmico 
% Il testo del progetto dice di usare l'algoritmo per i nodi di Leja più efficiente. 
% DLP è più efficiente in termini di tempo di calcolo ma DLP2 è più stabile anche se più lento.
grid on;
xlabel('Grado d'); ylabel('Errore massimo su [-1,1]');
title('Confronto accuratezza interpolante (base di Chebyshev)');
legend('Location','southwest');
%exportgraphics(gcf, fullfile(imgDir,'errori.png'), 'Resolution', 300);

%fprintf('Figure salvate in %s: tempi.png, lebesgue.png, errori.png\n', imgDir);

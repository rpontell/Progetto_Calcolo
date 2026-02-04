% MAIN  Script di sperimentazione per il progetto: nodi di Leja approssimati

clear; clc; close all; 

% Mesh per i nodi (scegli 1e4 o 1e5)
Mmesh = 1e5;               
xmesh = linspace(-1, 1, Mmesh).'; 
deg_max = 50;                  
xeval = linspace(-1, 1, 5000).'; 
f = @(x) 1./(x - 1.3);            

if deg_max + 1 > numel(xmesh)
    error('La mesh ha %d punti ma serve almeno deg_max+1 = %d.', numel(xmesh), deg_max+1);
end

% Preallocare spazio per salvare i tempi di calcolo per ogni grado d
tempi1 = zeros(deg_max,1);
tempi2 = zeros(deg_max,1);    
Leb1   = zeros(deg_max,1);    
Leb2   = zeros(deg_max,1);  
% LebEqui   = zeros(deg_max,1);
err_leja = zeros(deg_max,1);
err_equi = zeros(deg_max,1);

for d = 1:deg_max 
    %Esegue i due algoritmi e misura quanto tempo ci mettono 
    tic; z1 = DLP(xmesh, d); tempi1(d) = toc; 
    tic; z2 = DLP2(xmesh, d); tempi2(d) = toc;
   % z3 = linspace(-1, 1, d+1);

    % Calcolo Costante di Lebesgue
    Leb1(d) = leb_con(z1, xeval);
    Leb2(d) = leb_con(z2, xeval);
   % LebEqui(d) = leb_con(z3, xeval);

    % Costruzione dei vettori per Interpolazione
    z_leja = z2(:);                       
    z_equi = linspace(-1, 1, d+1).';

    f_leja = f(z_leja);
    f_equi = f(z_equi);

    % Costruzione della Matrice di Vandermonde usando i polinomi di Chebyshev
    j = 0:d; 
    V_leja = cos(acos(z_leja) * j); 
    V_equi = cos(acos(z_equi) * j);

    % Risoluzione del Sistema Lineare Vc=y tramite l''operatore \ 
    c_leja = V_leja \ f_leja;   
    c_equi = V_equi \ f_equi;

    % Valutazione e Errore
    V_eval = cos(acos(xeval) * j); 
    p_leja = V_eval * c_leja; 
    p_equi = V_eval * c_equi;

    % Trova l'errore massimo rispetto alla funzione vera 1/(x-1.3)
    err_leja(d) = max(abs(p_leja - f(xeval)));
    err_equi(d) = max(abs(p_equi - f(xeval)));

    fprintf('d=%2d | t1=%.4fs, t2=%.4fs | Leb1=%.3e Leb2=%.3e | errLeja=%.3e errEqui=%.3e\n', ...
    d, tempi1(d), tempi2(d), Leb1(d), Leb2(d), err_leja(d), err_equi(d));

end

% ---- Grafici ----
%scriptDir = fileparts(mfilename('fullpath'));
%imgDir = fullfile(scriptDir, '..', 'doc', 'img');
%if ~exist(imgDir,'dir'), mkdir(imgDir); end

figure;
h1 = plot(1:deg_max, tempi2, 's-', 'Color', 'g', 'DisplayName', 'DLP2 (LU Chebyshev)'); hold on; 
h2 = plot(1:deg_max, tempi1, 'o-', 'Color', 'm', 'DisplayName', 'DLP (Produttoria)');
xlabel('Grado d'); ylabel('Tempo [s]'); 
grid on; 
title(sprintf('Tempi computazionali (Mmesh=%d)', Mmesh));
legend([h1 h2], 'Location','northwest');
%exportgraphics(gcf, fullfile(imgDir,'tempi.png'), 'Resolution', 300);

figure;
h3 = semilogy(1:deg_max, Leb2, 's-', 'Color', 'g', 'DisplayName', 'Leja (DLP2)'); hold on; 
h4 = semilogy(1:deg_max, Leb1, 'o-', 'Color', 'm', 'DisplayName', 'Leja (DLP)');
grid on;
xlabel('Grado d'); ylabel('Costante di Lebesgue (semilog)');
title('Costante di Lebesgue per i punti di Leja approssimati');
legend([h3 h4], 'Location','northwest');
%exportgraphics(gcf, fullfile(imgDir,'lebesgue.png'), 'Resolution', 300);

%{
figure;
h5 = semilogy(1:deg_max, Leb2, 's-', 'Color', 'g', 'DisplayName', 'Leja (DLP2)'); hold on; 
h6 = semilogy(1:deg_max, Leb1, 'o-', 'Color', 'm', 'DisplayName', 'Leja (DLP)');
h7 = semilogy(1:deg_max, LebEqui, 'd-', 'Color', 'r', 'DisplayName', 'Equispaziati');
grid on;
xlabel('Grado d'); ylabel('Costante di Lebesgue (semilog)');
title('Costante di Lebesgue per i punti di Leja approssimati e nodi Equispaziati');
legend([h5 h6 h7], 'Location','northwest');
exportgraphics(gcf, fullfile(imgDir,'lebesgue_leja-equi.png'), 'Resolution', 300);
%}

figure;
h8 = semilogy(1:deg_max, err_equi, 'd-', 'Color', 'r', 'DisplayName', 'Equispaziati'); hold on; 
h9 = semilogy(1:deg_max, err_leja, 's-', 'Color', 'g', 'DisplayName', 'Leja (DLP2)'); 
grid on;
xlabel('Grado d'); ylabel('Errore massimo su [-1,1]');
title('Confronto accuratezza interpolante (base di Chebyshev)');
legend([h8 h9], 'Location','southwest');
%exportgraphics(gcf, fullfile(imgDir,'errori.png'), 'Resolution', 300);

%fprintf('Figure salvate in %s: tempi.png, lebesgue.png, errori.png\n', imgDir);
function dlp = DLP(x, d)

x = x(:);                
M = numel(x);       
    
if d >= M
    error('DLP: d deve essere < length(x).'); 
end

% Inializzazione vettori e preallocazione
disponibile = true(M,1);   
disponibile(1) = false;    
prodvalori = ones(M,1);   
                        
dlp = zeros(1, d+1);     
dlp(1) = x(1);          

for s = 2:d+1 
    % Ad ogni iterazione, seleziona il punto xk dalla mesh che massimizza la produttoria
    % delle distanze assolute dai nodi di Leja già scelti (ξj), 
    % ottimizzando per l'interpolazione polinomiale.
    dist = abs(x - dlp(s-1));  
    dist(~disponibile) = 1;      
    prodvalori = prodvalori .* dist; 
    
    prodvalori(~disponibile) = -inf; 
    [~, idx] = max(prodvalori);  
    dlp(s) = x(idx);          
    disponibile(idx) = false;    
endend

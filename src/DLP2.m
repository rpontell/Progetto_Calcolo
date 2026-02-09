function dlp = DLP2(x, d)

x = x(:);     
M = numel(x); 

if d >= M     
    error('DLP2: d deve essere < length(x).');
end

% Costruzione matrice di Vandermonde 
xt = min(max(x, -1), 1);  
theta = acos(xt);        
j = 0:d;          
% Inializzazione matrice         
V = cos(theta * j);      

% Fattorizzazione LU con Pivoting parziale PV = LU e restituisce p come vettore di permutazione. 
[~, ~, p] = lu(V, 'vector'); 

% Forza x(1) come primo nodo
if p(1) ~= 1
    p = [1; p(p~=1)];
end

% Seleziona i primi d+1 indici ed estrae i punti della mesh x trasposti corrispondenti
idx = p(1:d+1);      
dlp = x(idx).';      

end

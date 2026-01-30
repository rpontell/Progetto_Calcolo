function L = leb_con(z, x)

% Inizializzazione vettori e parametri   
z = z(:).';           
x = x(:);             
n = numel(z);

% Pesi baricentrici w_i = 1 / prod i!=j (x_i - x_j)
W = ones(1, n);
for i = 1:n
    diffs = z(i) - z;
    diffs(i) = 1;
    W(i) = 1 / prod(diffs);
end

% Creazione e calcolo matrici
X = x * ones(1, n);
Z = ones(numel(x), 1) * z;
A = W ./ (X - Z);

% Identificazione nodi
toll = 1e-14;
isNodo = abs(X - Z) < toll;

% Calcolo della funzione di Lebesgue
S = sum(A, 2);
lambda = sum(abs(A), 2) ./ abs(S);

anyNodo = any(isNodo, 2);
lambda(anyNodo) = 1;

L = max(lambda);

end

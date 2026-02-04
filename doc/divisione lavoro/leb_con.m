function L = leb_con(z, x)
% LEB_CON  Approssimazione della costante di Lebesgue sui punti x
%   L = leb_con(z, x)
%   INPUT:
%     z : vettore riga dei nodi dell'interpolante (length n = d+1)
%     x : vettore colonna dei punti in [-1,1] dove valutare la funzione di Lebesgue
%   OUTPUT:
%     L : scalare reale, max_{x} lambda_n(x)

z = z(:).';           
x = x(:);             
n = numel(z);

% Pesi baricentrici
W = ones(1, n);
for i = 1:n
    diff = z(i) - z;
    diff(i) = 1;
    W(i) = 1 / prod(diff);
end

X = x * ones(1, n);
Z = ones(numel(x), 1) * z;
A = W ./ (X - Z);

toll = 1e-14;
isNodo = abs(X - Z) < toll;

S = sum(A, 2);
lambda = sum(abs(A), 2) ./ abs(S);

anyNodo = any(isNodo, 2);
lambda(anyNodo) = 1;

L = max(lambda);
end
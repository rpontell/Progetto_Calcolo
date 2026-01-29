function L = leb_con(z, x)

z = z(:).';           
x = x(:);             
n = numel(z);

% Pesi baricentrici
W = ones(1, n);
for i = 1:n
    diffs = z(i) - z;
    diffs(i) = 1;
    W(i) = 1 / prod(diffs);
end

X = x * ones(1, n);
Z = ones(numel(x), 1) * z;
A = W ./ (X - Z);

toll = 1e-14;
is_node = abs(X - Z) < toll;

S = sum(A, 2);
lambda = sum(abs(A), 2) ./ abs(S);

any_node = any(is_node, 2);
lambda(any_node) = 1;

L = max(lambda);

end

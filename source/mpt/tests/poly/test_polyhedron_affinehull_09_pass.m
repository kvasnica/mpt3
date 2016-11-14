function test_polyhedron_affinehull_09_pass
%
% array of 3 polyhedra
%


P(1) = Polyhedron(randn(14,5),2*rand(14,1));
P(2) = Polyhedron('lb',-20*ones(5,1),'He',randn(4,6));

% implicit equality in higher dim
t = [randn(4,12) zeros(4,1)];
P(3) = Polyhedron('H', [randn(5,12) ones(5,1);t;-t]);

% arrays must be rejected
[~, msg] = run_in_caller('a = P.affineHull();');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

% non-uniform output by default
[~, msg] = run_in_caller('a = P.forEach(@(e) e.affineHull());');
asserterrmsg(msg, 'Non-scalar in Uniform output, at index 1, output 1.');

% correct syntax
a = P.forEach(@(e) e.affineHull(), 'UniformOutput', false);

if ~isempty(a{1})
    error('First affine hull is empty.')
end
if isempty(a{2})
    error('Second affine hull must not be empty.')
end
if norm(a{2}-P(2).He,Inf)>1e-4
    error('Affine hull should remain the same as He.');
end
if isempty(a{3})
    error('Second affine hull must not be empty.')
end

Q = Polyhedron('He',a{3});
if ~Q.contains(P(3))
    error('Q must contain P(3).');
end


end

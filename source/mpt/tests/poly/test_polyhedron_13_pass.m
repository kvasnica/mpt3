function test_polyhedron_13_pass
%
% allow inf terms in "b" field
%

% [1 0]*x<=Inf should be converted to [0 0]*x<=1 by the constructor
A = [1 0; 1 0];
b = [1; Inf];
A_expected = [1 0; 0 0];
b_expected = [1; 1];

P=Polyhedron(A, b);
assert(isequal(P.A, A_expected));
assert(isequal(P.b, b_expected));

P=Polyhedron('A', [1 0; 1 0], 'b', [1; Inf]);
assert(isequal(P.A, A_expected));
assert(isequal(P.b, b_expected));

end

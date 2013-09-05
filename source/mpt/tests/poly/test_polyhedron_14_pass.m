function test_polyhedron_14_pass
%
% allow inf terms in "lb" field
%

% here we have:
%   x >= 1
%   x >= -Inf
% the second inequality should be converted to 0*x <= 1 because it's
% redundant
P=Polyhedron('lb', [1; -Inf]);
H_expected = [-1 0 -1; 0 0 1];
assert(isequal(P.H, H_expected));

end

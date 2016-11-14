function test_polyhedron_15_pass
%
% allow inf terms in "ub" field
%

% this set is R^n
P=Polyhedron('ub', Inf);

assert(~P.isBounded);
assert(~P.isEmptySet);
assert(P.isFullDim);
assert(P.isFullSpace);

end

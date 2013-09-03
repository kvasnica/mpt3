function test_polyhedron_44_pass
% R^n must be supported (issue #89)

dim = 2;

Rn = Polyhedron(zeros(1, dim), 1);
assert(~Rn.isEmptySet);
assert(Rn.isFullDim);
assert(Rn.Dim==dim);
% assert(isempty(Rn.V)); % R^n has no vertices!

Rn = Polyhedron(ones(1, dim), Inf);
assert(~Rn.isEmptySet);
assert(Rn.isFullDim);
assert(Rn.Dim==dim);
% assert(isempty(Rn.V)); % R^n has no vertices!

Rn = Polyhedron(zeros(1, dim), Inf);
assert(~Rn.isEmptySet);
assert(Rn.isFullDim);
assert(Rn.Dim==dim);
% assert(isempty(Rn.V)); % R^n has no vertices!

% now let's compute the minimal representation
Rn = Polyhedron(zeros(1, dim), 1).minHRep();
assert(~Rn.isEmptySet);
assert(Rn.isFullDim);
assert(Rn.Dim==dim);
% assert(isempty(Rn.V)); % R^n has no vertices!

Rn = Polyhedron(ones(1, dim), Inf).minHRep();
assert(~Rn.isEmptySet);
assert(Rn.isFullDim);
assert(Rn.Dim==dim);
% assert(isempty(Rn.V)); % R^n has no vertices!

Rn = Polyhedron(zeros(1, dim), Inf).minHRep();
assert(~Rn.isEmptySet);
assert(Rn.isFullDim);
assert(Rn.Dim==dim);
% assert(isempty(Rn.V)); % R^n has no vertices!

end

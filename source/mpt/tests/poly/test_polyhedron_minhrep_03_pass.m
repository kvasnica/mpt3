function test_polyhedron_minhrep_03_pass
% wrong answer on a simple hyperbox

% must have 2*dim irredundant half-spaces 
%
% weird error in Polyhedron/computeHRep() for large dimensions: convhulln()
% returns nonsense
P = Polyhedron.unitBox(4);
assert(size(P.H, 1)==P.Dim*2);

Q = Polyhedron(P.V).minHRep();
assert(size(Q.H, 1)==P.Dim*2);

assert(P==Q);


end
function test_polyhedron_interiorPoint_02_fail
%
% too many facets
%

P = Polyhedron('H',[randn(17,5) 8*rand(17,1)])+5*rand(5,1);

[~, sol] = P.minHRep();

nf = nnz(~sol.I);

% this is ok
r1 = P.interiorPoint(1:nf);

% this must fail
r2 = P.interiorPoint(1:nf+1);

end

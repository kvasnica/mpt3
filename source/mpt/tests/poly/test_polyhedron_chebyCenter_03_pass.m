function test_polyhedron_chebyCenter_03_pass
%
% random polyhedron
%
global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

P = Polyhedron('H',randn(24,18),'He',randn(2,18));
while P.isEmptySet
    P = Polyhedron('H',randn(24,18),'He',randn(2,18));
end

r=P.chebyCenter;

% test if inequalities and equalities hold
t1 = norm(P.Ae*r.x-P.be,1)<1e-4;
t2 = all(P.A*r.x<P.b+MPTOPTIONS.abs_tol);

if ~t1 || ~t2
    error('Wrong computation in chebyball.');
end
end
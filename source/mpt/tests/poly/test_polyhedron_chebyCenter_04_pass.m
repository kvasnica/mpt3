function test_polyhedron_chebyCenter_04_pass
%
% large polyhedron
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

P = Polyhedron(randn(234,54),100*rand(234,1));

% whole polyhedron
xc = P.chebyCenter;

% bound on radius
xn = P.chebyCenter([],1);

if xn.r>1+MPTOPTIONS.abs_tol
    error('Radius cannot be greater than 1');
end
end

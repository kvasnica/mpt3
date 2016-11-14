function test_polyhedron_separate_11_pass
%
% point vs point
%

P = Polyhedron('Ae',[0.1 -0.3;0.5 -1],'be',[1;-2]);

x = [-28; -14];
h = P.separate(x);

T = Polyhedron('He',h);

% a degenerate QP problem that has to be solved here (CPLEXINT & CPLEX-IBM gives wrong
% result using dual-simplex method)
d1 = T.distance(P);

% ok
d2 = T.distance(x);


if norm(d1.dist-d2.dist,Inf)>1e-4
    error('Distance must be the same.');
end

end

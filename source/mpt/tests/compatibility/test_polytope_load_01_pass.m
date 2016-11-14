function test_polytope_load_01_pass
% tests loading of polytopes

% single polytope
load singlepolytope
assert(isa(Q, 'polytope'));
Hgood = [-1 0 1;-0.483902762398236 -0.875121772408478 0.931022667377106;0 -1 1;0 1 1;0.483902762398236 0.875121772408478 0.931022667377106;1 0 1];
assert(norm(sortrows(double(Q))-Hgood)<1e-8);

% polytope array
load polytopearray
assert(isa(P, 'polytope'));
assert(length(P)==3);
P.plot();

end

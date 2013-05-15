function test_polyhedron_contains_16_pass
%
% empty polyhedron
%

P = ExamplePoly.randHrep;

% infeasible
R = Polyhedron('A',randn(48,2),'b',rand(48,1)); 

if ~P.contains(R)
    error('R is inside P.');
end

if R.contains(P)
    error('R is not inside P.');
end


end
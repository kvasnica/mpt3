function test_polyhedron_mtimes_06_pass
%
% scalar - H-polyhedron
%

P = ExamplePoly.randHrep;

R = 2*P;

if ~R.contains(P)
    error('R must contain P.');
end
P.minHRep();
if norm(2*P.b-R.b,Inf)>1e-4
    error('Wrong scaling.');
end

end

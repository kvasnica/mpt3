function test_polyhedron_mtimes_08_pass
%
% scalar - V-polyhedron
%

P = Polyhedron('R',randn(3,5));

R = 0.9*P;

if ~P.contains(R)
    error('P must contain R.');
end

% must work also the opposite way
Q = ExamplePoly.randVrep('d',8,'nr',1);
while ~Q.contains(zeros(8,1))
    Q = ExamplePoly.randVrep('d',8,'nr',1);
end

S = Q*0.9;
if ~Q.contains(S)
    error('Q must contain S.');
end


end

function test_polyhedron_contains_01_pass
%
% H-H 
%

P = Polyhedron('lb',[-2;-3],'ub',[4;5]);
S = Polyhedron('A',[1 -0.5; -90.1 0.1; 0.1 -0.5; 2 -3],'b',[1;-2;0.2;0]);


if P.contains(S) || S.contains(P)
    error('Polyhedra are not contained inside one another.');
end

R = 0.1*P+[0.5;1];

% R is contained in S
if ~S.contains(R)
    error('R is contained in S.');
end
    


end
function test_polyhedron_contains_02_pass
%
% V-H 
%

P = Polyhedron('V',[-1 2.2;-3.4 -1; -2.9 2.9]);
% unbounded
S = Polyhedron('H',[0.7 -8 -.4; 0.1 -1 0.5; -9 0.1 -2.5; -0.5 0.01 2]);


if P.contains(S) || S.contains(P)
    error('Polyhedra are not contained inside one another.');
end

% R is contained in S
R = P + [10;10];


if ~S.contains(R)
    error('R is contained in S.');
end
    


end
function test_polyhedron_contains_23_pass
%
% test from merging of polyhedra
%

% box
P = Polyhedron('lb',[-1;-1],'ub',[1;1]);
% line inside the box
S = Polyhedron('lb',[-1;-1],'ub',[1;1],'Ae',randn(1,2),'be',0);

if ~P.contains(S)
    error('S lies inside P.');
end
if S.contains(P)
    error('S does not contain P.');
end

end
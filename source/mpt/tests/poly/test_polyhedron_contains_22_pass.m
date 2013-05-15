function test_polyhedron_contains_22_pass
%
% test from merging of polyhedra
%

P = Polyhedron('lb',[-1;-1],'ub',[1;1]);
S = Polyhedron('V',[1 -1;1 1],'R',[1 0]);

if P.contains(S) || S.contains(P)
    error('Regions are distinct.');
end

end
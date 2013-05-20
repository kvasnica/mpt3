function test_polyhedron_extreme_05_pass
%
% affine sets
%


P(1) = Polyhedron('lb',[-3;-3;-3],'ub',[3;3;3],'He',[1 -2 0.5 1]);
P(2) = Polyhedron('He',[1 -2 0.5 1]);

P.computeVRep();

% all vertices must lie inside both sets
if ~all(all(P.contains(P(1).V'))) || ~all(all(P.contains(P(2).V')))
    error('All vertices must be contained inside same.');
end

end

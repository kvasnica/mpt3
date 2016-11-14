function test_polyunion_add_01_pass
%
% add to convex union
%

P=Polyhedron('lb',[0;0],'ub',[1;1]);

% is convex automatically, but is the union is not marked as convex
PU = PolyUnion(P);

Q=Polyhedron('lb',[1;0],'ub',[2;1]);

% if Q is added, the convexity is not checked
PU.add(Q);
if ~isempty(PU.Internal.Convex)
    error('Convexity should not be checked because it has not been invoked.');
end


end
function test_polyunion_isconnected_01_pass
%
% simple 1D polyhedra
%

P(1) = Polyhedron('lb',-1,'ub',2);
P(2) = Polyhedron('lb',0);

PU = PolyUnion(P);

if ~PU.isConnected
    error('Must be connected.');
end


end

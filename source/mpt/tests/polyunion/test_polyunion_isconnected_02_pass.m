function test_polyunion_isconnected_02_pass
%
% simple 2D polyhedra
%

P(1)=Polyhedron('lb',[0;0],'ub',[1;1]);
P(2)=Polyhedron('lb',[1;0],'ub',[2;1]);

PU = PolyUnion(P);

if ~PU.isConnected
    error('Must be connected.');
end


end

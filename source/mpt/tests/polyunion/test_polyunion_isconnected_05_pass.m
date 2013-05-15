function test_polyunion_isconnected_05_pass
%
% 3D - not connected sets
%

% two connected boxes
P(1) = Polyhedron('lb',[-1;-1;-1],'ub',[1;1;1]);
P(2) = Polyhedron('lb',[0;0;0],'ub',[2;2;2]);

% one low-dim box not connected
P(3) = Polyhedron('lb',[5;0;0],'ub',[6;0;0]);


PU = PolyUnion(P);

if PU.isConnected
    error('Must not be connected.');
end
if isempty(PU.Internal.Connected)
    error('The Internal field must not be empty.');
end

end

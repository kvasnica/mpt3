function test_polyunion_isconnected_06_pass
%
% 1D, 2D arrays of PolyUnion- not connected sets
%

% two connected boxes
P(1) = Polyhedron('lb',-1,'ub',1);
P(2) = Polyhedron('lb',1,'ub',3);
% the third one is not connected
P(3) = Polyhedron('lb',4);

PU(1) = PolyUnion(P);

% connected
Q(1) = ExamplePoly.randHrep;
Q(2) = ExamplePoly.randHrep;
while ~any(Q.isBounded)
    Q(1) = ExamplePoly.randHrep;
    Q(2) = ExamplePoly.randHrep;
end

% not connected
Q(3) = Q(1) + [20;30];

PU(2) = PolyUnion(Q);

if any(PU.isConnected)
    error('Must not be connected.');
end

end

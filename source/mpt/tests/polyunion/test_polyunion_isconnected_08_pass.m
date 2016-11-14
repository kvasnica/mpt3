function test_polyunion_isconnected_08_pass
%
% the polyunion is non-convex, but connected
%

 R(1) = Polyhedron('lb', [-2;-2], 'ub', [0; 0]);
 R(2) = Polyhedron('A', [-1 0.5; 0.4 -2.5; -7.5 0.2], 'b', [0.4; -0.3; 1.5]);
 R(3) = Polyhedron('A', [2.5 1.6; 0.3 -1.2; -0.8 -0.1; 0.7 -1.2; -2.3 -1.4; 0.3 0.3], 'b', [2.3; 4.2; 1.9; 0.5; 1.5; 0.8], 'Ae', [0.1 -3.2], 'be', 0.5 );
 R(4) = Polyhedron('V', [0.4 -0.4; -0.1 0.8; 0.1 -1.3]);
 U = PolyUnion(R);
 U.isConvex;
 U.isOverlapping;
 
 
 if ~U.isConnected
     error('This union is connected.');
 end
 
end
 
 
 
 
function test_polyhedron_isadjacent_08_pass
%
% two adjacent pyramids in 3D
%

V1 = [-1 0 0;
      0 1 0;
      0 0 1;
      0 -1 0;
      0 0 -1];

V2 = [1 0 0;
      0 1 0;
      0 0 1;
      0 -1 0;
      0 0 -1];
  
P = Polyhedron(V1);
Q = Polyhedron(V2);

if ~P.isAdjacent(Q)
    error('The pyramids are adjacent.');
end


end
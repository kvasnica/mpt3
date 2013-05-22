function test_polyunion_locatePoint_03_fail
%
% complex, but no adjacency list
% 

P = ExamplePoly.randVrep('d',4);
T = P.triangulate;
U = PolyUnion('Set',T);

U.locatePoint(randn(1,4));


end
function test_polyunion_locatePoint_04_fail
%
% Inf in the point
% 

P = ExamplePoly.randVrep('d',2);
T = P.triangulate;
U = PolyUnion('Set',T);

U.locatePoint([1,Inf]);


end
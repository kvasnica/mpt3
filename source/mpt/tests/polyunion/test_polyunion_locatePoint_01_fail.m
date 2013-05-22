function test_polyunion_locatePoint_01_fail
%
% polyunion without adjacency list
% 

P = ExamplePoly.randVrep('d',5);
T=P.triangulate;

U = PolyUnion('Set',T,'Convex',true,'Overlaps',false,'Bounded',true,'Connected',true);

U.locatePoint(randn(5,1));


end
function test_polyunion_locatePoint_06_pass
%
% polyunion without adjacency list
% 

P = ExamplePoly.randVrep('d',5);
T=P.triangulate;

U = PolyUnion('Set',T,'Convex',true,'Overlaps',false,'Bounded',true,'Connected',true);

[worked, msg] = run_in_caller('U.locatePoint(randn(5,1)); ');
assert(~worked);
asserterrmsg(msg,'The union does not have an adjacency list. Please, use the polyunion output from PLCP solver that contains the adjacency list.');


end
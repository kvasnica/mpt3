function test_polyunion_locatePoint_08_pass
%
% complex, but no adjacency list
% 

P = ExamplePoly.randVrep('d',4);
T = P.triangulate;
U = PolyUnion('Set',T);

[worked, msg] = run_in_caller('U.locatePoint(randn(1,4)); ');
assert(~worked);
asserterrmsg(msg,'The union does not have an adjacency list. Please, use the polyunion output from PLCP solver that contains the adjacency list.');


end
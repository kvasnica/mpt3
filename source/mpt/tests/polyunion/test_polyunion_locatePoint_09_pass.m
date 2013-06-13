function test_polyunion_locatePoint_09_pass
%
% Inf in the point
% 

P = ExamplePoly.randVrep('d',2);
T = P.triangulate;
U = PolyUnion('Set',T);

[worked, msg] = run_in_caller('U.locatePoint([1,Inf]); ');
assert(~worked);
asserterrmsg(msg,'Input argument must be a real vector.');


end
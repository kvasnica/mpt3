function test_polyunion_09_pass
%
% Yset
%

x =sdpvar(2,1);
F = set(x<=0);
Y = YSet(x,F);

[worked, msg] = run_in_caller('U = PolyUnion(Y); ');
assert(~worked);
asserterrmsg(msg,'Argument ''Set'' failed validation @(x)isa(x,''Polyhedron'').');


end
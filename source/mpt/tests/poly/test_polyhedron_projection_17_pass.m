function test_polyhedron_projection_17_pass
%
% empty polyhedron
%

P = Polyhedron;

[worked, msg] = run_in_caller('R=P.projection([1:2]); ');
assert(~worked);
asserterrmsg(msg,'Cannot compute projection on higher dimension');


end
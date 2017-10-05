function test_polyhedron_getfacet_11_pass
%
% arrays should be rejected

P1 = Polyhedron('lb', -1, 'ub', 1).minHRep();
P2 = Polyhedron('lb', -1, 'ub', 1).minHRep();
P = [P1 P2];
[worked, msg] = run_in_caller('Q = P.getFacet(1)');
assert(~worked);
assert(~isempty(strfind(msg, 'This function does not support arrays of polyhedra.')));

end

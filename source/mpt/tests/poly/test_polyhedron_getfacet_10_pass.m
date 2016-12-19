function test_polyhedron_getfacet_10_pass
%
% input in non-minimal H-representation must be rejected

P = Polyhedron('H',randn(1,4));
[worked, msg] = run_in_caller('Q = P.getFacet(1)');
assert(~worked);
assert(~isempty(strfind(msg, 'Polyhedron must be in its minimal representation.')));

P = Polyhedron('V',randn(14,4));
[worked, msg] = run_in_caller('Q = P.getFacet(1)');
assert(~worked);
assert(~isempty(strfind(msg, 'Polyhedron must be in its minimal representation.')));

end

function test_polyhedron_getfacet_08_pass
%
% Polyhedron/getFacet only accepts up to two arguments (including the
% polyhedron itself)

P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]).minHRep();
[worked, msg] = run_in_caller('Q = P.getFacet(1, 2)');
assert(~worked);
assert(~isempty(strfind(msg, 'Too many input arguments.')));

end

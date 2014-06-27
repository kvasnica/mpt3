function test_polyhedron_projection_24_pass
% keep Polyhedron/projection() silent (issue #115)

P = Polyhedron.unitBox(4);
Q = Polyhedron('H', P.H);

T = evalc('Q.projection(1:2, ''ifourier'');');
assert(isempty(T));

T = evalc('Q.projection(1:2, ''mplp'');');
assert(isempty(T));

end

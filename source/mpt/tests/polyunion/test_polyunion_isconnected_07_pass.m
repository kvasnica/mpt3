function test_polyunion_isconnected_07_pass
% polyunion with single region is connected

P = Polyhedron('lb', -1, 'ub', 1);
U = PolyUnion(P);
assert(U.isConnected);

end

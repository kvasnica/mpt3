function test_polyunion_isoverlapping_07_pass
% polyunion with single region

P = Polyhedron('lb', -1, 'ub', 1);
U = PolyUnion(P);
assert(~U.isOverlapping);

end

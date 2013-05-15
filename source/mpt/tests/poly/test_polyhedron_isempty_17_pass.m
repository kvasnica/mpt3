function test_polyhedron_isempty_17_pass
%
% only rays
%


P = Polyhedron('R',[0 0 1;0.1 0.2 0.3]);

if P.isEmptySet
    error('P is not empty, it is unbounded.');
end

end
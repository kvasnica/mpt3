function test_polyhedron_volume_02_pass
%
% infeasible polyhedron
% 

P = Polyhedron('H',randn(81,4));

while ~P.isEmptySet
    P = Polyhedron('H',randn(81,4));
end

v = P.volume;

if v>1e-4
    error('Must be 0 here.');
end

end

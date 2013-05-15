function test_polyhedron_volume_01_pass
%
% empty polyhedron = 0 volume
% 


P = Polyhedron;

v = P.volume;

if v>1e-4
    error('Must be 0 here.');
end

end

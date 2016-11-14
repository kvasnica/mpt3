function test_polyunion_add_10_pass
%
% empty polyunion, add empty object
%

PU = PolyUnion;
PU.add(Polyhedron);

if PU.Num~=0
    error('Must be empty');
end

end
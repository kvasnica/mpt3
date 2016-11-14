function test_polyhedron_hasVRep_01_pass
%
% empty polyhedron
%

P = Polyhedron;

if P.hasVRep
    error('This must be empty polyhedron.');
end
    

end
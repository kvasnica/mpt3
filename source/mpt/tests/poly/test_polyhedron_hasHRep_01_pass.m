function test_polyhedron_hasHRep_01_pass
%
% empty polyhedron
%

P = Polyhedron;

if P.hasHRep
    error('This must be empty polyhedron.');
end
    

end
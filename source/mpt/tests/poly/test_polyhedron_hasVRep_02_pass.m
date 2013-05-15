function test_polyhedron_hasVRep_02_pass
%
% low-dim
%

P = ExamplePoly.randHrep('ne',1);
P.computeVRep();

if ~P.hasVRep
    error('This must be low-dim polyhedron.');
end
    

end

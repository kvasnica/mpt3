function test_polyhedron_hasHRep_02_pass
%
% low-dim
%

P = ExamplePoly.randHrep('ne',1);

if ~P.hasHRep
    error('This must be low-dim polyhedron.');
end
    

end
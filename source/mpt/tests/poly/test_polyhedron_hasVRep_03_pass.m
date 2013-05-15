function test_polyhedron_hasVRep_03_pass
%
% affine set
%

P = Polyhedron('He',randn(4,5));

if P.hasVRep
    error('This must be affine set.');
end
    
P.computeVRep();
if ~P.hasVRep
    error('This must be affine set.');
end


end

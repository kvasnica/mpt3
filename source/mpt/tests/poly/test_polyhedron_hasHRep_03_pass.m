function test_polyhedron_hasHRep_03_pass
%
% affine set
%

P = Polyhedron('He',randn(4,5));

if ~P.hasHRep
    error('This must be affine set.');
end
    

end
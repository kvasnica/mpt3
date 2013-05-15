function test_polyhedron_hasVRep_04_pass
%
% V-rep
%

P = Polyhedron(randn(4,5));

if ~P.hasVRep
    error('This must be in V-rep.');
end
    

end
function test_polyhedron_hasHRep_04_pass
%
% V-rep
%

P = Polyhedron(randn(4,5));

if P.hasHRep
    error('This must be in V-rep.');
end
    

end
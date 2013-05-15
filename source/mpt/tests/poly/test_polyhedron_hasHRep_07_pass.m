function test_polyhedron_hasHRep_07_pass
%
% cone
%

P = Polyhedron('V',[0 0 0],'R',randn(1,3));

if P.hasHRep
    error('This polyhedron does not have H-rep.');
end
    

end
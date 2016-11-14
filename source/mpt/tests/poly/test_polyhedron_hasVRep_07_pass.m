function test_polyhedron_hasVRep_07_pass
%
% cone
%

P = Polyhedron('lb',[0 0 0],'R',[randn(1,2) 0]);
P.minHRep();
R = Polyhedron('H',P.H,'He',P.He);

if R.hasVRep
    error('This must have H-rep because of lower bound.');
end
    

end

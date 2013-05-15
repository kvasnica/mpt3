function test_polyhedron_hasHRep_06_pass
%
% array
%

P(1) = Polyhedron('R',[0 0 1],'V',rand(4,3));
P(2) = Polyhedron('R',randn(5,6),'V',rand(9,6));

if any(P.forEach(@(x) x.hasHRep))
    error('This is an array.');
end
    

end

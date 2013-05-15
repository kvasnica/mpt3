function test_polyhedron_hasVRep_06_pass
%
% array
%

P(1) = Polyhedron('He',[0 0 1],'H',rand(4,3));
P(2) = Polyhedron('He',randn(5,6),'H',rand(9,6));

if any(P.forEach(@(x) x.hasVRep))
    error('This is an array.');
end
    

end

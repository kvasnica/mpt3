function test_polyhedron_isempty_15_pass
%
% isempty test on positive orthant
% 
% 

P = Polyhedron('lb',[0;0]);
P.isEmptySet;
P.minHRep();
P.minVRep();
if isEmptySet(P)
    error('Given polyhedron object is not empty!');
end

function test_polyhedron_extreme_04_pass
%
% only rays
%


P = Polyhedron('R',[0 0 1;0.1 0.2 0.3]);

P.computeVRep();

R=Polyhedron('H',[ -1 0  0 0; 3 0 -1 0],'He',[2 -1 0 0]);

% R and P must be the same
if R~=P
    error('R and P must be the same.');
end

end

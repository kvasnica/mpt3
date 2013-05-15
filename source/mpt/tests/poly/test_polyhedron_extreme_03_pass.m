function test_polyhedron_extreme_03_pass
%
% V-H representation that does not hold
%

P = Polyhedron('V',[1 1;-1 -1;1 -1],'H',[1 -1 0.5; 0.5 -5 2; 4 -0.5 1; 0.8 -9.1 3.5]);

P.computeVRep();

R=Polyhedron('R',[1  8; -11.375  -1],'V',[1 -1]);

% R and P must be the same
if R~=P
    error('R and P must be the same.');
end

end

function test_polyhedron_contains_07_pass
%
% 2V-H in 2D 
%

P(1) = Polyhedron([9 -4;7.8 -5.5; 6.9 -3.5; -7.9 4.5; -6.7 4.4]);
P(2) = Polyhedron([7 -6;6.9 6; -8 8; 8.4 -8.1; 5.6 -6.5]);

S = intersect(P(1),P(2));
S.computeHRep();
% low-dim
R = Polyhedron('H',S.H,'He',[1 1 2]);

% P(1) and P(2) contain R
t = P.contains(R);
assert(isequal(size(t), [2 1]));
assert(all(t));

end

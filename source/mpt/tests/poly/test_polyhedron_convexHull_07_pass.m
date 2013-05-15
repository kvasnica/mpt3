function test_polyhedron_convexHull_07_pass
%
% 
% H is empty -> irredundant representation
% 

H = [5  1 0.1 3 0 -0.4;
    -4 -1 6 -4 0.5 -1;
    0.6 1 -1 2 0.6 0;
    0.8 1 0 0 0 -3;
    0 0 0 1 0 0;
    0 0 2 -1 0 0;
    -0.3 0 0 -1 4 5;
    -4 0.5 0 0 -1 0;
    -2 0 0 0 -1 -1;
    0 0.5 0 0 -1 0;
    0 1 0 0.6 0 1;
    -0.2 -1 0.5 -0.1 -0.7 1;
    0.6 -0.7 0.001 -1 -1 -0.9];

P = Polyhedron('H',H);

% P is empty
if ~P.isEmptySet
    error('P must be empty');
end

[~, sol] = P.minHRep();
Pn = Polyhedron('H',sol.H,'He',sol.He);

if ~Pn.isEmptySet
    error('For empty polyhedrond redundancy elimitation should remove the same representation.');
end

end

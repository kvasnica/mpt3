function test_polyhedron_extreme_09_pass
%
% redundancy elimination
%

% redundant representation
V1 = randn(43,8);  

% non-redundant
P = Polyhedron(V1);
P.minVRep();

% pick 5 vertices and do linear combination
sv = P.V([4;9;1;15;11],:);
T= [0.2 0.4 0 0.1 0.3;
    0 0 0.9 0.1 0;
    0.1 0.1 0.2 0.4 0;
    0.3 0.5 0.1 0 0.1;
    0 0 0.8 0.1 0.1];
    
Vn = T*sv;

V2 = [V1; Vn; V1];

R = Polyhedron(V2);

R.minVRep();

if P~=R
    error('P is the same as R.')
end

end

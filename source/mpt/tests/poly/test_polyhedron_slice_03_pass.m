function test_polyhedron_slice_03_pass
%
% two dims, Vrep
% 

P = 5*ExamplePoly.randVrep('d',3,'nr',1);
while ~P.contains(zeros(3,1))
    P = 5*ExamplePoly.randVrep('d',3,'nr',1);
end

S = P.slice([1:2],1);

T=S.affineMap([eye(2);0 0]).plus([0;0;1]);
if ~P.contains(T)
    error('The set must be contained in P.');
end

% three cuts
offset = [0.1, -0.2, 0.3];
Sn = P.slice([1:2],offset);

for i=1:3
    Tn=Sn.affineMap([eye(2);0 0]).plus([0;0;offset(i)]);
    if ~P.contains(Tn(i))
        error('The set must be contained in P.');
    end
end

end
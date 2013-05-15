function test_polyhedron_slice_02_pass
%
% two dims
% 

P = ExamplePoly.randHrep('d',3);

S = P.slice([1 2],0.2);

T=S.affineMap([eye(2);0 0]).plus([0;0;0.2]);
if ~P.contains(T)
    error('The set must be contained in P.');
end

% three cuts
offset = [0.1, 0.2, 0.3];
Sn = P.slice([1 2],offset);

for i=1:3
    Tn=Sn.affineMap([eye(2);0 0]).plus([0;0;offset(i)]);
    if ~P.contains(Tn(i))
        error('The set must be contained in P.');
    end
end

end
function test_polyhedron_slice_04_pass
%
% array of polyhedra
% 

P(1) = 10*ExamplePoly.randVrep('d',3);
P(2) = 10*ExamplePoly.randHrep('d',3);

% two cuts
offset = [-1, 2.5];
Sn = P.slice(1:2,offset);

for i=1:2
    Tn = Sn{i}.affineMap([eye(2);0 0]).plus([0;0;offset(i)]);

    if ~P(i).contains(Tn(i))
        error('Should be contained.');
    end
end


end
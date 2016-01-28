function test_polyhedron_projection_28_pass
% test for issue #134

A = sparse([     1     0
    -1     0
    -1     0
    1     0
    1    -1]);
b =  sparse([1
    0
    0
    1
    0]);

% random permutations of rows should lead to the same projection
P = Polyhedron('A',A,'b',b);
Q = projection(P,1);
for i = 1:10
    pp=randperm(5);
    P = Polyhedron('A',A(pp,:),'b',b(pp));
    q = projection(P,1);
    assert(q==Q);
end

% same in 2D
P = Polyhedron('A',A,'b',b);
Q = projection(P,1:2);
for i = 1:10
    pp=randperm(5);
    P = Polyhedron('A',A(pp,:),'b',b(pp));
    q = projection(P,1:2);
    assert(q==Q);
end

end
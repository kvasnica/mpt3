function test_polyhedron_normalize_02_pass
%
% H-polyhedron
%

P = Polyhedron(5*randn(8,4),18*randn(8,1));
P.normalize;

A = P.A;
for i=1:size(A,1)
    if norm(norm(A(i,:))-1,Inf)>1e-4
        error('Wrong normalization.');
    end
end

end
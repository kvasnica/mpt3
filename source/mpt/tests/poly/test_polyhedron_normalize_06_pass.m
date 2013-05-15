function test_polyhedron_normalize_06_pass
%
% affine set
%

P(1) = ExamplePoly.randHrep('d',3,'ne',3);
P(2) = Polyhedron('He',randn(2,3));
P.normalize;

for i=1:2
    A = P(i).A;
    for j=1:size(A,1)
        if norm(norm(A(j,:))-1,Inf)>1e-4
            error('Wrong normalization.');
        end
    end
    Ae = P(i).Ae;
    for j=1:size(Ae,1)
        if norm(norm(Ae(j,:))-1,Inf)>1e-4
            error('Wrong normalization.');
        end
    end
end

end
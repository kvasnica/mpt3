function test_polyhedron_normalize_03_pass
%
% He-polyhedron
%

P = Polyhedron('A',50*randn(8,6),'b',8*rand(8,1),'Ae',randn(2,6),'be',rand(2,1));
P.normalize;

A = P.A;
Ae = P.Ae;
for i=1:size(A,1)
    if norm(norm(A(i,:))-1,Inf)>1e-4
        error('Wrong normalization.');
    end
end
for i=1:size(Ae,1)
    if norm(norm(Ae(i,:))-1,Inf)>1e-4
        error('Wrong normalization.');
    end   
end

end
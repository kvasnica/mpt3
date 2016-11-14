function test_polyhedron_normalize_07_pass
%
% unbounded, normalized polyhedron -no change
%

P = Polyhedron('lb',[0;0]);
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
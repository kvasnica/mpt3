function test_polyhedron_eq_07_pass
%
% triangles
% 

P = ExamplePoly.randVrep('d',3);
T = P.triangulate;

Q = Polyhedron(T(1:5));

ts = (T(1:5)==Q(1:5));

if ~ts
    error('The result should be true.');
end

end

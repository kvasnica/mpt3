function test_polyhedron_slice_01_pass
%
% one dim
% 

P = ExamplePoly.randHrep('d',3);

S = P.slice(1,0.2);


if ~S.contains(0.2)
    error('The point must be inside S.');
end

end
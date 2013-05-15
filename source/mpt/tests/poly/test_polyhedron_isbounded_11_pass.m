function test_polyhedron_isbounded_11_pass
%
% unbounded polyhedron (rectangle)
%

H = [0     1     1
    -1     0     1
     0    -1     1
     0     1     0
    -1     0     1
     0    -1     1];

P= Polyhedron('H',H);

if P.isBounded
    error('This polyhedron is unbounded.');
end


end
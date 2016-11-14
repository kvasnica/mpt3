function test_polyhedron_separate_04_pass
%
% full-dim, low-dim
%

P = ExamplePoly.randHrep('d',3);
while ~P.isBounded
    P = ExamplePoly.randHrep('d',3);
end
Q = ExamplePoly.randHrep('d',3,'ne',1)+[14;15;0];

h = P.separate(Q);

if isempty(h)
    error('There must be a separating hyperplane.');    
end

T = Polyhedron('He',h);
d1 = T.distance(P);
d2 = T.distance(Q);

if norm(d1.dist-d2.dist,Inf)>1e-4
    error('The distances should be equal.');
end


end
function test_polyhedron_distance_08_pass
%
% zonotope - plane, set difference
%

P = ExamplePoly.randZono;

S = Polyhedron('lb',[-2;-3],'ub',[2;3],'He',[1 1 1]);

while ~P.contains(S)
    P = ExamplePoly.randZono;
end

% cut P in two pieces
R=P\S;

assert(numel(R)==1);

% distance between R and S should be very small
d=R.distance(S);

assert(d.dist<=1e-4);

end

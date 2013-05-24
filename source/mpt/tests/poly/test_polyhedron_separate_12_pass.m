function test_polyhedron_separate_12_pass
%
% array vs point
%

P(1) = ExamplePoly.randHrep;
P(2) = ExamplePoly.randVrep;

x = [10;10];
h = P.forEach(@(e) e.separate(x), 'UniformOutput', false);


for i=1:2
    T = Polyhedron('He',h{i});
    d1 = T.distance(P(i));
    d2 = T.distance(x);
    
    
    if norm(d1.dist-d2.dist,Inf)>1e-4
        error('Distance must be the same.');
    end
end

end

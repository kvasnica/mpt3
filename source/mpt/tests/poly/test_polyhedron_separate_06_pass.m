function test_polyhedron_separate_06_pass
%
% array of full-dim
%

P(1) = ExamplePoly.randVrep;
P(2) = ExamplePoly.randHrep;
P(3) = ExamplePoly.randHrep;

Q = 0.1*ExamplePoly.poly3d_sin+[50;0];

% arrays must be rejected
[~, msg] = run_in_caller('h = P.separate(Q);');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

h = P.forEach(@(e) e.separate(Q), 'UniformOutput', false);

for i=1:3
    if isempty(h{i})
        error('There must be a separating hyperplane.');
    end
    
    T = Polyhedron('He',h{i});
    d1 = T.distance(P(i));
    d2 = T.distance(Q);
    
    if norm(d1.dist-d2.dist,Inf)>1e-4
        error('The distances should be equal.');
    end
end


end

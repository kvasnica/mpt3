function test_convexset_grid_07_pass
%
% Polyhedron array
% 

P(1) = Polyhedron(randn(11,2),4*ones(11,1));
P(2) = Polyhedron(randn(8,2));
P(3) = Polyhedron('lb',-rand(2,1),'ub',rand(2,1));

% arrays must be rejected
[~, msg] = run_in_caller('x = P.grid(10);');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

% forEach must require UniformOutput=true
[~, msg] = run_in_caller('x = P.forEach(@(e) e.grid(10))');
asserterrmsg(msg, 'Non-scalar in Uniform output, at index 1, output 1.');

% correct syntax
x = P.forEach(@(e) e.grid(4), 'UniformOutput', false);

end


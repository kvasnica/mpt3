function test_convexset_separate_06_pass
%
% array of random polyhedra in 5D
%

x = sdpvar(5,1);
F1 = (randn(17,5)*x <= ones(17,1));
F2 = [(randn(54,5)*x <= 2*ones(54,1)) ; (randn(3,5)*x==0.2*rand(3,1))];

Y = [YSet(x,F1), YSet(x,F2)];

v = 10*randn(5,1);

% reject arrays
[~, msg] = run_in_caller('h = Y.separate(v);');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

s = Y.forEach(@(e) e.separate(v), 'UniformOutput', false);

d = distance(Y,v);

x1 = (v+d(1).y)/2;
x2 = (v+d(2).y)/2;

P1 = Polyhedron('He',s{1});
P2 = Polyhedron('He',s{2});

if ~P1.contains(x1)
    error('P1 must contain the point x1.');
end
if ~P2.contains(x2)
    error('P2 must contain the point x2.');
end


end

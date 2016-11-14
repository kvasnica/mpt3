function test_convexset_separate_07_pass
%
% array of random polyhedra in 3D
%

P(1) = Polyhedron(randn(15,3));
P(2) = Polyhedron('lb',-rand(3,1),'He',rand(1,4),'A',[1 -0.4 0],'b',1.5);

v = 5*randn(3,1);

% reject arrays
[~, msg] = run_in_caller('h = P.separate(v);');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

s = P.forEach(@(e) e.separate(v), 'UniformOutput', false);

P1 = Polyhedron('He',s{1});
P2 = Polyhedron('He',s{2});

d1 = P1.distance(v);
d2 = P2.distance(v);

z1 = v + s{1}(1:3)';
z2 = v + s{2}(1:3)';

if ~P1.contains((v+z1)/2)
    error('Separating hyperplane must be in the middle between v and z1');
end
if ~P2.contains((v+z2)/2)
    error('Separating hyperplane must be in the middle betwee v and z2.');
end


end

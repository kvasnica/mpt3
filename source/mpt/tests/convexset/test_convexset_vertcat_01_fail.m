function test_convexset_vertcat_01_fail
%
% 2 different objects
%

P = Polyhedron(randn(5));
x = sdpvar(2,1);
F = set(x>=0); 

Y = YSet(x,F);

Set = [P;Y];


end

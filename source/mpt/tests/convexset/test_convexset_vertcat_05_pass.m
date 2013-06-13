function test_convexset_vertcat_05_pass
%
% 2 different objects
%

P = Polyhedron(randn(5));
x = sdpvar(2,1);
F = set(x>=0); 

Y = YSet(x,F);

[worked, msg] = run_in_caller('Set = [P;Y]; ');
assert(~worked);
asserterrmsg(msg,'Only the same sets can be concatenated.');


end

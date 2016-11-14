function test_opt_32_pass
%
% opt constructor fail test
% 
% 

S.H=randn(10);
S.A=randn(102,10);
S.b=randn(102,1);
S.pB=randn(102,6);
S.solver='mpqp';
% the value of f must be 1x10
S.f=randn(6,10);

[worked, msg] = run_in_caller('Opt(S);');
assert(~worked);
asserterrmsg(msg,'Input argument must be a "Polyhedron" class.');

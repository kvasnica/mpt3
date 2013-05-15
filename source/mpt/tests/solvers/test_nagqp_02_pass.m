function test_nagqp_02_pass
% no options test

n = 37;
nc = 10;

A = randn(nc,n);
B = randn(nc,1);
l = -10*ones(n,1);
u = 10*ones(n,1);

la = -1e9*ones(nc,1);
ua = B;
[x2, f2] = mexnagqp([],[], A, [l' la'], [u;ua], zeros(1,n));




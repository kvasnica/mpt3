function test_nagqp_06_fail
% no lower bound

n = 37;
nc = 10;

A = randn(nc,n);
B = randn(nc,1);
c = round(rand(1,n));
l = -10*ones(n,1);
u = 10*ones(n,1);

la = -1e9*ones(nc,1);
ua = B;
[x2, f2] = mexnagqp([], c, A, [], u, zeros(1,n));




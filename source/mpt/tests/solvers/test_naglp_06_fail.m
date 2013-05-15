function test_naglp_06_fail
% no lower bound

n = 37;
nc = 10;
nceq = 15;

A = randn(nc,n);
B = randn(nc,1);
c = round(rand(1,n));
Aeq = [randn(nceq,n-0) zeros(nceq,0)];
Beq = randn(nceq,1);
l = -10*ones(n,1);
u = 10*ones(n,1);

la = -1e9*ones(nc,1);
ua = B;
[x2, f2] = mexnaglp(c, A, [], u, zeros(1,n));




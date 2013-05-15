function test_naglp_05_pass
% no inequality constraints test

n = 37;
nc = 10;

A = randn(nc,n);
B = randn(nc,1);
c = round(rand(1,n));
l = -10*ones(n,1);
u = 10*ones(n,1);

la = -1e9*ones(nc,1);
ua = B;
[x2, f2] = mexnaglp(c, [], l', u, zeros(1,n));




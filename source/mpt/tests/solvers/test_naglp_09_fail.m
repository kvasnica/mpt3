function test_naglp_09_fail
% too many arguments

n = 37;
nc = 10;

A = randn(nc,n);
B = randn(nc,1);
c = round(rand(1,n));
l = -10*ones(n,1);
u = 10*ones(n,1);

la = -1e9*ones(nc,1);
ua = B;
opt.fopt = 1e-8;
mexnaglp([], A, [l' la'], [u;ua], zeros(1,n),opt,1);


function test_nagqp_09_fail
% too many arguments

n = 37;
nc = 10;

Q = randn(n);
H = Q'*Q;
A = randn(nc,n);
B = randn(nc,1);
c = round(rand(1,n));
l = -10*ones(n,1);
u = 10*ones(n,1);

la = -1e9*ones(nc,1);
ua = B;
opt.ftol = 1e-8;
mexnagqp(H,c, A, [l' la'], [u;ua], zeros(1,n),opt,1);


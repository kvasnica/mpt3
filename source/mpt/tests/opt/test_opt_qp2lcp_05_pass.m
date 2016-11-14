function test_opt_qp2lcp_05_pass
%
% parametric qp2lcp, test if redundancy elimination is ok in higher
% dimensions - 4 parameters
%

S.A=[  1.8048      0.65089;
      -2.3345      0.34068;
     -0.20446      0.13268;
      0.29604     -0.23329;
      0.44663      0.41649];
S.b = ones(5,1);
S.pB = [-0.091772      0.14328     -0.28103       -1.872;
      0.38085      0.37674      -1.7814      -1.1849;
       0.2621     -0.21903     -0.49335     0.036901;
      0.43785    -0.086029     -0.83318     -0.14436;
     -0.17504     -0.18939     -0.18078      -2.1384];
S.f = [-1;0];
S.pF = [0 1 -0.5 -4; 0.1 0 0 -2];
S.Ae = [1 -3];
S.be = 0.5;
S.Ath = [eye(4);-eye(4)];
S.bth = 10:10:80;

% solution with redundancy elimination
problem1 = Opt(S);
r = problem1.solve;

% check if the solution is the same when solving LCP
problem2 = Opt(S);
problem2.qp2lcp(false); %no redundancy elimination

rn=problem2.solve;

% check regions
for i=1:r.xopt.Num
   ts(i) = (r.xopt.Set(i) ==rn.xopt.Set(i));    
end

if ~all(ts(i))
    error('Regions must be the same.');
end



end
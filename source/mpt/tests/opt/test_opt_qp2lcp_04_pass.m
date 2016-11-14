function test_opt_qp2lcp_04_pass
%
% parametric qp2lcp, test if redundancy elimination is ok
%

S.A=[  1.8048      0.65089;
      -2.3345      0.34068;
     -0.20446      0.13268;
      0.29604     -0.23329;
      0.44663      0.41649];
S.b = ones(5,1);
S.pB = [0.98297      0.95942;
       1.2943       0.3874;
      0.66302       0.6278;
      0.57566     0.089817;
     -0.87411      0.14418];
S.f = [-1;0];
S.Ath = [eye(2);-eye(2)];
S.bth = [10; 20; 30; 40];

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

if ~all(ts)
    error('Regions must be the same.');
end



end
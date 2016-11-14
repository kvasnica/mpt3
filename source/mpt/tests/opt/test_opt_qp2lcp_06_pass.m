function test_opt_qp2lcp_06_pass
%
% parametric qp2lcp, test if solution is the same with/without redundancy
% elimination
%

S.A = [1 2 3 4 5;
      -9 0 0 0 1;
      0.5 -1 1 0 0;
      -1 0.6 0.8 0 0;
      -.8 0.4 0.9 0.1 -1;
      -.8 0.4 0.9 0.1 -1;
      0 -10 0 -5 0];
S.b = 2:2:14;    
S.pB=[0.78072       0.8951;
     -0.91533     -0.77573;
     -0.50093     -0.43913;
       -0.918      0.89365;
       -2.094      0.48037;
       -2.094      0.48037;
      0.19686     -0.65894];
S.f = [1; -0.9; 0.8; -0.7; 0.6];
S.H = [  9.6685      -3.0026       1.4516      -3.9411       5.1064;
      -3.0026       5.3707      -1.6768     0.014278       -2.502;
       1.4516      -1.6768       2.1442    -0.020172     0.070476;
      -3.9411     0.014278    -0.020172       2.6287      -2.8188;
       5.1064       -2.502     0.070476      -2.8188        4.982];
S.Ath = [eye(2);-eye(2)];
S.bth = 100*ones(4,1);

% solution with redundancy elimination
problem1 = Opt(S);
r = problem1.solve;

% check if the solution is the same when solving LCP
problem2 = Opt(S);
problem2.qp2lcp(false); %no redundancy elimination

rn=problem2.solve;

if r.xopt.Num~=rn.xopt.Num
    error('Number of regions does not hold.');
end

% check regions
for i=1:r.xopt.Num
      xc = chebyCenter(r.xopt.Set(i));
%       index=find_region(xc.x,rn.regions.P,rn.lcpSol.adj_list);
%       if isempty(index)
          [isin,index]=isInside(rn.xopt.Set,xc.x);
          if isempty(index)
              error('no region found');
          end
%           disp('wrong adjacency list.');
%       end
      ts(i) = r.xopt.Set(i).contains(rn.xopt.Set(index)) | rn.xopt.Set(index).contains(r.xopt.Set(i));
end

if ~all(ts)
    error('Regions must be the same.');
end



end
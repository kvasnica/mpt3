function test_plcp_08_pass
%  example problem by Daniel Axehill

%% input data
% w - M*z = q + Q*th

load danieltestprob

% create problem
problem = Opt(matrices);

% solve via PLCP
r = problem.solve;

% MPT
Pn = mpt_mpqp(matrices);

ts = false(1,length(Pn));
for i=1:length(Pn)
    
      x = chebyball(Pn(i));

      index=find_region(x,r.xopt.Set,r.xopt.Internal.adj_list);
      if isempty(index)
          [~,index] = isInside(r.xopt.Set,x);
      else
          ts(i) = (r.xopt.Set(index)==Polyhedron('H',double(Pn(i))));
      end
    
end

if ~all(ts)
    error('regions must be the same');
end

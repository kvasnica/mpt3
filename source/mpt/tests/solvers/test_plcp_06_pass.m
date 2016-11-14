function test_plcp_06_pass
%  
% Yproblem- very good for catching bugs and testing numerics
%
% hints: try to solve with different starting points
%        adjust region tolerance
%        

load Yproblem

% solve using PLCP
r = Yproblem.solve;


% solve using MPLP
Ynew = Opt('A',Yproblem.A,'b',Yproblem.b,'pB',Yproblem.pB,'Ae',Yproblem.Ae,'be',Yproblem.be,'pE',Yproblem.pE,...
    'f',Yproblem.f,'pF',Yproblem.pF,'lb',Yproblem.lb,'ub',Yproblem.ub,'Ath',Yproblem.Ath,'bth',Yproblem.bth,'solver','mplp');
res = Ynew.solve;

% check regions
ts = false(res.xopt.Num,1);
for i=1:res.xopt.Num
      xc = chebyCenter(res.xopt.Set(i));
      %index=find_region(xc.x,r.xopt.Set,r.xopt.Internal.adj_list);
      index = locatePoint(r.xopt,xc.x);
      if isempty(index)
          [~,index] = isInside(r.xopt.Set,xc.x);
      else
          ts(i) = (r.xopt.Set(index)==res.xopt.Set(i));
      end
end

if ~all(ts)
    error('Regions must be the same.');
end



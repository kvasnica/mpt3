function test_plcp_17_pass
%
% LCP returns infeasible and MPLP returns 6 regions
%

load data_plcp_test_17


Matrices.solver='mplp';
p1 = Opt(Matrices);
mplpsol = p1.solve;

% if sol.xopt.Num ~= 6
%     error('The partition should consist of 6 regions.');
% end

Matrices.solver = 'plcp';
p2 = Opt(Matrices);
plcpsol = p2.solve;


for i=1:mplpsol.xopt.Num
   xc = mplpsol.xopt.Set(i).chebyCenter;
   x = xc.x;
   x1 = mplpsol.xopt.feval(x,'primal');
   x2 = plcpsol.xopt.feval(x,'primal');
   
   obj1 = mplpsol.xopt.feval(x,'obj');
   obj2 = plcpsol.xopt.feval(x,'obj');

   % degenerate, must not match
%    if norm(x1-x2,Inf)>1e-4
%        error('Primal solutions do not match.');
%    end
   if norm(obj1-obj2,Inf)>1e-4
       error('Primal solutions do not match.');
   end
    
    
end


end

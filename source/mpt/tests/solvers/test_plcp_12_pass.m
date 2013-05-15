function test_plcp_12_pass
%
% 2D example from compleib library (NN2) 2-norm

global MPTOPTIONS

% % model
% A=[0,1;-1,0];
% B=[0;1];
% C=[0,1];
% 
% % continuous system
% csys = ss(A,B,C,0);
% 
% % use very small sampling time
% dsys = c2d(csys,0.01);
% 
% % old-mpt format
% sysStruct = mpt_sys(dsys);
% 
% % put some artificial constraints
% sysStruct.umin = -8;
% sysStruct.umax = 8;
% sysStruct.xmin = [-8;-9];
% sysStruct.xmax = [10;11];
% 
% % formulate MPC with terminal constraints % 2-norm
% probStruct.N = 5;
% probStruct.norm=2;
% probStruct.Q=eye(2);
% probStruct.R=1;
% probStruct.subopt_lev=0;
% 
% % solve with old MPT
% ctrl= mpt_control(sysStruct,probStruct);
load data_plcp_test12
M.solver = 'mpqp';
p = Opt(M);
res = p.solve;

% solve via MPT3
M.solver = 'plcp';
problem=Opt(M);
r = problem.solve;

for i=1:res.xopt.Num
    
    % find equivalent region to Pn
    xc = chebyCenter(res.xopt.Set(i));
    x = xc.x;
    index = find_region(x,r.xopt.Set,r.xopt.Internal.adj_list);
    %[isin,index] = isInside(r.xopt.Set,x);
    
    if isempty(index)
        %error('empty region');
        error('wrong adjacency list');
    end

    % compare solution
    xd = feval(res.xopt.Set(i),x,'primal');
    fd = feval(res.xopt.Set(i),x,'obj');
    
    xopt = feval(r.xopt.Set(index),x,'primal') ;
    f = feval(r.xopt.Set(index),x,'obj') ;
    
    if norm(xd-xopt,Inf)>1e-4
        error('Solution does not hold.');
    end
    if norm(fd-f,Inf)>1e-4
        error('Objective value does not hold.');
    end
    
end


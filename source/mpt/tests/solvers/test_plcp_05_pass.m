function test_plcp_05_pass
%  
% parametric problem with 3 or 5 regions?
%

global MPTOPTIONS

p.A =[ 0.4597;
      0.84147;         
      -0.4597;   
     -0.84147;    
            1;   
           -1;    
            0;    
            0;    
            0;     
            0];     

p.b=[ 4.75;
      4.75;
      4.75;
      4.75;
         2;
         2;
         5;
         5;
         5;
         5];

p.f = [];

p.pB=[-0.5403     -0.84147;
      0.84147      -0.5403;
      0.5403      0.84147;
     -0.84147       0.5403;
        0            0;
        0            0;
        1            0;
        0            1;
       -1            0;
        0           -1];


p.solver = 'plcp';
problem_new = Opt(p);
res_new = problem_new.solve;

if res_new.xopt.Num~=3
    error('Here should be 3 regions.');
end

% % for each region solve LP to test if the solution is the same
% active2=zeros(1,length(res_new.regions.numP));
% for i=1:res_new.regions.numP
% 
%    xc = chebyCenter(res_new.regions.P(i));
%    S.A = p.A;
%    S.f = p.f;
%    S.b = p.b + p.pB*xc.x;
% 
%    rn= mpt_solve(S);
%    
%    %xopt=feval(res_new.primal.P(i).func,xc.x') ;
%    
%    % solution might be different (is degenerate)
%    %fprintf('Difference in the PLCP solution %f.\n',norm(rn.xopt-xopt,1));
%    
%    % check active constraints   
%    active2(i) = find( S.A*rn.xopt > S.b - MPTOPTIONS.rel_tol);
%    
%    
% end
% 
% if numel(unique(active2))~=numel(active2)
%     fprintf('PLCP solution is wrong! There is %d number of regions but identified were %d active sets.\n',res_new.regions.numP,numel(unique(active2)));
% end
% 
% 
% % MPLP reports 5 regions (with the newest version of mplp solver)
% % one of the older versions reports 3 regions
% % The correct solution are 3 regions.
% p.solver = 'mplp';
% problem = Opt(p);
% res=problem.solve;
% 
% % for each region solve LP to test if the solution is the same
% active1=zeros(1,res.regions.numP);
% for i=1:res.regions.numP
% 
%    xc = chebyCenter(res.regions.P(i));
%    S.A = p.A;
%    S.f = p.f;
%    S.b = p.b + p.pB*xc.x;
%    
%    rn= mpt_solve(S);
%    
%    %xopt=feval(res.primal.P(i).func,xc.x')';
%    
%    % solution might not be the same
%    %fprintf('Difference in the MPLP solution %f.\n',norm(rn.xopt-xopt,1));
%    
%    % check active constraints   
%    active1(i) = find( S.A*rn.xopt > S.b-MPTOPTIONS.rel_tol);
%    
%    
% end
%     
% if numel(unique(active1))~=numel(active1)
%     fprintf('MPLP solution is wrong! There is %d number of regions but identified were %d active sets.\n',res.regions.numP,numel(unique(active1)));
% end

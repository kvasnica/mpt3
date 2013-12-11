function test_opt_qp2lcp_14_pass
%
% parametric qp2lcp, only equalities on parameter
%
% Very hard example! Especially due to high number of constraints and large
% values in the objective function. During the exploration same regions
% are discovered that correpond to different index sets and overlaps are
% detected.
%
global MPTOPTIONS

% load test data
load test_dualLP_01

% force checking of adj. list
MPTOPTIONS.modules.solvers.plcp.adjcheck=true;
onCleanup(@()setdefault);

d.pE = [0.12622      -1.6989
     0.014418       1.0117
     -0.96446      0.22981
      0.63906       1.5191
      0.88738       1.5951
     -0.34175     -0.82006
      -1.1041     -0.65937
     0.027637      0.10048
        2.044      0.52474
      0.22659      -1.4096
    -0.089746     -0.77729
     -0.50376       1.3164
      -1.1675     -0.39324
       1.4897       1.1116
    -0.019282     -0.86057
      -1.1495       1.2133
       1.0025        0.283
     0.089725      -1.0758
      0.35988     -0.31149
      0.49079      -1.0127
       0.4378     -0.59668
       0.3233     -0.26034
     -0.54815     -0.12663
     -0.77334     -0.56923
       0.5352      0.61112
      0.09597       1.4855
     -0.32723      -1.7137
     -0.86725      0.26111
    -0.008097       1.2097
            0            0
            0            0
            0            0
            0            0
            0            0
            0            0];

d.Ath = [eye(2);-eye(2)];
d.bth = 10*ones(4,1);
problem = Opt(d);
r=problem.solve;

% compare solutions
for i=1:r.xopt.Num

    % point inside P
    xc = chebyCenter(r.xopt.Set(i));    
    
    % check adj list
    %index = find_region(xc.x,r.regions.P,r.lcpSol.adj_list);
    %[i, index]
    
    
    % xopt
    xopt = feval(r.xopt.Set(i),xc.x,'primal');
    
    % solve QP    
    p.A = d.A;
    p.b = d.b;
    p.Ae = d.Ae;
    p.be = d.be + d.pE*xc.x;
    p.f = d.f;
    
    res = mpt_solve(p);
    
    nr = norm(res.xopt-xopt,Inf);
    % because the objective value has too large numbers, the results do not
    % fit with small tolerances
    if nr>0.12
        error('PLCP solution does not hold for region %d, difference=%f.\n',i,nr);
    end
        
end




end

function setdefault

global MPTOPTIONS
MPTOPTIONS.modules.solvers.plcp.adjcheck=false;

end
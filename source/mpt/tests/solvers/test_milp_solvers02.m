function test_milp_solvers02(solver, tol)
% test program

fname = mfilename;
check_MILPsolvers;

% initial data
A = [-2.4240   -0.4542   -0.0766   -0.2928    0.9967
   -0.2238   -0.6521    1.7382    0.0828    1.2159
    0.0581    0.1033    1.6220    0.7662   -0.5427
   -0.4246   -0.2206    0.6264    2.2368    0.9122
   -0.2029   -0.2790    0.0918    0.3269   -0.1721
   -1.5131   -0.7337   -0.8076    0.8633   -0.3360
   -1.1264   -0.0645   -0.4613    0.6794    0.5415
   -0.8150   -1.4440   -1.4060    0.5548    0.9321
    0.3666    0.6123   -0.3745    1.0016   -0.5703
   -0.5861   -1.3235   -0.4709    1.2594   -1.4986
    1.5374   -0.6616    1.7513    0.0442   -0.0503
    0.1401   -0.1461    0.7532   -0.3141    0.5530
   -1.8628    0.2481    0.0650    0.2267    0.0835];

b = [ 0.8956
    0.7310
    0.5779
    0.0403
    0.6771
    0.5689
   -0.2556
   -0.3775
   -0.2959
   -1.4751
   -0.2340
    0.1184
    0.3148];

Aeq = [  0         0         0    0.2120   -1.0078
         0         0         0    0.2379   -0.7420];

beq = [ 1.0823;   -0.1315];

% set some variables as binary
vartype = 'C'*ones(5,1);
vartype(3) = 'B';
vartype = char(vartype);

% solution via CPLEX
xd = [    -3.537772018362528e-01
     1.014579643662672e+01
                         0
    -1.134716698107326e+01
    -3.460904346088045e+00];
fvald = -5.016052092370845e+00;

% use old MPT interface to solve it
%[x1,fval1,how,exfl]=mpt_solveMILP(ones(1,5),A,b,Aeq,beq,-1e9*ones(5,1),1e9*ones(5,1),char(vartype),[],[],solver);

% create structure
S.f = ones(1,5);
S.A = A;
S.b = b;
S.Ae = Aeq;
S.be = beq;
S.vartype = char(vartype);
S.solver = solver;

R = mpt_solve(S);

% compare results
if norm(R.xopt-xd,Inf)>tol
    error('Results are not equal within a given tolerance.');
end
if norm(R.obj-fvald,Inf)>tol
    error('Results are not equal within a given tolerance.');
end

%mbg_asserttolequal(R.xopt,xd,tol);
%mbg_asserttolequal(R.obj,fvald,tol);

end
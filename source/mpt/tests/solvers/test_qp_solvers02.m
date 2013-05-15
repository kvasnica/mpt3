function test_qp_solvers02(solver,tol)
% example test2

% one eigenvalue is very close to 0
H =[  1.3738   -0.4425   -2.5045    0.3011
   -0.4425    4.8346    3.1816    0.2346
   -2.5045    3.1816    5.8661   -1.1873
    0.3011    0.2346   -1.1873    6.7096];

f =[ -1.7700;  0.4115;  -1.0041;  1.4953];
A =[    0.8202    0.4495   -0.1507    1.4139
   -1.1663   -0.8386   -0.3983    1.6418
    1.2761   -0.1635   -0.5599    0.5036
    0.7431   -1.5229   -1.0374   -0.0538
    0.3006    0.0351    0.6535    0.5091];
B = 5*ones(5,1);
Aeq = [   -0.8784    0.9127         0         0
   -1.9260    0.8439         0         0];
Beq =[  0.0918;  -0.3733];
xd = [ 0.411361202978100
   0.496482612792772
   0.026098817471881
  -0.254061129306296];
fd = -0.128513336993792;

% use old MPT interface to solve it
%[x,~,~,~,fval] = mpt_solveQP(H,f,A,B,Aeq,Beq,xstart,solver);

% create structure S
S.H = H;
S.f = f;
S.A = A;
S.b = B;
S.Ae = Aeq;
S.be = Beq;
S.solver = solver;

% call mpt_solve
R = mpt_solve(S);

% compare results
if norm(R.xopt-xd,Inf)>tol
    error('Results are not equal within a given tolerance.');
end
if norm(R.obj-fd,Inf)>tol
    error('Results are not equal within a given tolerance.');
end

%mbg_asserttolequal(R.obj,fd,tol);
%mbg_asserttolequal(R.xopt,xd,tol);

end
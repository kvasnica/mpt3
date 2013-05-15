function test_plcp_21_pass
% benchmark for testing speed of PLCP solver

sysStruct.A= [   0.5403   -0.8415; 0.8415    0.5403];
sysStruct.B=[ -0.4597; 0.8415];

%y(k)=Cx(k)+Du(k)
sysStruct.C=[1 0];
sysStruct.D=0;

%set constraints on output
sysStruct.ymin = -10;
sysStruct.ymax = 10;

%set constraints on input
sysStruct.umin    =   -0.1;
sysStruct.umax    =   1.1;

probStruct.norm=2;
probStruct.Q=eye(2);
probStruct.R=1;
probStruct.N=20;
probStruct.subopt_lev=0;


% formulate problem
M = mpt_constructMatrices(sysStruct, probStruct);
problem = Opt(M);

% solve
t=clock;
res=problem.solve; 
etime(clock, t)

if res.xopt.Num~=850
    error('The number of regions does not hold.');
end

end
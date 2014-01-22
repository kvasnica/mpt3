function test_opt_eliminateEquations_19_pass
%
% [issue162] error while using mpt toolbox 2.6.3
%
% The problem is not controllable and in MPT2.6 the stabilizing set cannot
% be found which throws an error. 
%

di=ss([0 0 -4.92 0 0;0 0 4.92 -4.92 0;384.6 -384.6 0 0 0;0 0 0 0 0;0 0 0 0 0],...
    [4.92;0;0;0;0],[1 0 0 0 -1;0 0 1 -1 0],[0;0]);
sysStruct=mpt_sys(di,0.005);
sysStruct.A=[0 0 -4.92 0 0;0 0 4.92 -4.92 0;384.6 -384.6 0 0 0;0 0 0 0 0;0 0 0 0 0];
sysStruct.B=[4.92;0;0;0;0];
sysStruct.C=[1 0 0 0 -1;0 0 1 -1 0];
sysStruct.D=zeros(2,1);
sysStruct.umin=-2;
sysStruct.umax=2;
sysStruct.ymin=[-1.25 -3];
sysStruct.ymax=[1.25 1];

probStruct.norm=2;
probStruct.Q=[3 0 0 0 -3;0 0 0 0 0;0 0 0.5 -0.5 0;0 0 -0.5 0.5 0;-3 0 0 0 3];
probStruct.R=0.0002;
probStruct.N=10;
probStruct.Nc=2;
probStruct.subopt_lev=0;

M=mpt_import(sysStruct,probStruct);

C = MPCController(M,probStruct.N);
% EC = C.toExplicit;
% 
% if EC.optimizer.Num~=1
%     error('The problem should result in 1 region.');
% end

[worked, msg] = run_in_caller('EC=C.toExplicit;');

% this should throw an error that equalities cannot be removed
assert(~worked);
asserterrmsg(msg,'Could not find invertible submatrix for removing equalities');

end
function test_mpccontroller_02_pass
% import from sysStruct/probStruct

% quadratic cost, automatically adding LQR set/penalty
clear
Double_Integrator
probStruct.Q = diag([2 3]); probStruct.R = 1.5;
M = MPCController(mpt_import(sysStruct, probStruct), probStruct.N);
assert(M.N==probStruct.N);
assert(isa(M.model, 'LTISystem'));
assert(isequal(M.model.A, sysStruct.A));
assert(isequal(M.model.B, sysStruct.B));
assert(isequal(M.model.C, sysStruct.C));
assert(isequal(M.model.D, sysStruct.D));
assert(isequal(M.model.u.max, sysStruct.umax));
assert(isequal(M.model.u.min, sysStruct.umin));
assert(isequal(M.model.y.max, sysStruct.ymax));
assert(isequal(M.model.y.min, sysStruct.ymin));
assert(M.model.x.hasFilter('terminalSet'));
assert(M.model.x.hasFilter('terminalPenalty'));
assert(isequal(M.model.x.terminalPenalty.weight, M.model.LQRPenalty.weight));
assert(isa(M.model.x.penalty, 'QuadFunction'));
assert(isa(M.model.u.penalty, 'QuadFunction'));
assert(isequal(M.model.x.penalty.weight, probStruct.Q));
assert(isequal(M.model.u.penalty.weight, probStruct.R));

% quadratic cost, custom terminal penalty
clear
Double_Integrator
probStruct.P_N = eye(2); probStruct.Tconstraint = 0;
M = MPCController(mpt_import(sysStruct, probStruct), probStruct.N);
assert(M.N==probStruct.N);
assert(isa(M.model, 'LTISystem'));
assert(isequal(M.model.A, sysStruct.A));
assert(isequal(M.model.B, sysStruct.B));
assert(isequal(M.model.C, sysStruct.C));
assert(isequal(M.model.D, sysStruct.D));
assert(isequal(M.model.u.max, sysStruct.umax));
assert(isequal(M.model.u.min, sysStruct.umin));
assert(isequal(M.model.y.max, sysStruct.ymax));
assert(isequal(M.model.y.min, sysStruct.ymin));
assert(~M.model.x.hasFilter('terminalSet'));
assert(M.model.x.hasFilter('terminalPenalty'));
assert(isequal(M.model.x.terminalPenalty.weight, probStruct.P_N));

% quadratic cost, custom terminal penalty and terminal set
clear
Double_Integrator
probStruct.P_N = eye(2); probStruct.Tconstraint = 0;
probStruct.Tset = unitbox(2);
M = MPCController(mpt_import(sysStruct, probStruct), probStruct.N);
assert(M.N==probStruct.N);
assert(isa(M.model, 'LTISystem'));
assert(isequal(M.model.A, sysStruct.A));
assert(isequal(M.model.B, sysStruct.B));
assert(isequal(M.model.C, sysStruct.C));
assert(isequal(M.model.D, sysStruct.D));
assert(isequal(M.model.u.max, sysStruct.umax));
assert(isequal(M.model.u.min, sysStruct.umin));
assert(isequal(M.model.y.max, sysStruct.ymax));
assert(isequal(M.model.y.min, sysStruct.ymin));
assert(M.model.x.hasFilter('terminalSet'));
assert(M.model.x.hasFilter('terminalPenalty'));
assert(isequal(M.model.x.terminalPenalty.weight, probStruct.P_N));

% 1-norm cost
clear
Double_Integrator
probStruct.norm = 1;
M = MPCController(mpt_import(sysStruct, probStruct), probStruct.N);
assert(M.N==probStruct.N);
assert(isa(M.model, 'LTISystem'));
assert(isa(M.model.x.penalty, 'OneNormFunction'));
assert(isa(M.model.u.penalty, 'OneNormFunction'));

% Inf-norm cost
clear
Double_Integrator
probStruct.norm = Inf;
M = MPCController(mpt_import(sysStruct, probStruct), probStruct.N);
assert(M.N==probStruct.N);
assert(isa(M.model, 'LTISystem'));
assert(isa(M.model.x.penalty, 'InfNormFunction'));
assert(isa(M.model.u.penalty, 'InfNormFunction'));

% xref
clear
Double_Integrator; probStruct.norm=1;
probStruct.xref = [2; 3];
M = MPCController(mpt_import(sysStruct, probStruct), probStruct.N);
assert(M.N==probStruct.N);
assert(isa(M.model, 'LTISystem'));
assert(M.model.x.hasFilter('reference'));
assert(~M.model.u.hasFilter('reference'));
assert(~M.model.y.hasFilter('reference'));
assert(isequal(M.model.x.reference, probStruct.xref));

% uref
clear
Double_Integrator; probStruct.norm=1;
probStruct.uref = -2;
M = MPCController(mpt_import(sysStruct, probStruct), probStruct.N);
assert(M.N==probStruct.N);
assert(isa(M.model, 'LTISystem'));
assert(~M.model.x.hasFilter('reference'));
assert(M.model.u.hasFilter('reference'));
assert(~M.model.y.hasFilter('reference'));
assert(isequal(M.model.u.reference, probStruct.uref));

% xref+uref
clear
Double_Integrator; probStruct.norm=1;
probStruct.xref = [2; 3]; probStruct.uref = -2;
M = MPCController(mpt_import(sysStruct, probStruct), probStruct.N);
assert(M.N==probStruct.N);
assert(isa(M.model, 'LTISystem'));
assert(M.model.x.hasFilter('reference'));
assert(M.model.u.hasFilter('reference'));
assert(~M.model.y.hasFilter('reference'));
assert(isequal(M.model.x.reference, probStruct.xref));
assert(isequal(M.model.u.reference, probStruct.uref));

end

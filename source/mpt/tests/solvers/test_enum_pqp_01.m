function test_enum_pqp_01
% region-based mpt_enum_pqp

% remember the original solver and set it back when the function ends
m = mptopt;
pqp_solver = m.pqpsolver;
c = onCleanup(@() mptopt('pqpsolver', pqp_solver));
mptopt('pqpsolver', 'enumpqp');

Double_Integrator
model = mpt_import(sysStruct, probStruct);
N = 4;
ctrl = MPCController(model, N);
d = ctrl.toYALMIP();

%% direct call via mpt_constructMatrices
probStruct.N = N;
M = mpt_constructMatrices(sysStruct, probStruct);
pqp = Opt(M);
sol = mpt_enum_pqp(pqp);
assert(isequal(sol.how, 'ok'));
assert(sol.exitflag==1);
assert(sol.xopt.Num==23);
for i = 1:sol.xopt.Num
    % primal optimizer must yield u_0, u_1, u_2, u_3
    assert(sol.xopt.Set(i).Functions('primal').R==N);
    assert(sol.xopt.Set(i).Functions('primal').D==2);
end
check_primal(sol);
assert(iscell(sol.stats.Aoptimal));
assert(length(sol.stats.Aoptimal)==5);
assert(isequal(cellfun('length', sol.stats.Aoptimal), [1 6 8 4 4]));
assert(isequal(cellfun('length', sol.stats.Afeasible), [1 14 68 140 4]));
assert(isequal(cellfun('length', sol.stats.Ainfeasible), [0 2 23 10 128]));
assert(sol.stats.nLPs==595);
assert(isa(sol.xopt.Set(1), 'Polyhedron')); % must be region-based

%% direct call to mpt_enum_pqp without eliminateEquations
pqp = Opt(d.constraints, d.objective, d.internal.parameters, d.variables.u(:));
sol = mpt_enum_pqp(pqp);
assert(isequal(sol.how, 'ok'));
assert(sol.exitflag==1);
assert(sol.xopt.Num==23);
for i = 1:sol.xopt.Num
    % primal optimizer must yield u_0, u_1, u_2, u_3
    assert(sol.xopt.Set(i).Functions('primal').R==N);
    assert(sol.xopt.Set(i).Functions('primal').D==2);
end
check_primal(sol);
assert(iscell(sol.stats.Aoptimal));
assert(length(sol.stats.Aoptimal)==5);
assert(isequal(cellfun('length', sol.stats.Aoptimal), [1 6 8 4 4]));
assert(isequal(cellfun('length', sol.stats.Afeasible), [1 14 68 140 4]));
assert(isequal(cellfun('length', sol.stats.Ainfeasible), [0 2 23 10 128]));
assert(sol.stats.nLPs==595);
assert(isa(sol.xopt.Set(1), 'Polyhedron')); % must be region-based

% direct call to mpt_enum_pqp with eliminateEquations
pqp = Opt(d.constraints, d.objective, d.internal.parameters, d.variables.u(:));
pqp.eliminateEquations();
sol = mpt_enum_pqp(pqp);
assert(isequal(sol.how, 'ok'));
assert(sol.exitflag==1);
assert(sol.xopt.Num==23);
for i = 1:sol.xopt.Num
    % primal optimizer must yield u_0, u_1, u_2, u_3
    assert(sol.xopt.Set(i).Functions('primal').R==N);
    assert(sol.xopt.Set(i).Functions('primal').D==2);
end
check_primal(sol);
assert(iscell(sol.stats.Aoptimal));
assert(length(sol.stats.Aoptimal)==5);
assert(isequal(cellfun('length', sol.stats.Aoptimal), [1 6 8 4 4]));
assert(isequal(cellfun('length', sol.stats.Afeasible), [1 14 68 140 4]));
assert(isequal(cellfun('length', sol.stats.Ainfeasible), [0 2 23 10 128]));
assert(sol.stats.nLPs==595);
assert(isa(sol.xopt.Set(1), 'Polyhedron')); % must be region-based

% now via Opt/solve - does not require manual elimination of equalities
pqp = Opt(d.constraints, d.objective, d.internal.parameters, d.variables.u(:));
sol = solve(pqp);
assert(isequal(sol.how, 'ok'));
assert(sol.exitflag==1);
assert(sol.xopt.Num==23);
for i = 1:sol.xopt.Num
    % primal optimizer must yield u_0, u_1, u_2, u_3
    assert(sol.xopt.Set(i).Functions('primal').R==N);
    assert(sol.xopt.Set(i).Functions('primal').D==2);
end
check_primal(sol);
assert(iscell(sol.stats.Aoptimal));
assert(length(sol.stats.Aoptimal)==5);
assert(isequal(cellfun('length', sol.stats.Aoptimal), [1 6 8 4 4]));
assert(isequal(cellfun('length', sol.stats.Afeasible), [1 14 68 140 4]));
assert(isequal(cellfun('length', sol.stats.Ainfeasible), [0 2 23 10 128]));
assert(sol.stats.nLPs==595);
assert(isa(sol.xopt.Set(1), 'Polyhedron')); % must be region-based

end

function check_primal(sol)
% checks correctness of the primal optimizer

Fexp{1}=[-0.51975 -0.93996;-0.0053364 -0.5294;0.13502 -0.28092;0.13785 -0.14078];
Fexp{2}=[2.2204e-16 -1.7764e-15;-0.51975 -1.4597;-0.0053364 -0.53474;0.13502 -0.1459];
Fexp{3}=[2.2204e-16 -1.7764e-15;-0.51975 -1.4597;-0.0053364 -0.53474;0.13502 -0.1459];
Fexp{4}=[-0.52242 -1.2046;4.2327e-16 -2.2204e-16;0.13307 -0.47413;0.13713 -0.21156];
Fexp{5}=[-0.52242 -1.2046;4.2327e-16 -2.2204e-16;0.13307 -0.47413;0.13713 -0.21156];
Fexp{6}=[-0.50199 -0.97692;0.042189 -0.62829;-4.4409e-16 -1.5543e-15;0.18527 -0.23946];
Fexp{7}=[-0.50199 -0.97692;0.042189 -0.62829;-4.4409e-16 -1.5543e-15;0.18527 -0.23946];
Fexp{8}=[-1.1102e-16 -1.8874e-15;2.0123e-16 -1.1102e-15;-0.51975 -1.9795;-0.0053364 -0.54008];
Fexp{9}=[-1.1102e-16 -1.5543e-15;-0.52242 -1.7271;-5.8287e-16 -1.4433e-15;0.13307 -0.34106];
Fexp{10}=[-1.1102e-16 -1.8874e-15;2.0123e-16 -1.1102e-15;-0.51975 -1.9795;-0.0053364 -0.54008];
Fexp{11}=[-1.1102e-16 -1.5543e-15;-0.52242 -1.7271;-5.8287e-16 -1.4433e-15;0.13307 -0.34106];
Fexp{12}=[-0.47546 -1.372;2.0817e-16 -1.1102e-15;-6.9389e-16 -1.5543e-15;0.19795 -0.42826];
Fexp{13}=[-0.47546 -1.372;2.0817e-16 -1.1102e-15;-6.9389e-16 -1.5543e-15;0.19795 -0.42826];
Fexp{14}=[-0.49166 -0.99027;0.095574 -0.69729;-6.6613e-16 -1.5543e-15;2.2204e-16 7.7716e-16];
Fexp{15}=[-0.49166 -0.99027;0.095574 -0.69729;-6.6613e-16 -1.5543e-15;2.2204e-16 7.7716e-16];
Fexp{16}=[-7.7716e-16 -3.2196e-15;7.8583e-16 -5.5511e-16;-6.6613e-16 -2.7756e-16;-0.51975 -2.4992];
Fexp{17}=[-7.7716e-16 -3.2196e-15;7.8583e-16 -5.5511e-16;-6.6613e-16 -2.7756e-16;-0.51975 -2.4992];
Fexp{18}=[-0.42412 -1.483;2.099e-16 -1.2212e-15;-6.3838e-16 -1.6098e-15;2.2204e-16 8.0491e-16];
Fexp{19}=[-0.42412 -1.483;2.099e-16 -1.2212e-15;-6.3838e-16 -1.6098e-15;2.2204e-16 8.0491e-16];
Fexp{20}=[-2.2204e-16 -5.5511e-16;6.4532e-16 -4.6629e-15;-4.4409e-16 -1.5543e-15;0 7.494e-16];
Fexp{21}=[-2.2204e-16 -5.5511e-16;6.4532e-16 -4.6629e-15;-4.4409e-16 -1.5543e-15;0 7.494e-16];
Fexp{22}=[-0.29375 -1.7062;2.8449e-16 -8.8818e-16;-4.996e-16 -1.3323e-15;4.4409e-16 9.7145e-16];
Fexp{23}=[-0.29375 -1.7062;2.8449e-16 -8.8818e-16;-4.996e-16 -1.3323e-15;4.4409e-16 9.7145e-16];
gexp{1}=[0;0;0;0];
gexp{2}=[1;-0.98973;-0.27004;-0.0054408];
gexp{3}=[-1;0.98973;0.27004;0.0054408];
gexp{4}=[-0.49997;1;-0.36496;-0.13369];
gexp{5}=[0.49997;-1;0.36496;0.13369];
gexp{6}=[-0.13157;-0.35199;1;-0.35128];
gexp{7}=[0.13157;0.35199;-1;0.35128];
gexp{8}=[1;1;-2.2393;-0.54275];
gexp{9}=[1;-0.62477;-1;0.26097];
gexp{10}=[-1;-1;2.2393;0.54275];
gexp{11}=[-1;0.62477;1;-0.26097];
gexp{12}=[-0.98165;1;1;-0.75755];
gexp{13}=[0.98165;-1;-1;0.75755];
gexp{14}=[-0.20689;-0.74136;1;1];
gexp{15}=[0.20689;0.74136;-1;-1];
gexp{16}=[1;1;1;-3.7488];
gexp{17}=[-1;-1;-1;3.7488];
gexp{18}=[-1.4375;1;1;1];
gexp{19}=[1.4375;-1;-1;-1];
gexp{20}=[1;1;1;1];
gexp{21}=[-1;-1;-1;-1];
gexp{22}=[-2.6839;1;1;1];
gexp{23}=[2.6839;-1;-1;-1];

matches = zeros(1, sol.xopt.Num);
for i = 1:sol.xopt.Num
    % the optimizers might be shuffled
    F = sol.xopt.Set(i).Functions('primal').F;
    g = sol.xopt.Set(i).Functions('primal').g;
    for j = 1:sol.xopt.Num
        if norm(F-Fexp{j})<1e-4 && norm(g-gexp{j})<1e-4
            matches(i) = matches(i)+j;
        end
    end
end
assert(isequal(sort(matches), 1:sol.xopt.Num)); 

end

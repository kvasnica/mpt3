function test_empccontroller_sim_01_pass
% stress-test EMPCController/simulate with a single optimizer and tie
% breaking

Double_Integrator
probStruct.norm = 1;
probStruct.N = 3;
model = mpt_import(sysStruct, probStruct);
E = EMPCController(model, probStruct.N);
assert(E.nr==50);

% here, evaluation of the tie-breaking function used to be horridly slow
x = [5; 1];
N_sim = 500;
t = clock;
d = E.simulate(x, N_sim);
etime(clock, t)

assert(isequal(size(d.X), [2 N_sim+1]));
assert(isequal(size(d.U), [1 N_sim]));
Xgood = [5 5 4.5 3.5 2 1 0 -0 -0 0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0;1 0.5 0 -0.5 -1 -1 -1 -0.5 -0.25 -0.125 -0.0625 -0.03125 -0.015625 -0.007812 -0.003906 -0.001953 -0.000977 -0.000488 -0.000244 -0.000122 -6.1e-05 -3.1e-05 -1.5e-05 -8e-06 -4e-06 -2e-06 -1e-06 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0];
Jgood = [22.5 19.5 15.5 11 7.5 5.25 3.625 1.8125 0.90625 0.453125 0.226562 0.113281 0.056641 0.02832 0.01416 0.00708 0.00354 0.00177 0.000885 0.000443 0.000221 0.000111 5.5e-05 2.8e-05 1.4e-05 7e-06 3e-06 2e-06 1e-06 0 0 0 0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0 -0];
assert(norm(d.X(:, 1:size(Xgood, 2))-Xgood)<=1e-5);
assert(norm(d.cost(:, 1:size(Jgood, 2))-Jgood)<=1e-5);

end

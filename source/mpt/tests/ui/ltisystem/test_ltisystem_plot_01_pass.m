function test_ltisystem_plot_01_pass
% tests LTISystem/plot

% just states and inputs, plot() should therefore open only 2 subplots
L = LTISystem('A', 0.9, 'B', 1);
L.x.min = -1; L.x.max = 1; L.u.min = -0.1; L.u.max = 0.1;
L.x.penalty = OneNormFunction(1); 
L.u.penalty = OneNormFunction(1);
M = MPCController(L, 5);

% cannot plot results prior to optimization
[worked, msg] = run_in_caller('M.model.plot();');
assert(~worked);
assert(~isempty(strfind(msg, 'Cannot plot signal which was not optimized.')));

M.evaluate(-1);
M.model.plot();

% three variables
L = LTISystem('A', 0.9, 'B', 1, 'C', 1);
L.x.min = -1; L.x.max = 1; L.u.min = -0.1; L.u.max = 0.1;
L.x.penalty = OneNormFunction(1); 
L.u.penalty = OneNormFunction(1);
M = MPCController(L, 5);
M.evaluate(-1);
figure; M.model.plot();

end

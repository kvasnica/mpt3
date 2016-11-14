function test_empccontroller_07_pass
% import from MPCController which doesn't have N defined should be nicely
% handled

% mplp/mplp
model = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
model.x.max = 5; model.x.min = -5;
model.u.max = 1; model.u.min = -1;
model.x.penalty = QuadFunction(1);
model.u.penalty = QuadFunction(1);
M = MPCController(model);

[worked, msg] = run_in_caller('E = EMPCController(M);');
assert(~worked);
assert(~isempty(findstr(msg, 'The prediction horizon must be specified.')));

end

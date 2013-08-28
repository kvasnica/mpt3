function test_mpccontroller_09_pass
% prediction horizon must be finite

model = LTISystem('A', 1, 'B', 0.1);

[~, msg] = run_in_caller('MPCController(model, Inf)');
asserterrmsg(msg, 'The prediction horizon must be finite.');

[~, msg] = run_in_caller('EMPCController(model, Inf)');
asserterrmsg(msg, 'The prediction horizon must be finite.');

end

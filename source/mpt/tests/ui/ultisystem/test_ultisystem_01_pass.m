function test_ultisystem_01_pass
% test the ULTISystem constructor with invalid inputs

% no uncertainty in E allowed
[~, msg] = run_in_caller('s = ULTISystem(''A'', 1, ''E'', {1, 2});');
asserterrmsg(msg, 'Input argument must be a real matrix.');

% no uncertainty in f allowed
[~, msg] = run_in_caller('s = ULTISystem(''A'', 1, ''f'', {1, 2});');
asserterrmsg(msg, 'Input argument must be a real matrix.');

% no uncertainty in g allowed
[~, msg] = run_in_caller('s = ULTISystem(''A'', 1, ''g'', {1, 2});');
asserterrmsg(msg, 'Input argument must be a real matrix.');

% incompatible row dimension of E
[~, msg] = run_in_caller('s = ULTISystem(''A'', 1, ''E'', [1; 2]);');
asserterrmsg(msg, '"E" must have 1 row(s).');

end
function test_ltisystem_12_pass
% wrong dimensions must be caught

% incompatible C matrix
[~, msg] = run_in_caller('L = LTISystem(''A'', eye(2), ''C'', 1);');
asserterrmsg(msg, 'The "C" matrix must have 2 columns.');

% incompatible B matrix
[~, msg] = run_in_caller('L = LTISystem(''A'', eye(2), ''B'', 1);');
asserterrmsg(msg, 'The "B" matrix must have 2 rows.');

% incompatible C/D matrix
[~, msg] = run_in_caller('L = LTISystem(''A'', eye(2), ''C'', [1 0], ''D'', [1;1]);');
asserterrmsg(msg, 'The "D" matrix must have 1 rows.');

% incompatible B/D matrix
[~, msg] = run_in_caller('L = LTISystem(''A'', eye(2), ''B'', [1;1], ''C'', [1 0], ''D'', [1 1]);');
asserterrmsg(msg, 'The "B" and "D" matrices must have the same number of columns.');

end

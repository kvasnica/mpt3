function test_afffunction_slice_01_pass
% tests AffFunction/slice()

F = [1 2 3; 4 5 6];
g = [7; 8];
fun = AffFunction(F, g);

% wrong inputs must be properly rejected
[~, msg] = run_in_caller('fun.slice()');
asserterrmsg(msg, 'Not enough input arguments.');
[~, msg] = run_in_caller('fun.slice(1)');
asserterrmsg(msg, 'Not enough input arguments.');

% dimensions are not valid
[~, msg] = run_in_caller('fun.slice(0, 1)');
asserterrmsg(msg, 'Input argument is a not valid dimension.');
[~, msg] = run_in_caller('fun.slice(4, 1)');
asserterrmsg(msg, 'Dimension must not exceed 3.');

end

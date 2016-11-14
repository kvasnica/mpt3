function test_quadfunction_slice_01_pass
% tests QuadFunction/slice()

H = randn(3);
F = [1 2 3];
g = [7];
fun = QuadFunction(H, F, g);

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

function test_polyhedron_fplot_02_pass
%
% polyhedron - two functions
%

P = ExamplePoly.randHrep;
L = AffFunction(rand(2),randn(2,1));
Q = QuadFunction(rand(2),randn(1,2),1);
P.addFunction(L, 'a');
P.addFunction(Q, 'b');

% multiple functions => error
[~, msg] = run_in_caller('P.fplot()');
asserterrmsg(msg, 'The object has multiple functions, specify the one to evaluate.');

% function name is not a string => error
[~, msg] = run_in_caller('P.fplot({''a''})');
asserterrmsg(msg, 'The function name must be a string.');

% position out of range
[~, msg] = run_in_caller('P.fplot(''b'', ''position'', 2)');
asserterrmsg(msg, 'The position index must be less than 2.');

% now correct syntax
P.fplot('a');
P.fplot('b');

close

end

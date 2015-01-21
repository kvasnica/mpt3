function test_polyhedron_slice_01_pass
%
% reject bogus cases
% 

% cannot slice an empty polyhedron
P = Polyhedron;
[~, msg] = run_in_caller('P.slice(1,[0.2 0.5])');
asserterrmsg(msg, 'Cannot slice empty polyhedra.');

% another empty set
P = Polyhedron([1; -1], [-1; 0]);
assert(P.isEmptySet);
assert(P.Dim==1);
[~, msg] = run_in_caller('P.slice(1,[0.2 0.5])');
asserterrmsg(msg, 'Cannot slice empty polyhedra.');

% dimensions must be correct
P = Polyhedron('lb', -1, 'ub', 1);
[~, msg] = run_in_caller('P.slice(0)');
asserterrmsg(msg, 'Input argument is a not valid dimension.');
[~, msg] = run_in_caller('P.slice(0.1)');
asserterrmsg(msg, 'Input argument is a not valid dimension.');
[~, msg] = run_in_caller('P.slice(2)');
asserterrmsg(msg, 'The second input cannot exceed dimension of the polyhedron.');

% more values than dimensions
P = Polyhedron('lb', [-1; -1; -1], 'ub', [1; 1; 1]);
[~, msg] = run_in_caller('P.slice([1 3], 0.1)');
asserterrmsg(msg, '"values" must be a vector with 2 element(s).');
[~, msg] = run_in_caller('P.slice([1], [0.1, 0.2])');
asserterrmsg(msg, '"values" must be a vector with 1 element(s).');

% less values than dimensions
[~, msg] = run_in_caller('P.slice([1 3], [0.1])');
asserterrmsg(msg, '"values" must be a vector with 2 element(s).');

% wrong options
P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
[~, msg] = run_in_caller('P.slice(1, 0, ''bogus'', 1)');
asserterrmsg(msg, 'Argument ''bogus'' did not match any valid parameter of the parser.', ...
    '''bogus'' is not a recognized parameter.');
[~, msg] = run_in_caller('P.slice(1, 0, ''keepDim'', ''yes'')');
asserterrmsg(msg, 'Argument ''keepDim'' failed validation islogical.', ...
    'The value of ''keepDim'' is invalid.');


end

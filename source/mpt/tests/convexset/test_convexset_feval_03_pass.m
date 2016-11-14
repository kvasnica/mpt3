function test_convexset_feval_03_pass
%
% polyhedron array
%

%% vector-valued function
clear P
P(1) = Polyhedron('lb',[-4;-4],'ub',[3,3]);
P(2) = Polyhedron('lb', [2; 2], 'ub', [5; 5]);
f1 = @(x) [x+1; x.^2+2];
f2 = @(x) [-x; x; x]; % more outputs than in f1
P(1).addFunction(f1, 'f');
P(2).addFunction(f2, 'f');

% the function is vector-valued, forEach must complain about non-scalar
% outputs
x = [0; 0];
[~, msg] = run_in_caller('f=P.forEach(@(e) e.feval(x));');
asserterrmsg(msg, 'Non-scalar in Uniform output, at index 1, output 1.');

% point in both sets
x = [2.5; 2.6];
[fval, feasible] = P.forEach(@(e) e.feval(x), 'UniformOutput', false);
assert(iscell(feasible));
assert(numel(feasible)==2);
assert(feasible{1});
assert(feasible{2});
assert(iscell(fval));
assert(numel(fval)==2);
assert(isequal(fval{1}, f1(x)));
assert(isequal(fval{2}, f2(x)));

% point in P(1)
x = [0.1; 0.2];
[fval, feasible] = P.forEach(@(e) e.feval(x), 'UniformOutput', false);
assert(iscell(feasible));
assert(numel(feasible)==2);
assert(feasible{1});
assert(~feasible{2});
assert(iscell(fval));
assert(numel(fval)==2);
assert(isequal(fval{1}, f1(x)));
assert(isequal(size(fval{2}), size(f2(x))));
assert(all(isnan(fval{2})));

% point in P(2)
x = [4; 4];
[fval, feasible] = P.forEach(@(e) e.feval(x), 'UniformOutput', false);
assert(iscell(feasible));
assert(numel(feasible)==2);
assert(~feasible{1});
assert(feasible{2});
assert(iscell(fval));
assert(numel(fval)==2);
assert(isequal(fval{2}, f2(x)));
assert(isequal(size(fval{1}), size(f1(x))));
assert(all(isnan(fval{1})));

% point in no set
x = [100; 100];
[fval, feasible] = P.forEach(@(e) e.feval(x), 'UniformOutput', false);
assert(iscell(feasible));
assert(numel(feasible)==2);
assert(~feasible{1});
assert(~feasible{2});
assert(iscell(fval));
assert(numel(fval)==2);
assert(isequal(size(fval{1}), size(f1(x))));
assert(isequal(size(fval{2}), size(f2(x))));
assert(all(isnan(fval{1})));
assert(all(isnan(fval{2})));


%% scalar-valued function
clear P
P(1) = Polyhedron('lb',[-4;-4],'ub',[3,3]);
P(2) = Polyhedron('lb', [2; 2], 'ub', [5; 5]);
f1 = @(x) 1.5;
f2 = @(x) x(1);
P(1).addFunction(f1, 'f');
P(2).addFunction(f2, 'f');

% point in both sets
x = [2.5; 2.6];
[fval, feasible] = P.forEach(@(e) e.feval(x));
assert(isequal(fval, [f1(x) f2(x)]));
assert(isequal(size(feasible), [1 2]));
assert(all(feasible));

% point in P(1)
x = [0.1; 0.2];
[fval, feasible] = P.forEach(@(e) e.feval(x));
assert(isequal(size(fval), [1 2]));
assert(fval(1)==f1(x));
assert(isnan(fval(2)));
assert(feasible(1));
assert(~feasible(2));

% point in P(2)
x = [4; 4];
[fval, feasible] = P.forEach(@(e) e.feval(x));
assert(isequal(size(fval), [1 2]));
assert(fval(2)==f2(x));
assert(isnan(fval(1)));
assert(feasible(2));
assert(~feasible(1));

% point in no set
x = [100; 100];
[fval, feasible] = P.forEach(@(e) e.feval(x));
assert(isequal(size(fval), [1 2]));
assert(all(isnan(fval)));
assert(isequal(size(feasible), [1 2]));
assert(~feasible(1));
assert(~feasible(2));


end

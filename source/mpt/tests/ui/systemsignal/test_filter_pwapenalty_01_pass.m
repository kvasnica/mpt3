function test_filter_pwapenalty_01_pass
% tests pwa penalties

% model abs(x) as a polyunion
P1 = Polyhedron('lb', 0);
P1.addFunction(AffFunction(1, 0), 'abs');
P1.addFunction(QuadFunction(1), 'quad');
P2 = Polyhedron('ub', 0);
P2.addFunction(AffFunction(-1, 0), 'abs');
P2.addFunction(QuadFunction(1), 'quad');
P = PolyUnion([P1 P2]);

% 2D signal
s = SystemSignal(2);
assert(~s.hasFilter('PWApenalty'));
s.with('PWApenalty');
assert(s.hasFilter('PWApenalty'));
p = s.PWApenalty;
assert(isstruct(p));
assert(isfield(p, 'step'));
assert(isfield(p, 'polyunion'));
assert(isfield(p, 'function'));
assert(isfield(p, 'isconvex'));

% wrong function (must be in 2D)
s.PWApenalty.step = 1;
s.PWApenalty.isconvex = true;
s.PWApenalty.function = 'abs';
s.PWApenalty.polyunion = P;
[~, msg] = run_in_caller('s.applyFilters(''instantiate'');');
asserterrmsg(msg, 'Function "abs" must map from R^2.');

% switch to 1D signal
s = SystemSignal(1);
s.with('PWApenalty');
s.PWApenalty.step = 1;
s.PWApenalty.isconvex = true;
s.PWApenalty.function = 'q';
s.PWApenalty.polyunion = P;

% function must exist
s.PWApenalty.function = 'bogus';
[~, msg] = run_in_caller('s.applyFilters(''instantiate'');');
asserterrmsg(msg, 'No such function "bogus" in the polyunion');

% function must be PWA
s.PWApenalty.function = 'quad';
[~, msg] = run_in_caller('s.applyFilters(''instantiate'');');
asserterrmsg(msg, 'The function "quad" must be PWA.');

% polyunion must be polyunion
s.PWApenalty.polyunion = P1;
[~, msg] = run_in_caller('s.applyFilters(''instantiate'');');
asserterrmsg(msg, 'The "polyunion" parameter must be a PolyUnion object.');

% isconvex must be a logical
s.PWApenalty.isconvex = 'yes';
[~, msg] = run_in_caller('s.applyFilters(''instantiate'');');
asserterrmsg(msg, 'The "isconvex" parameter must be a logical.');

end

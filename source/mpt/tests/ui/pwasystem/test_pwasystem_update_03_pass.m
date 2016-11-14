function test_pwasystem_update_03_pass
% PWASystem/update should nicely fail if the system was not initialized

D1 = Polyhedron('lb', [0; 0]);
D2 = Polyhedron('ub', [0; 0]);
sys = PWASystem('A', {1, 1}, 'B', {1, 1}, 'C', {1, 1}, 'D', {0, 0}, ...
	'f', {0, 0}, 'g', {0, 0}, 'domain', [D1 D2]);

[worked, msg] = run_in_caller('sys.update(1);');
assert(~worked);
assert(~isempty(strfind(msg, 'Internal state not set, use "sys.initialize(x0)".')));

% update() should work again after initialization
sys.initialize(4);
sys.update(1);
x = sys.getStates();
assert(x == 4+1);

end


function test_ltisystem_update_03_pass
% LTISystem/update should nicely fail if the system was not initialized

L = LTISystem('A', 1, 'B', 1);
[worked, msg] = run_in_caller('L.update(1);');
assert(~worked);
assert(~isempty(findstr(msg, 'Internal state not set, use "sys.initialize(x0)".')));

% update() should work again after initialization
L.initialize(4);
L.update(1);
x = L.getStates();
assert(x == 4+1);

end


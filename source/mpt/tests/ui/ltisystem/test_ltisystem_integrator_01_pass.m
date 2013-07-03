function test_ltisystem_integrator_01_pass

% cannot have yref and xref simultaneously
L = LTISystem('A', [1 1; 0.2 1], 'B', [1; 0.5], 'C', [1 0]);
L.x.penalty = QuadFunction(eye(2));
L.u.penalty = QuadFunction(1);
L.y.with('reference');
L.y.reference = 'free';
L.x.with('reference');
L.x.reference = 'free';
[~, msg] = run_in_caller('L.with(''integrator'');');
asserterrmsg(msg, 'Please remove either "x.reference" or "y.reference" filters.');

% either state or output tracking must be enabled
L = LTISystem('A', [1 1; 0.2 1], 'B', [1; 0.5], 'C', [1 0]);
L.x.penalty = QuadFunction(eye(2));
L.u.penalty = QuadFunction(1);
[~, msg] = run_in_caller('L.with(''integrator'');');
asserterrmsg(msg, 'Either state or input tracking must be enabled.');

% input tracking not allowed
L = LTISystem('A', [1 1; 0.2 1], 'B', [1; 0.5], 'C', [1 0]);
L.x.penalty = QuadFunction(eye(2));
L.u.penalty = QuadFunction(1);
L.u.with('reference');
L.u.reference = 'free';
[~, msg] = run_in_caller('L.with(''integrator'');');
asserterrmsg(msg, 'Please remove the "reference" filter from "u" first.');

end


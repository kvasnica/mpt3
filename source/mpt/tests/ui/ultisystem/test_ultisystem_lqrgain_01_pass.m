function test_ultisystem_lqrgain_01_pass
% tests ULTISystem/LQRGain with invalid inputs

% must have at least one control input
sys = ULTISystem('A', 1);
[~, msg] = run_in_caller('sys.LQRGain();');
asserterrmsg(msg, 'The system must have control inputs.');

% must have input/state quadratic penalties
sys = ULTISystem('A', 1, 'B', 1);
[~, msg] = run_in_caller('sys.LQRGain();');
asserterrmsg(msg, 'The state penalty must be a quadratic function.');
%
sys.x.penalty = AffFunction(1);
[~, msg] = run_in_caller('sys.LQRGain();');
asserterrmsg(msg, 'The state penalty must be a quadratic function.');
%
sys.x.penalty = QuadFunction(1);
[~, msg] = run_in_caller('sys.LQRGain();');
asserterrmsg(msg, 'The input penalty must be a quadratic function.');
%
sys.x.penalty = QuadFunction(1);
sys.u.penalty = AffFunction(1);
[~, msg] = run_in_caller('sys.LQRGain();');
asserterrmsg(msg, 'The input penalty must be a quadratic function.');

end
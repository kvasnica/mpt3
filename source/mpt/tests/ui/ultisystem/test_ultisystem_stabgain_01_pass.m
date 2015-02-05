function test_ultisystem_stabgain_01_pass
% tests ULTISystem/stabilizingGain with invalid inputs

% must have at least one control input
sys = ULTISystem('A', 1);
[~, msg] = run_in_caller('sys.stabilizingGain();');
asserterrmsg(msg, 'The system must have control inputs.');

end
function test_mptopt_colormap_01_pass
% issue 107

ops = mptopt();
ops.colormap = [1 0 0];
ops.colormap = [0 1 0];
ops.colormap = [0 0 1];

[~, msg] = run_in_caller('ops.colormap=[1.1 0 0]');
asserterrmsg(msg, 'mptopt: Colormap values must be within interval [0, 1].');
[~, msg] = run_in_caller('ops.colormap=[-0.1 0.2 0]');
asserterrmsg(msg, 'mptopt: Colormap values must be within interval [0, 1].');

end

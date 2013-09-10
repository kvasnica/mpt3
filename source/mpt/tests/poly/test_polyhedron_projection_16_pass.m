function test_polyhedron_projection_16_pass
% if method is given, it must be a correct string

P = Polyhedron.unitBox(2);

[~, msg] = run_in_caller('P.projection(1, 0)');
asserterrmsg(msg, 'Supported methods are "vrep", "fourier", and "mplp".');

[~, msg] = run_in_caller('P.projection(1, ''unknown'')');
asserterrmsg(msg, 'Supported methods are "vrep", "fourier", and "mplp".');

end

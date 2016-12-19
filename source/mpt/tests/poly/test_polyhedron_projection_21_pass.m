function test_polyhedron_projection_21_pass
% tests global settings of the projection method (issue #103)

% set non-existent default method
m = mptopt;
default = m.modules.geometry.sets.Polyhedron.projection.method;
cleanup = onCleanup(@() restore_settings(default));
m.modules.geometry.sets.Polyhedron.projection.method = 'unknown';

P = Polyhedron.unitBox(2);

% projection should hence fail
[~, msg] = run_in_caller('P.projection(2)');
asserterrmsg(msg, 'Supported methods are "vrep", "fourier", "ifourier", and "mplp".');

% also Polyhedron/plus must fail, since it calls projection()
[~, msg] = run_in_caller('P+P');
asserterrmsg(msg, 'Supported methods are "vrep", "fourier", "ifourier", and "mplp".');

function restore_settings(default)
% restore original settings
m = mptopt;
m.modules.geometry.sets.Polyhedron.projection.method = default;
end

end

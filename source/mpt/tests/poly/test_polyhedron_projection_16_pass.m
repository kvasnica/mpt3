function test_polyhedron_projection_16_pass
%
% wrong method
%

P = ExamplePoly.randHrep('d',7);

[worked, msg] = run_in_caller('R=P.projection([4;1],''banana''); ');
assert(~worked);
asserterrmsg(msg,'Supported methods are "vrep", "fourier", and "mplp".');

end
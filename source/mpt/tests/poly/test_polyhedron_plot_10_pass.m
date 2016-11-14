function test_polyhedron_plot_10_pass
%
% wrong marking
%


P = Polyhedron('He',randn(2,3));

[worked, msg] = run_in_caller('h=plot(P,''linestyle'',''a''); ');
assert(~worked);
asserterrmsg(msg,'Style of the line must be one of these "-", ":", "-.", "--", or "none".');


close all
end
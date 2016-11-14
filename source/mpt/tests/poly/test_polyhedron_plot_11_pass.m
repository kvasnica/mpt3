function test_polyhedron_plot_11_pass
%
% wrong color
%


P = ExamplePoly.randHrep;

[worked, msg] = run_in_caller('h=plot(P,''color'',''abc''); ');
assert(~worked);
asserterrmsg(msg,'Given color name is not in the list of supported colors.');


close all
end
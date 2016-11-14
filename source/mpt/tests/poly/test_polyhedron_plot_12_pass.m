function test_polyhedron_plot_12_pass
%
% wrong identifier
%


P = ExamplePoly.randHrep;

[worked, msg] = run_in_caller('h=plot(P,''wire'',''abc''); ');
assert(~worked);
asserterrmsg(msg,'Operands to the || and && operators must be convertible to logical scalar values.');


end
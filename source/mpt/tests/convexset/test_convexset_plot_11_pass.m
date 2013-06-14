function test_convexset_plot_11_pass
% dimensions above 3 must be rejected

P = [];
for d = 1:4
	P = [P Polyhedron('lb', -ones(d, 1), 'ub', ones(d, 1))];
end
[~, msg] = run_in_caller('plot(P)');
asserterrmsg(msg, 'Cannot plot sets in 4D and higher.');

[~, msg] = run_in_caller('plot(P(1:3), P)');
asserterrmsg(msg, 'Cannot plot sets in 4D and higher.');

[~, msg] = run_in_caller('plot(P(1:3), ''color'', ''b'', P(4))');
asserterrmsg(msg, 'Cannot plot sets in 4D and higher.');

end

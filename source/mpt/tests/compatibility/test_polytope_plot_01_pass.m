function test_polytope_plot_01_pass
% plot() must respect subplot (issue #121)

P = polytope([eye(2); -eye(2)], ones(4, 1));
close all
subplot(2, 1, 1); plot(P);
subplot(2, 1, 2); plot(P);
assert(numel(get(gcf, 'Children'))==2);
close all

end

function test_polyhedron_plot_16_pass
% hold must be switched off properly

P1 = Polyhedron.unitBox(2);
P2 = P1+[3; 3];
P3 = P1+[2;2];
P4 = P1+[-2;-2];

% two object should have been plotted
close all
plot([P1 P2]);
assert(numel(get(gca, 'Children'))==2);

% hold must have been switched off
assert(~ishold);

% plotting a new object should clear the previous plot
plot(P3); %, 'wire', false, 'linewidth', 2);
assert(numel(get(gca, 'Children'))==1);

% plotting a new object should clear the previous plot
plot(P4, 'wire', false, 'linewidth', 2);
assert(numel(get(gca, 'Children'))==1);

end

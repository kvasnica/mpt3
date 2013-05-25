function test_convexset_plot_09_pass
% plotting of 1D sets with positive lower bounds

lb = 1.1;
ub = 10.8;
x = sdpvar(1, 1); 
Y = YSet(x, [lb <= x <= ub]); 
h = Y.plot();
% check that a correct set was plotted
assert(isequal(get(h, 'XData'), [lb ub]));


x = sdpvar(1, 1);
Y = YSet(x, [ (x-4)^2 <= 1.5 ]);
h = Y.plot();
bounds = get(h, 'XData');
good = [2.77525512860841 5.22474487139159];
assert(norm(bounds-good, Inf)<1e-10);

end

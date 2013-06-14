function test_convexset_plot_10_pass
% plot(Yset, Polyhedron)

x = sdpvar(2, 1);
Y = YSet(x, [x'*x <= 1]);
P = Polyhedron('lb', [0.5; 0.5], 'ub', [1.5; 1.5]);
plot(P, Y);
close
plot(Y, P);
close

end

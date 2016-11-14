function test_union_plot_02_pass
% plot() must respect subplot (issue #121)

x = sdpvar(2, 1);
Y1 = YSet(x, [x'*x <= 1]);
Y2 = YSet(x, [0<=x<=1]);
U = Union(); U.add(Y1); U.add(Y2);

close all
for i = 1:3
    subplot(3, 1, i); U.plot();
end
assert(numel(get(gcf, 'Children'))==3);
close all

end

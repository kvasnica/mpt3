function test_union_fplot_03_pass
% fplot() must respect subplot (issue #121)

x = sdpvar(2, 1);
Y1 = YSet(x, [x'*x <= 1]);
Y2 = YSet(x, [0<=x<=1]);
Y3 = YSet(x, [x>=0; x'*x<=0.5]);
Y1.addFunction(QuadFunction(eye(2)), 'x');
Y2.addFunction(QuadFunction(-eye(2)), 'x');
Y3.addFunction(AffFunction([1 1]), 'x');
U = Union(); U.add(Y1); U.add(Y2); U.add(Y3);

close all
for i = 1:2
    subplot(2, 1, i); U.fplot();
end
assert(numel(get(gcf, 'Children'))==2);
close all

end

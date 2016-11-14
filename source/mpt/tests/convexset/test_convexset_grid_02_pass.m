function test_convexset_grid_02_pass
%
% 1D sets
%

x = sdpvar(1);
F1 = (0<=x<=3);
F2 = [x<=1; 0.3*x^2 <= 0.5];

Y1 = YSet(x,F1);
Y2 = YSet(x,F2);

Y = [Y1;Y2];

% arrays must be rejected
[~, msg] = run_in_caller('x = Y.grid(10);');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

% individual elements must work
g1=Y(1).grid(10);
g2=Y(2).grid(3);

end


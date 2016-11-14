function test_convexset_grid_03_pass
%
% two 2D sets
% 

x = sdpvar(2,1);
F1 = [x(1)<=1; x(2)>=1; 0.3*x'*x <= 0.5];
F2 = [[9.1,-4.5]*x<=0; 0.1*x'*x <= 0.4];

Y1 = YSet(x,F1);
Y2 = YSet(x,F2);
Y=[Y1;Y2];

% arrays must be rejected
[~, msg] = run_in_caller('x = Y.grid(10);');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

% individual elements must work
g1=Y(1).grid(10);
g2=Y(2).grid(3);

end


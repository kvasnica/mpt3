function test_opt_10_fail
% problem contains lower bound that is actually bigger than upper bound

% simple lower and upper bounds
lb = [1, 2, 3, 4, 5];
ub = [2, 3, 2, 10, 10];

% inequality matrix
A = randn(5);
b = randn(5,1);

% cost function
f = randn(5,1);

% call to Opt must throw an error
Opt('A',A,'b',b,'f',f,'lb',lb,'ub',ub);

end
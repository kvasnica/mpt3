function test_yset_19_pass
%
% dimensions do not match
%

x = sdpvar(15,1);

F = (x<=1);
G = ( randn(3,15)*x==0 );


[worked, msg] = run_in_caller('YSet(x(3:4),[F;G]); ');
assert(~worked);
asserterrmsg(msg,'Dimension mismatch between the provided variables and the variables in the constraint set.');

end

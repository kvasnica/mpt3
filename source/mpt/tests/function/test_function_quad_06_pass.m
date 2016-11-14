function test_function_quad_06_pass
%
% vector valued (rejected for now)
%

[~, msg] = run_in_caller('F=QuadFunction(rand(2,2,3),rand(3,2),rand(3,1))');
asserterrmsg(msg, 'Input argument must be a real matrix.');

end

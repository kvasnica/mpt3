function test_function_quad_07_pass
%
% vector valued, one argument (rejected for now)
%

[~, msg] = run_in_caller('F=QuadFunction(rand(2,2,3))');
asserterrmsg(msg, 'Input argument must be a real matrix.');

end

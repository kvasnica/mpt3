function test_function_vertcat_03_pass
%
% vector concatenation 
%

F = Function;
G(2) = Function;
H=[F;[];G'];

if size(H,1)~=3
    error('Wrong number of elements.');
end

end
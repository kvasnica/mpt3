function test_function_vertcat_02_pass
%
% classic concatenation
%

F(2) = Function;
G(2) = Function;
H=[F;G];

if size(H,1)~=4
    error('Wrong number of elements.');
end

end
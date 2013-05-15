function test_function_horzcat_03_pass
%
% matrix concatenation 
%

F = Function;
G(2) = Function;
H=[F,[];G];

if size(H,1)~=3
    error('Wrong number of elements.');
end

end
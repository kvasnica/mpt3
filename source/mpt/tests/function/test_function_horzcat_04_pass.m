function test_function_horzcat_04_pass
%
% very long concatenation 
%

F = Function;
G(2) = Function;
H=[F;[];[G,F];F];

if size(H,1)~=5
    error('Wrong number of elements.');
end

end
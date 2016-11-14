function test_function_setHandle_03_pass
%
% handles in a loop
%

F(3) = Function;

for i=1:3
    F(i).setHandle(@(x)x*i);
end
    
end
function test_function_09_pass
%
% loop assignment to an array 
%

F(5) = Function;

for i=1:5
    F(i).Data = struct('a',1.5*i,'b',0.4,'c',-3.4);
    F(i).setHandle(@(x,y,z)(F(i).Data.a*x-y)*(F(i).Data.b/((z+F(i).Data.c)^2)+1));
end
    
for i=1:5
    feval(F(i).Handle,31,2,3);
end

end
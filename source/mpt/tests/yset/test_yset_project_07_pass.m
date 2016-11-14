function test_yset_project_07_pass
%
% lifting, array, unbounded polyhedron 
%

x = sdpvar(2,1);
F = [-5 <= x(1) <= 5,x(2) == -(x(1)-2).^2];

Y = YSet(x,F);

A = [ 0.17013      0.95251
      0.17392      0.94859
       0.4106     0.019617
      0.43977      0.64434
      0.99417      0.14072];
b = [  2.3939
       4.2304
       4.4504
       4.7486
       6.0834];
G = ( A*x<=b );
S = [Y; YSet(x,G)];

% the origin does not lie in S(1), but in S(2) 
z = [0;0];

s = S.forEach(@(e) e.project(z));

if norm(s(1).dist-1.3577,Inf)>1e-4
    error('Wrong distance.');
end

if norm(s(2).dist)>1e-4
    error('The distance should be 0 because the point is inside.');
end


end

function test_polyhedron_contains_13_pass
%
% H-x in 3D
%

P = Polyhedron('H',[
      -17.327       30.645       12.538       2.6148
      -15.075      -13.625      -4.9815       4.3217
       10.228      -40.514      -3.2896       4.8728
       27.585       -3.065      -8.0241       3.8631
       11.819      -10.858      -19.459       4.2734
       8.8882      -13.515      -51.293       3.4727
      -3.7839      -6.5878      -19.141        3.489
       25.785      -4.5828      -6.4386       2.6319
      -6.7987      -10.647       21.119    0.0078833],...
      'He',[randn(2,3), [0;0]]);

B=P.outerApprox;

% point to check
x = 0.5*B.Internal.lb+0.5*B.Internal.ub;

% S must be contained in both P
if ~P.contains(x)
    error('All points must lie in P.')
end


end
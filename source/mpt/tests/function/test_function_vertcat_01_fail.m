function test_function_vertcat_01_fail
%
% only the same objects can concatenated
%

F = Function;
L = AffFunction(1,1);

[F;L];

end
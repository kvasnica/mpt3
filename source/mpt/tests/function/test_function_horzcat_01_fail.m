function test_function_horzcat_01_fail
%
% only the same objects can concatenated
%

F = Function;
L = AffFunction(1,1);

[F,L];

end
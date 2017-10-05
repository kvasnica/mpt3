function test_convexset_02_pass
%
% constructing convex set directly is not possible
%

[worked, msg] = run_in_caller('a=ConvexSet(1);');
assert(~worked);
matver = version('-release');
if str2double(matver(1:4))<2016
    % R2015b and prior:
    asserterrmsg(msg,'Abstract classes cannot be instantiated.');
else
    % R2016a and newer:
    asserterrmsg(msg,'Too many input arguments');
end

end


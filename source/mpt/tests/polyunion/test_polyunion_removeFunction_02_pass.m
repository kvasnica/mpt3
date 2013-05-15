function test_polyunion_removeFunction_02_pass
%
% no function
%

U = PolyUnion(ExamplePoly.randHrep);

U.removeFunction([]);

end

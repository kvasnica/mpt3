function test_convexset_removeallfunctions_03_pass
%
% no function present
% 

P = ExamplePoly.randVrep('d',5);
assert(isempty(P.Functions));

P.removeAllFunctions;
assert(isempty(P.Functions));

end

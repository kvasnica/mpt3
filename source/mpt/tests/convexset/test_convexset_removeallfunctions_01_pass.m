function test_convexset_removeallfunctions_01_pass
%
% remove all functions
% 

P = ExamplePoly.randHrep;
P.addFunction(AffFunction([1,2],1),'a');
P.addFunction(AffFunction([1,2],-1),'b');

P.removeAllFunctions;

assert(isempty(P.listFunctions));


end

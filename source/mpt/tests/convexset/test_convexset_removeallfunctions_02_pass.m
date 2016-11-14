function test_convexset_removeallfunctions_02_pass
%
% remove all functions, array
% 

P(1) = ExamplePoly.randHrep;
P(1).addFunction(AffFunction([1,2],1),'a');
P(1).addFunction(AffFunction([1,2],-1),'b');

P(2) = ExamplePoly.randHrep('d',1);
P(2).addFunction(QuadFunction(1,1), 'c');

P.removeAllFunctions;

for i=1:2
	assert(isempty(P(i).Functions));
end


end

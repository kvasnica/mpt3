function test_polyunion_feval_04_pass
%
% different function names
%

P(1) = ExamplePoly.randVrep('d',4);
P(2) = ExamplePoly.randVrep('d',4);

P(1).addFunction(AffFunction(rand(1,4)),'a');
P(1).addFunction(Function(@(x)norm(x)), 'b');
P(2).addFunction(Function(@(x)x.^2-0.1*x),'anonymous');
P(2).addFunction(Function(@(x)x), 'c');


[worked, msg] = run_in_caller('U = PolyUnion(''Set'',P,''FullDim'',true,''Bounded'',true);');
assert(~worked);
asserterrmsg(msg,'All sets must have associated the same number of functions.');

end

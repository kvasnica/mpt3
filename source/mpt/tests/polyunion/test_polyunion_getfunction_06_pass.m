function test_polyunion_getfunction_06_pass
%
% random polyhedra, no matching string
%

for i=1:5
    P(i) = ExamplePoly.randVrep('d',6);
    P(i).addFunction(AffFunction(randn(2,6),[1;2]),'function1');
    P(i).addFunction(AffFunction(randn(2,6),[-1;-2]),'function2');
end
    
U = PolyUnion('Set',P,'Overlaps',true);

[worked, msg] = run_in_caller('Un = U.getFunction(''func''); ');
assert(~worked);
asserterrmsg(msg,'No such function "func" in the object.');

end
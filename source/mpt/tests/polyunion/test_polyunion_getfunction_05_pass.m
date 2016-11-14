function test_polyunion_getfunction_05_pass
%
% random polyhedra, no functions
%

for i=1:5
    P(i) = ExamplePoly.randVrep('d',6);
end
    
U = PolyUnion('Set',P,'Overlaps',true,'Bounded',true);

[worked, msg] = run_in_caller('Un = U.getFunction(1); ');
assert(~worked);
asserterrmsg(msg,'No such function "" in the object.');

end
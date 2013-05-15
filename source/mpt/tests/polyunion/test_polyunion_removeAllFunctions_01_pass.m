function test_polyunion_removeAllFunctions_01_pass
%
% arrays of polyunions
%

for i=1:5
    P(i) = ExamplePoly.randHrep;
    P(i).addFunction(AffFunction(randn(1,2),rand(1)), 'a');
    P(i).addFunction(AffFunction(randn(1,2),rand(1)),'b');
    Q(i) = ExamplePoly.randHrep;
    Q(i).addFunction(QuadFunction(randn(2),rand(1,2)),'a');
    Q(i).addFunction(AffFunction(randn(1,2),rand(1)),'b');
end
U(1) = PolyUnion('Set',P,'Overlaps',true);
U(2) = PolyUnion('Set',Q,'Convex',false,'FullDim',true);

Un = U.copy;
U.removeAllFunctions;

for i=1:2
   if numel(U(i).listFunctions)~=0
       error('No functions here.');
   end
   if numel(Un(i).listFunctions)==0
       error('Here must be 2 functions.');
   end
    
end

end

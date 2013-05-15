function test_polyunion_removeFunction_04_pass
%
% arrays of polyunions
%

for i=1:5
    P(i) = ExamplePoly.randHrep;
    P(i).addFunction(AffFunction(randn(1,2),rand(1)), 'a');
    P(i).addFunction(AffFunction(randn(1,2),rand(1)),'b');
    Q(i) = ExamplePoly.randHrep;
    Q(i).addFunction(QuadFunction(randn(2),rand(1,2)),'c');
end
U(1) = PolyUnion('Set',P,'Overlaps',true);
U(2) = PolyUnion('Set',Q,'Convex',false,'FullDim',true);

U.removeFunction({'a', 'b'});

s1 = U(1).listFunctions;
if numel(s1)~=0
    error('Wrong number of functions.');
end

s2 = U(2).listFunctions;
if numel(s2)~=1
    error('Wrong number of functions.');
end


end

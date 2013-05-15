function test_polyunion_removeAllFunctions_02_pass
%
% empty polyunions
%

for i=1:5
    P(i) = ExamplePoly.randHrep;
    P(i).addFunction(AffFunction(randn(1,2),rand(1)), 'a');
    P(i).addFunction(AffFunction(randn(1,2),rand(1)),'b');
end
U(1) = PolyUnion;
U(2) = PolyUnion('Set',P,'Overlaps',true);
U.removeAllFunctions;

for i=1:2
    if numel(U(i).listFunctions)~=0
        error('No functions here.');
    end
end
end

function test_polyunion_eq_05_pass
%
% polyunion arrays, and one polyunion
%

P = 7*ExamplePoly.randVrep('d',2);

T = P.triangulate;

U(1) = PolyUnion(T(1:floor(numel(T)/2)));
U(2) = PolyUnion('Set',T,'Convex',true,'FullDim',true,'Bounded',true,'Overlaps',false)  ;

ts = (U == PolyUnion(P));

if ts(1) || ~ts(2)
    error('The first is not equal, the second is.');
end


end
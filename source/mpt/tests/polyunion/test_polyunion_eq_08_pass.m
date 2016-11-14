function test_polyunion_eq_08_pass
%
% polyunion arrays, and two polyunions
%

P = 7*ExamplePoly.randVrep('d',3);

T = P.triangulate;

U(1) = PolyUnion(T(1:floor(numel(T)/2)));
U(2) = PolyUnion('Set',T,'Convex',true,'FullDim',true,'Bounded',true,'Overlaps',false)  ;

Un(1,1) = PolyUnion(P);
Un(2,1) = PolyUnion(T(1:3));

[worked, msg] = run_in_caller('ts = (U == Un); ');
assert(~worked);
asserterrmsg(msg,'Only single "PolyUnion" object can be tested for equality.');


end
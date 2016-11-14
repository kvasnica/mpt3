function test_polyunion_le_02_pass
% containement of unions where one union contains a single element

A = [1 -4.0217906504221;-1 2.62705876174804;-6.2534305158641 -1;-1 1.45242644876337;-1.30946115541203 -1;1 1.40715050811825;1.47339887063666 1;1 -2.79419884295457];
b = [7.07226001300678;4.0036849865292;7.78526230532414;2.45589255025793;2.48316663227603;2.38448288335533;2.54399261228781;5.50226104343264];
P = Polyhedron(A, b);
T = P.triangulate;
assert(length(T)==6);

assert(PolyUnion(P)<=PolyUnion(T));
assert(PolyUnion(T)<=PolyUnion(P));

% test 1-, 2-, and so on touples
for i = 1:length(T)
	combs = nchoosek(1:length(T), i);
	for j = 1:size(combs, 1)
		assert(PolyUnion(T(combs(j, :))) <= PolyUnion(P));
	end
end

% P is for sure not contained in elements of T
for i = 1:length(T)-1
	combs = nchoosek(1:length(T), i);
	for j = 1:size(combs, 1)
		assert(~(PolyUnion(P) <= PolyUnion(T(combs(j, :)))));
	end
end

% now add an element which lies in bounding box of T
Z = Polyhedron('lb', [0.8; 1.2], 'ub', [1; 1.4]);
assert(~(PolyUnion([T Z])<=PolyUnion(P)));

end

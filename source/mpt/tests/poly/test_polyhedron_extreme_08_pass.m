function test_polyhedron_extreme_08_pass
%
% redundancy elimination on random data
%

V = randn(43,4);  
P = Polyhedron('V',V,'R',[0 -1 0.2 3]);

P.minHRep();
R = Polyhedron('H',P.H,'He',P.He);

s1 = P.minVRep();
s2 = R.minVRep();

if P~=R
    error('P is the same as R.')
end

end

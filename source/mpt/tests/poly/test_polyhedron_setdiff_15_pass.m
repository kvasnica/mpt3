function test_polyhedron_setdiff_15_pass
%
% no [] at the output 
%


H1 = [   -1.0000   -0.0000    5.0000
    1.0000    3.0000    9.5000
    1.0000    1.0000    1.0000
   -1.0000   -2.0000   -2.5000];
H2 = [    -1.0000         0    5.0000
         0    1.0000    5.0000
    1.0000    1.0000    1.0000
   -1.0000   -2.0000   -2.5000];

P1 = Polyhedron('H', H1);
P2 = Polyhedron('H', H2);
res = P1\P2;

if isempty(res)
    error('The output must be polyhedron.');
end
if ~isEmptySet(res)
    error('The output is empty set.');
end

end
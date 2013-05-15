function test_polyhedron_eq_13_pass
% tests lowdim==fulldim

% these two are for sure not equal
P=Polyhedron('V', [0 0; 0 1; 1 2; 1 1]);
Q1=Polyhedron('V',[0 0; 0 1]);
Q2=Polyhedron('V',[1 0; 0 2]);

assert(~([P Q1]==[P Q2]));
assert([P Q1]~=[P Q2]);

end

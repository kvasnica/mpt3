function test_convexset_addfunction_06_pass
%
% add a function to a polyhedral array
%


R(1) = Polyhedron(randn(5),rand(5,1));
R(2) = Polyhedron(randn(5),rand(5,1));
R(3) = Polyhedron(randn(5),rand(5,1));
R.addFunction(@(x) x, 'f');
for i = 1:numel(R)
	assert(R(i).hasFunction('f'));
end

end

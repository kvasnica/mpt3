function test_convexset_addfunction_07_pass
%
% polyhedral array, one affine, one quadratic function
%

R(1) = Polyhedron(randn(5),rand(5,1));
R(2) = Polyhedron(randn(5),rand(5,1));
R.addFunction(AffFunction([1 2 3 -4 0],-0.005), 'aff');
R.addFunction(QuadFunction(-5*eye(5),0.5*ones(1,5),0.001),'quad');
for i = 1:numel(R)
	assert(R(i).hasFunction('aff'));
	assert(R(i).hasFunction('quad'));
end

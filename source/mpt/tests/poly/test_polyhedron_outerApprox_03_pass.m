function test_polyhedron_outerApprox_03_pass

% outerApprox for arrays should work element-wise
V = randn(10, 3);
lb{1} = min(V', [], 2);
ub{1} = max(V', [], 2);
A = [1; -1]; b = [2; 3];
lb{2} = -3; 
ub{2} = 2;

% first with no outputs
P1 = Polyhedron(V);
P2 = Polyhedron(A, b);
Q = [P1 P2];
Q.outerApprox;
for i = 1:length(Q)
	assert(isfield(Q(i).Internal, 'lb'));
	assert(isfield(Q(i).Internal, 'ub'));
	assert(norm(Q(i).Internal.lb-lb{i}, 1)<1e-8);
	assert(norm(Q(i).Internal.ub-ub{i}, 1)<1e-8);
end

% now asking for the bounding box
P1 = Polyhedron(V);
P2 = Polyhedron(A, b);
Q = [P1 P2];
B=Q.outerApprox;
assert(isa(B, 'Polyhedron'));
assert(length(B)==length(Q));
for i = 1:length(Q)
	assert(isfield(Q(i).Internal, 'lb'));
	assert(isfield(Q(i).Internal, 'ub'));
	assert(norm(Q(i).Internal.lb-lb{i}, 1)<1e-8);
	assert(norm(Q(i).Internal.ub-ub{i}, 1)<1e-8);
	assert(isfield(B(i).Internal, 'lb'));
	assert(isfield(B(i).Internal, 'ub'));
	assert(norm(B(i).Internal.lb-lb{i}, 1)<1e-8);
	assert(norm(B(i).Internal.ub-ub{i}, 1)<1e-8);
	Bcorrect = Polyhedron('lb', lb{i}, 'ub', ub{i});
	assert(B(i)==Bcorrect)
end

end

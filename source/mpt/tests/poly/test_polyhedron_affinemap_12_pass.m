function test_polyhedron_affinemap_12_pass
% affine map of R^n

R = Polyhedron.fullSpace(2);

%% non-zero maps
M = 1;
Q = M*R;
assert(~Q.isEmptySet);
assert(Q.isFullSpace);
assert(Q.Dim==R.Dim);
assert(Q.isFullDim);
assert(~Q.isBounded);

M = [1 1];
Q = M*R;
assert(~Q.isEmptySet);
assert(Q.isFullSpace);
assert(Q.isFullDim);
assert(~Q.isBounded);
assert(Q.Dim==size(M, 1));

M = [1 1; 2 3];
Q = M*R;
assert(~Q.isEmptySet);
assert(Q.isFullSpace);
assert(Q.isFullDim);
assert(~Q.isBounded);
assert(Q.Dim==size(M, 1));

M = [1 1; 2 3; 4 5]; % non-full-dimensional lifting
Q = M*R;
assert(~Q.isFullSpace);
assert(~Q.isFullDim);
assert(~Q.isEmptySet);
assert(~Q.isBounded);
assert(Q.Dim==size(M, 1));

%% zero maps
M = [0 0];
Q = M*R;
assert(~Q.isEmptySet);
assert(~Q.isFullDim);
assert(Q.Dim==size(M, 1));
assert(Q.contains(zeros(1, 1)));
assert(~Q.contains(zeros(1,1)+1e-4));

M = zeros(2);
Q = M*R;
assert(~Q.isEmptySet);
assert(~Q.isFullDim);
assert(Q.Dim==size(M, 1));
assert(Q.contains(zeros(2, 1)));
assert(~Q.contains(zeros(2,1)+1e-4));

M = zeros(3, 2);
Q = M*R;
assert(~Q.isEmptySet);
assert(~Q.isFullDim);
assert(Q.Dim==size(M, 1));
assert(Q.contains(zeros(3, 1)));
assert(~Q.contains(zeros(3,1)+1e-4));

M = 0;
Q = M*R; % Q = { 0*x | x \in R^n } = { 0 }
assert(~Q.isEmptySet);
assert(~Q.isFullDim);
assert(Q.Dim==R.Dim);
assert(Q.contains(zeros(2, 1))); % must contain zero
assert(~Q.contains(zeros(2,1)+1e-4)); % and only zero

end

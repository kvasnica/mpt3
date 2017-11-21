function test_polyhedron_interpolate_01
% tests for Polyhedron/interpolate()

P = Polyhedron.unitBox(2);
nv = size(P.V, 1);

% interpolate scalar values at vertices
g = 1:nv;
gi = P.interpolate(g);
assert(isa(gi, 'function_handle'));
X = [P.V; 0 0];
Zexp = [1 2 3 4 2.5];
for i = 1:size(X, 1)
    x0 = X(i, :)';
    zi = gi(x0);
    assert(abs(zi-Zexp(i))<1e-5);
end

% interpolate vector values at vertices
g = [1:nv; nv-1:-1:0];
gi = P.interpolate(g);
assert(isa(gi, 'function_handle'));
X = [P.V; 0 0];
Zexp = [g [2.5; 1.5]];
for i = 1:size(X, 1)
    x0 = X(i, :)';
    zi = gi(x0);
    assert(norm(zi-Zexp(:, i), Inf)<1e-5);
end

% interpolate scalar functions at vertices
g = { @(R) R, @(R) 2*R, @(R) 3*R, @(R) 4*R };
gi = P.interpolate(g);
assert(isa(gi, 'function_handle'));
X = [P.V; 0 0];
R = 3;
Zexp = [g{1}(R), g{2}(R), g{3}(R), g{4}(R), 7.5];
for i = 1:size(X, 1)
    x0 = X(i, :)';
    zi = gi(x0, R);
    assert(norm(zi-Zexp(:, i), Inf)<1e-5);
end

% interpolate vector functions (1 input) at vertices
g = { @(R) [R; 1], @(R) [2*R; 2], @(R) [3*R; R-1], @(R) [4*R; R^2] };
gi = P.interpolate(g);
assert(isa(gi, 'function_handle'));
X = [P.V; 0 0];
R = 3;
Zexp = [g{1}(R), g{2}(R), g{3}(R), g{4}(R), [7.5; 3.5]];
for i = 1:size(X, 1)
    x0 = X(i, :)';
    zi = gi(x0, R);
    assert(norm(zi-Zexp(:, i), Inf)<1e-5);
end

% interpolate vector functions (2 inputs) at vertices
g = { @(R, Q) [R; Q], @(R, Q) [2*R; -Q], @(R, Q) [3*R; Q*R-1], @(R, Q) [4*R; Q-R^2] };
gi = P.interpolate(g);
assert(isa(gi, 'function_handle'));
X = [P.V; 0 0];
R = 3; Q = 5;
Zexp = [g{1}(R, Q), g{2}(R, Q), g{3}(R, Q), g{4}(R, Q), [7.5; 2.5]];
for i = 1:size(X, 1)
    x0 = X(i, :)';
    zi = gi(x0, R, Q);
    assert(norm(zi-Zexp(:, i), Inf)<1e-4);
end

end

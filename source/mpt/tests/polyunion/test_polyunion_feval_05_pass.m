function test_polyunion_feval_05_pass
%
% array of polyunion
%

Q = Polyhedron('lb', 0.5, 'ub', 2);
fq = [1; 1];
Q.addFunction(AffFunction(fq), 'affine');
Q.addFunction(QuadFunction(1), 'quad');
U1 = PolyUnion(Q);

P1 = Polyhedron('lb', -1, 'ub', 0.5);
fp1 = [2; 1];
P1.addFunction(AffFunction(fp1), 'affine');
P1.addFunction(QuadFunction(1,0,1), 'quad');
P2 = Polyhedron('lb', 0, 'ub', 1);
fp2 = [1; 2];
P2.addFunction(AffFunction(fp2), 'affine');
P2.addFunction(QuadFunction(1,0,-1), 'quad');
U2 = PolyUnion([P1, P2]);

U = [U1, U2];

% x not in Q, P1, P2
x = 10;
[f, feas, idx, tb] = U.feval(x, 'affine');
assert(~feas);
assert(isequal(size(f), [2 1]));
assert(all(isnan(f)));
assert(isempty(idx));
assert(isempty(tb));

% x in Q, P1, P2, no tiebreak
x = 0.5;
[f, feas, idx, tb] = U.feval(x, 'affine');
assert(feas);
assert(norm(f-[fq*x, fp1*x, fp2*x])<1e-8);
assert(isequal(idx, [1 1; 2 1; 2 2]'));
assert(isempty(tb));

% x in Q, P2, no tiebreak
x = 0.7;
[f, feas, idx, tb] = U.feval(x, 'affine');
assert(feas);
assert(norm(f-[fq*x, fp2*x])<1e-8);
assert(isequal(idx, [1 1; 2 2]'));
assert(isempty(tb));

% x in Q, no tiebreak
x = 1.7;
[f, feas, idx, tb] = U.feval(x, 'affine');
assert(feas);
assert(norm(f-fq*x)<1e-8);
assert(isequal(idx, [1; 1]));
assert(isempty(tb));

% x in Q, P1, P2, first-region tiebreak
x = 0.5;
[f, feas, idx, tb] = U.feval(x, 'affine', 'tiebreak', @(x) 0);
assert(feas);
assert(norm(f-fq*x)<1e-8);
assert(isequal(idx, [1; 1]));
assert(norm(tb)<1e-8);

% x in Q, P1, P2, quadratic tiebreak
x = 0.5;
[f, feas, idx, tb] = U.feval(x, 'affine', 'tiebreak', 'quad');
assert(feas);
assert(norm(f-fp2*x)<1e-8);
assert(isequal(idx, [2; 2]));
assert(norm(-0.75-tb)<1e-8);

% x in Q, P2, first-region tiebreak
x = 0.7;
[f, feas, idx, tb] = U.feval(x, 'affine', 'tiebreak', @(x) 0);
assert(feas);
assert(norm(f-fq*x)<1e-8);
assert(isequal(idx, [1; 1]));
assert(norm(tb)<1e-8);

% x in Q, P2, quadratic tiebreak
x = 0.7;
[f, feas, idx, tb] = U.feval(x, 'affine', 'tiebreak', 'quad');
assert(feas);
assert(norm(f-fp2*x)<1e-8);
assert(isequal(idx, [2; 2]));
assert(norm(-0.51-tb)<1e-8);

end

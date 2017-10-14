function test_enum_pqp_07
% tests IPDPolyUnion/toMatlab

m = mptopt;
pqp_solver = m.pqpsolver;
c = onCleanup(@() cleanme(pqp_solver));
mptopt('pqpsolver', 'rlenumpqp');

Double_Integrator
ctrl = mpt_control(sysStruct, probStruct);
ctrl_orig = ctrl.copy();
assert(ctrl.optimizer.Num==25);
assert(isa(ctrl.optimizer, 'IPDPolyUnion'));

%% the primal optimizer must be U
ctrl = ctrl_orig.copy();
for i = 1:ctrl.optimizer.Num
    assert(size(ctrl.optimizer.Set(i).Functions('primal').F, 1)==probStruct.N);
end
assert(isa(ctrl.optimizer, 'IPDPolyUnion'));

% %% IPDPolyhedron must not been converted to Polyhedron
% ctrl = ctrl_orig.copy();
% for i = 1:ctrl.optimizer.Num
%     assert(~isfield(ctrl.optimizer.Set(i).Internal, 'Polyhedron'));
% end
%% toMatlab - untrimmed
!rm -f myipd.m
assert(isempty(dir('myipd.m')));
toMatlab(ctrl.optimizer, 'myipd.m', 'primal');
rehash
assert(length(dir('myipd.m'))==1); % the file was created
for i = 1:ctrl.optimizer.Num
    ch=ctrl.optimizer.Set(i).toPolyhedron().chebyCenter;
    u = ctrl.optimizer.feval(ch.x, 'primal');
    [z, r] = myipd(ch.x);
    assert(isequal(size(z), [ctrl.N ctrl.model.nu]));
    assert(r==i);
    assert(norm(z-u)<1e-8);
end

%% must be able to trim the primal optimizer
ctrl = ctrl_orig.copy();
ctrl.optimizer.trimFunction('primal', 1);
for i = 1:ctrl.optimizer.Num
    assert(size(ctrl.optimizer.Set(i).Functions('primal').F, 1)==1);
end
assert(isa(ctrl.optimizer, 'IPDPolyUnion'));
%% toMatlab - trimmed
!rm -f myipd.m
assert(isempty(dir('myipd.m')));
toMatlab(ctrl.optimizer, 'myipd.m', 'primal');
rehash
assert(length(dir('myipd.m'))==1); % the file was created
for i = 1:ctrl.optimizer.Num
    ch=ctrl.optimizer.Set(i).toPolyhedron().chebyCenter;
    u = ctrl.optimizer.feval(ch.x, 'primal');
    [z, r] = myipd(ch.x);
    assert(isequal(size(z), [1 ctrl.model.nu]));
    assert(r==i);
    assert(norm(z-u)<1e-8);
end

%% toMatlab with randomized order of sets
ctrl = ctrl_orig.copy();
ctrl.optimizer.trimFunction('primal', 1);
for i = 1:ctrl.optimizer.Num
    assert(size(ctrl.optimizer.Set(i).Functions('primal').F, 1)==1);
end
idx = randperm(ctrl.optimizer.Num);
sets = ctrl.optimizer.Set(idx);
ipu = IPDPolyUnion(sets);
pu = PolyUnion(toPolyhedron(sets.copy(), false));
toMatlab(ipu, 'myipd.m', 'primal');
for i = 1:pu.Num
    ch = pu.Set(i).chebyCenter;
    [u, ~, r1] = pu.feval(ch.x, 'primal');
    [ui, ~, r2] = ipu.feval(ch.x, 'primal');
    [z, r] = myipd(ch.x);
    assert(isequal(size(z), [1 ctrl.model.nu]));
    assert(r==r1);
    assert(r==r2);
    assert(norm(z-u)<1e-8);
    assert(norm(z-ui)<1e-8);
end
% also test an infeasible point
[z, r] = myipd([100; 100]);
assert(r==0);
assert(all(isnan(z)));

end

function cleanme(pqps)
% cleanup

mptopt('pqpsolver', pqps);
!rm -f myipd.m
end

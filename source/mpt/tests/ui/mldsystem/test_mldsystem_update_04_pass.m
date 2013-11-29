function test_mldsystem_update_04_pass
% MLDSystem/update with no aux variables must pass

simple1_nocon_h3;
mld = MLDSystem(S);

% feasible initial state
mld.initialize(0);
xn = mld.update(1);
assert(xn==2);

% infeasible initial state
mld.initialize(5);
xn = mld.update(1);
assert(isnan(xn));

end

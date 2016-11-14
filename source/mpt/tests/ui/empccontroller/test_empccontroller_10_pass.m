function test_empccontroller_10_pass
% penalties defined by Function objects

Double_Integrator
model = mpt_import(sysStruct, probStruct);
model.x.penalty = Function(@(x) x'*x);
model.u.penalty = Function(@(u) u'*u);

E = MPCController(model, 5).toExplicit();
assert(E.nr==25);

end

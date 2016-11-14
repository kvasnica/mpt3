function test_empccontroller_simplify_01_pass

N = 8;
Double_Integrator;
model = mpt_import(sysStruct, probStruct);
E = EMPCController(model, N);
assert(E.nr==31);
Eorig = E.copy;

% in-place merging
E.simplify;
assert(E.nr==23);

% copy-and-merge
S = Eorig.simplify;
assert(S.nr==23);
assert(Eorig.nr==31);




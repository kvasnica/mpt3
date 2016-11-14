function test_empccontroller_02_pass
% import from sysStruct/probStruct

% LTI/mpqp
clear
Double_Integrator
model = mpt_import(sysStruct, probStruct);
E = EMPCController(model, probStruct.N);
E.display();
assert(E.isExplicit);
assert(E.nr==25);
assert(numel(E.optimizer)==1);

% LTI/mplp
clear
Double_Integrator
probStruct.norm = 1; probStruct.N = 2;
model = mpt_import(sysStruct, probStruct);
E = EMPCController(model, probStruct.N);
E.display();
assert(E.nr==28);
assert(numel(E.optimizer)==1);

% PWA/milp
clear
opt_sincos; probStruct.N = 2;
model = mpt_import(sysStruct, probStruct);
E = EMPCController(model, probStruct.N);
E.display();
assert(E.nr==22 || E.nr==18 || E.nr==16); % 22 by mpt_mplp, 16/18 with plcp (both should give same cost)
[~, ~, openloop] = E.evaluate([-5; 5]);
assert(norm(openloop.cost-10.4641016151378)<1e-10);
assert(numel(E.optimizer)==4);

% PWA/miqp
clear
opt_sincos; probStruct.N = 2; probStruct.norm = 2;
model = mpt_import(sysStruct, probStruct);
E = EMPCController(model, probStruct.N);
E.display();
assert(E.nr==10);
assert(numel(E.optimizer)==4);

end

function test_polyunion_locatePoint_02_pass
%
% double integrator
% 

Double_Integrator;

model = mpt_import(sysStruct,probStruct);

ctrl = MPCController(model, 5);
c = ctrl.toExplicit;

for i=1:c.optimizer.Num;
    x = c.optimizer.Set(i).grid(5);
    for j=1:size(x,1)
        index = c.optimizer.locatePoint(x(j,:));
        if ~c.optimizer.Set(index).contains(x(j,:))
            error('Wrong region detected.');
        end
    end
end


end
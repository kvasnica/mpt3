function test_codegen_02_pass
%
% 2D - double integrator example, penalty on delta u
% 

Double_Integrator;

model=mpt_import(sysStruct,probStruct);

% add penalty on u
model.u.with('deltaPenalty');
model.u.deltaPenalty = Penalty(1,2);

ctrl=MPCController(model,3);

c=ctrl.toExplicit;

% generate code using default name but with new directory
p=pwd;
d = fileparts(which(mfilename));
name = 'generated_code_test_02';
cd(d);
c.exportToC([],name)

% compile the files in the directory
cd(name);
mex('mpt_getInput_sfunc.c');

% run the simulation
sim('test_codegen_sim_02');

% go back to original directory
cd(p);

% delete the created directory
rmdir([d,filesep,name],'s');

% compare the results
for i=1:size(x,1)
    if norm(u(i)-c.evaluate(x(i,:)),Inf)>1e-4
        error('The results do not match! Problem with exported C-code.');
    end
end
    


end
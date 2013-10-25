function test_codegen_01_pass
%
% 2D - double integrator example, regulation
% 

Double_Integrator;

model=mpt_import(sysStruct,probStruct);

ctrl=MPCController(model,3);

c=ctrl.toExplicit;

% go to tests directory
p=pwd;
d = fileparts(which(mfilename));
cd(d);

% generate code using default name
c.exportToC;

cd('mpt_explicit_controller');
mex('mpt_getInput_sfunc.c');

% run the simulation
sim('test_codegen_sim_01');

% go back to original directory
cd(p);

% delete the created directory
onCleanup(@()clear('functions'));
onCleanup(@()rmdir([d,filesep,'mpt_explicit_controller'],'s'));

% compare the results
for i=1:size(x,1)
    if norm(u(i)-c.evaluate(x(i,:)'),Inf)>1e-4
        error('The results do not match! Problem with exported C-code.');
    end
end
    


end
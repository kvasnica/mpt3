function test_codegen_st_01_pass
%
% 2D - double integrator example, regulation, search tree
% 

Double_Integrator;

model=mpt_import(sysStruct,probStruct);

ctrl=MPCController(model,3);

c=ctrl.toExplicit;

% go to tests directory
p=pwd;
d = fileparts(which(mfilename));
cd(d);

% construct search tree
c.binaryTree;

% generate code using default name
c.exportToC;

cd('mpt_explicit_controller');
mex('mpt_getInput_sfunc.c');

% run the simulation
sim('test_codegen_sim_01');

% go back to original directory
cd(p);

% delete the created directory
onCleanup(@()cleanfiles(d,'mpt_explicit_controller'));

% compare the results
for i=1:size(x,1)
    if norm(u(i)-c.evaluate(x(i,:)'),Inf)>1e-4
        error('The results do not match! Problem with exported C-code.');
    end
end
   
end

function cleanfiles(d,name)

clear('functions');
rmdir([d,filesep,name],'s');

end
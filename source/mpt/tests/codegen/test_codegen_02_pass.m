function test_codegen_02_pass
%
% 2D - double integrator example, penalty on delta u
% 

Double_Integrator;

model=mpt_import(sysStruct,probStruct);

% add penalty on u
model.u.with('deltaPenalty');
model.u.deltaPenalty = QuadFunction(1);

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
onCleanup(@()cleanfiles(d,name));

% compare the results
u0 = 0;
for i=1:size(x,1)
    if norm(u(i)-c.evaluate(x(i,:)','u.previous',u0),Inf)>1e-4
        error('The results do not match! Problem with exported C-code.');
    end
    u0 = u(i);
end
    
end

function cleanfiles(d,name)

clear('functions');
rmdir([d,filesep,name],'s');

end
